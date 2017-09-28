module SolidusStripeSources
  class ReturnsController < Spree::StoreController
    def show
      @order = Spree::Order.find_by!(number: params[:id])
      source = Spree::StripeSource
               .find_by(token: params[:source], user_id: @order.user_id)

      update_source(source)
      set_flash_notice(@order, source)

      if @order.payments.all? { |payment| payment_in_final_state?(payment) }
        redirect_to spree.order_path(@order)
      end
    end

    private

    def update_source(payment)
      SolidusStripeSources::SourceUpdater.new(payment).fetch_and_update
    end

    def set_flash_notice(order, source)
      payment = order.payments.find_by(source: source)
      return if payment.nil?

      case payment.state
      when 'pending', 'processing'
        flash.notice = Spree.t(:payment_is_processing)
      when 'completed'
        flash.notice = Spree.t(:order_processed_successfully)
      when 'failed'
        flash.alert = Spree.t(:payment_processing_failed)
      end
    end

    def payment_in_final_state?(payment)
      payment.completed? || payment.invalid? || payment.failed?
    end
  end
end
