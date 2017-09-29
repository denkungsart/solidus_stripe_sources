module SolidusStripeSources
  # Controller responsible for user redirection after Stripe's redirection
  class ReturnsController < Spree::StoreController
    def show
      @order = Spree::Order.find_by!(number: params[:id])
      source = Spree::StripeSource
               .find_by(token: params[:source], user_id: @order.user_id)

      if update_source(source)
        payment = @order.payments.find_by(source: source)
        try_to_invalidate_order(payment)
      end

      set_flash_notice(@order, source)

      if @order.payments.all?(&:final_state?)
        redirect_to spree.order_path(@order)
      end
    end

    private

    def update_source(source)
      SolidusStripeSources::SourceUpdater.new(source).fetch_and_update
    end

    def try_to_invalidate_order(payment)
      SolidusStripeSources::SourceInvalidator.new(payment).process
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
        flash.alert = Spree.t(:payment_is_cancelled)
      end
    end

    def payment_in_final_state?(payment)
      payment.completed? || payment.invalid? || payment.failed?
    end
  end
end
