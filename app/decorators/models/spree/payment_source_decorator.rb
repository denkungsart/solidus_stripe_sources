module Spree
  module PaymentSourceDecorator
    def redirect?
      false
    end

    def redirect_success?
      true
    end
  end
end

Spree::PaymentSource.prepend(Spree::PaymentSourceDecorator)
