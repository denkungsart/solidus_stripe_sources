module SolidusStripeSources
  class RedirectsController < Spree::StoreController
    before_action :load_order, :redirect_unless_order

    def show
      flash.delete(:notice)
    end

    def create
      payment = @order.payments.find { |pt| pt.source.redirect? }
      redirect_to payment.source.redirect_url
    end

    private
      def load_order
        @order = Spree::Order.find_by(number: params[:id])
      end

      def redirect_unless_order
        redirect_back(fallback_location: spree.root_path) unless @order
      end
  end
end
