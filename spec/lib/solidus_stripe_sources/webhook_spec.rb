require 'rails_helper'

module SolidusStripeSources
  describe Webhook do
    let!(:source) do
      FactoryGirl.create(
        :stripe_source,
        token: 'src_1B3QlvBxRuikat2VaYeRCaJ7',
        data: {
          client_secret: 'src_client_secret_BQHK7eWEWXE20ZciZ9VC2rUA',
          redirect: {}
        }
      )
    end

    let(:stripe_event) { Stripe::Event.construct_from(params) }
    subject { described_class.new(stripe_event, source) }

    context 'charge' do
      let(:params) { { type: 'charge.pending' } }

      it 'builds proper event handler' do
        expect(subject.event_handler)
          .to be_kind_of(SolidusStripeSources::Events::Charge)
      end
    end

    context 'source' do
      let(:params) { { type: 'source.pending' } }

      it 'builds proper event handler' do
        expect(subject.event_handler)
          .to be_kind_of(SolidusStripeSources::Events::Source)
      end
    end

    describe '#process' do
      let(:params) { { type: 'source.pending' } }
      let(:event_handler) { subject.event_handler }
      before { allow(event_handler).to receive(:payment) { payment } }

      context 'when payment in final state' do
        let(:payment) { instance_double('Spree::Payment', final_state?: true) }

        it 'does nothing' do
          expect(event_handler).not_to receive(:process)

          subject.process
        end
      end

      context 'when payment not in final state' do
        let(:payment) { instance_double('Spree::Payment', final_state?: false) }

        it 'processed payment' do
          expect(event_handler).to receive(:process)

          subject.process
        end
      end
    end
  end
end
