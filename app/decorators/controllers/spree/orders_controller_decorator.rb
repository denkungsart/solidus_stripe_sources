Spree::OrdersController.class_eval do
  before_action :redirect_or_complete_order, only: :show

  private
    # TODO: better redirect source fetching
    def redirect_or_complete_order
      @order = Spree::Order.find_by_number!(params[:id])
      payment = @order.payments.find { |pt| pt.source && pt.source.redirect? && !pt.source.redirect_success? }

      if @order.complete? && payment&.pending?
        redirect_to solidus_stripe_sources.redirect_path(@order.number) and return
      end
    end
end
