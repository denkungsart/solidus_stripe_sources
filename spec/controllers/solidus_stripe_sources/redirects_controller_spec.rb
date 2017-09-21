require "rails_helper"

module SolidusStripeSources
  describe RedirectsController, type: :controller do
    routes { SolidusStripeSources::Engine.routes }
    let(:order) { FactoryGirl.create(:order) }
    let(:payment) { FactoryGirl.create(:sofort_payment) }

    before { order.payments << payment }

    describe "GET #show" do
      it "loads order" do
        get :show, params: { id: order.number }

        expect(response.status).to eq(200)
      end

      context "when order not found" do
        it "redirects back" do
          get :show, params: { id: 0 }

          expect(response.status).to eq(302)
          expect(response.status).to redirect_to("/")
        end
      end
    end

    describe "POST #create" do
      before do
        payment.source.update_attribute(
          :data,
          {
            redirect: {
              return_url: "http://localhost:3000/returns?id=R227409985",
              status: "pending",
              url: "https://hooks.stripe.com/redirect/authenticate/xxx?client_secret=xxx"
            },
            flow: "redirect"
          }
        )
      end

      it "redirects to provider" do
        post :create, params: { id: order.number }

        expect(response.status).to eq(302)
        expect(response.status).to redirect_to(payment.source.redirect_url)
      end

      context "when order not found" do
        it "redirects back" do
          post :create, params: { id: 0 }

          expect(response.status).to eq(302)
          expect(response.status).to redirect_to("/")
        end
      end
    end
  end
end
