module SolidusStripeSources
  class ReturnsController < Spree::StoreController
    def show
      @order = Spree::Order.find_by!(number: params[:id])
      source = Spree::StripeSource
        .find_by(
          token: params[:source],
          user_id: @order.user_id
      )
      update_source(source)
      set_pending_flash_notice

      if @order.payments.all? { |payment| payment.completed? || payment.invalid? || payment.failed? }
        redirect_to spree.order_path(@order)
      end
    end

    private
      def update_source(payment)
        SolidusStripeSources::SourceUpdater.new(payment).fetch_and_update
      end

      def set_pending_flash_notice
        flash.notice = Spree.t(:order_processing)
      end
  end
end
