require "rails_helper"

module SolidusStripeSources
  describe SourceUpdater, :vcr do
    let(:source) do
      FactoryGirl.create(
        :stripe_source,
        token: "src_1B4AtTBxRuikat2Vie9Pd6eP"
      )
    end
    let(:payment) { FactoryGirl.create(:sofort_payment, source: source) }
    subject { described_class.new(payment.source) }

    describe "#fetch_and_update" do
      it "fetches source data and updates payment source" do
        subject.fetch_and_update

        expect(source.data.dig(:sofort, :bank_name)).to eq("Deutsche Bank")
        expect(source.data.dig(:redirect, :status)).to eq("succeeded")
      end

      context "when source is not present" do
        before { payment.update_attribute(:source, nil) }

        it "does nothing" do
          expect { subject.fetch_and_update }.not_to raise_error
        end
      end
    end
  end
end
