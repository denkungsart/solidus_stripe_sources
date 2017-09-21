module SolidusStripeSources
  class ReturnsController < Spree::StoreController
    # update source + failed + is return success?
    def show
      @order = Spree::Order.find_by!(number: params[:id])
      source = Spree::StripeSource
        .find_by(
          token: params[:source],
          user_id: @order.user_id
      )
      update_source(source)

      if @order.payments.all? { |payment| payment.completed? || payment.invalid? || payment.failed? }
        redirect_to spree.order_path(@order)
      end
    end

    private
      def update_source(payment)
        SolidusStripeSources::SourceUpdater.new(payment).fetch_and_update
      end
  end
end
