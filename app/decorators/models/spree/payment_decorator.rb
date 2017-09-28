module Spree
  module PaymentDecorator
    def capture_request!
      handle_payment_preconditions { process_capture_request }
    end

    def final_state?
      completed? || invalid? || failed?
    end

    private

    def process_capture_request
      response = payment_method.capture_request(source)
      started_processing! if response.success?
    end
  end
end

Spree::Payment.prepend(Spree::PaymentDecorator)
