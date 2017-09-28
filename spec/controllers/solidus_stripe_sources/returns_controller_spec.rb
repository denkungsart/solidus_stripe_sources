require 'rails_helper'

module SolidusStripeSources
  describe ReturnsController, type: :controller do
    routes { SolidusStripeSources::Engine.routes }
    let(:order) { FactoryGirl.create(:order) }
    let(:source) { FactoryGirl.create(:stripe_source, user_id: order.user.id) }
    let(:payment) { FactoryGirl.create(:sofort_payment, source: source) }

    before do
      order.payments << payment
      payment.started_processing!
    end

    describe 'GET #show' do
      before { expect(controller).to receive(:update_source).and_return(true) }
      context 'when payment in final state' do
        before { payment.update_attribute(:state, 'completed') }

        it 'redirects to orders path' do
          get :show, params: { id: order.number, source: payment.source.token }

          expect(response.status).to eq(302)
          expect(controller.flash[:notice])
            .to eq(Spree.t(:order_processed_successfully))
        end
      end

      context 'when payment is in pending state' do
        before { payment.update_attribute(:state, 'pending') }

        it 'renders show template' do
          get :show, params: { id: order.number, source: payment.source.token }

          expect(response.status).to eq(200)
          expect(controller.flash[:notice])
            .to eq(Spree.t(:payment_is_processing))
        end
      end

      context 'when payment is failed' do
        before do
          source.data['status'] = 'failed'
          source.save
        end

        it 'redirects to orders path' do
          get :show, params: { id: order.number, source: payment.source.token }

          expect(response.status).to eq(302)
          expect(controller.flash[:alert])
            .to eq(Spree.t(:payment_is_cancelled))
        end
      end
    end
  end
end
