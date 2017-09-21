require "rails_helper"

module Spree
  describe PaymentMethod::StripeSofort, vcr: true do
    let(:payment) { FactoryGirl.create(:sofort_payment) }
    let(:sofort) { payment.payment_method }
    let(:gateway_options) do
      {
        currency: "eur",
        customer: "john.snow@thewall.com",
        originator: payment,
        billing_address: {
          name: "Dick Grayson",
          country: "DE"
        }
      }
    end

    describe "#authorize" do
      it "creates source and saves response" do
        response = sofort.authorize(995, payment.source, gateway_options)

        expect(response.success?).to eq(true)
        expect(response.message).to match(/pending/)

        payment_source = payment.source
        expect(payment_source.token).not_to eq(nil)
        expect(payment_source.redirect?).to eq(true)
        expect(payment_source.redirect_success?).to eq(false)
        expect(payment_source.redirect_url).not_to eq(nil)
        expect(payment_source.amount).to eq(995)
      end
    end

    describe "#capture_request" do
      before { sofort.authorize(885, payment.source, gateway_options) }

      it "makes capture request and proceesses payment" do
        response = sofort.capture_request(payment.source)
        expect(response.success?).to eq(true)

        capture_details = payment.source.capture_details
        expect(capture_details["status"]).to eq("pending")
        expect(capture_details["amount"]).to eq(885)
      end
    end

    describe "#capture" do
      before { payment.started_processing! }

      it "moves payment to complete state" do
        response = sofort.capture({})

        expect(response.success?).to eq(true)
      end
    end
  end
end
