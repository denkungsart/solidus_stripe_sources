require "rails_helper"

module SolidusStripeSources
  describe WebhooksController, type: :controller do
    routes { SolidusStripeSources::Engine.routes }
    let!(:source) do
      FactoryGirl.create(
        :stripe_source,
        token: "src_1B3QlvBxRuikat2VaYeRCaJ7",
        data: {
          client_secret: "src_client_secret_BQHK7eWEWXE20ZciZ9VC2rUA",
          redirect: {}
        }
      )
    end
    let(:payment) { FactoryGirl.create(:sofort_payment, source: source) }
    let(:order) { OrderWalkthrough.up_to(:payment) }

    before do
      allow(SolidusStripeSources::Webhook)
        .to receive(:build_event)
        .and_return(OpenStruct.new(request))
      source.update_attribute(:payment_method, payment.payment_method)
      order.payments << payment
    end

    describe "POST #stripe" do
      let(:request) do
        {
          "object": "event",
          "type": "source.chargeable",
          "data": {
            "object": {
              "id": "src_1B3QlvBxRuikat2VaYeRCaJ7",
              "object": "source",
              "flow": "redirect",
              "livemode": false,
              "metadata": { "order_id": order.number },
              "status": "chargeable",
            }
          }
        }
      end

      context "supported event type" do
        it "parses stripe response" do
          expect(SolidusStripeSources::Webhook)
            .to receive_message_chain(:new, :process)

          post :stripe, params: request

          expect(response.body).to eq("")
          expect(response.status).to eq(200)
        end
      end

      context "supported event type" do
        let(:request) do
          {
            "object": "event",
            "type": "customer.created"
          }
        end

        it "parses stripe response" do
          expect(SolidusStripeSources::Webhook).not_to receive(:new)

          post :stripe, params: request

          expect(response.body).to eq("")
          expect(response.status).to eq(200)
        end
      end

      context "source not found" do
        it "does nothing" do
          request[:data][:object][:id] = "src_xxxx"
          expect(SolidusStripeSources::Webhook).not_to receive(:new)

          post :stripe, params: request

          expect(response.body).to eq("")
          expect(response.status).to eq(200)
        end
      end

    end
  end
end
