require "rails_helper"

module SolidusStripeSources
  describe Webhook do
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

    let(:stripe_event) { Stripe::Event.construct_from(params) }
    subject { described_class.new(stripe_event, source) }

    context "charge" do
      let(:params) { { type: "charge.pending" } }

      it "builds proper event handler" do
        expect(subject.event_handler).to be_kind_of(SolidusStripeSources::Events::Charge)
      end
    end

    context "source" do
      let(:params) { { type: "source.pending" } }

      it "builds proper event handler" do
        expect(subject.event_handler).to be_kind_of(SolidusStripeSources::Events::Source)
      end
    end
  end
end
