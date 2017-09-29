module SolidusStripeSources
  class SourceInvalidator
    attr_reader :payment

    def initialize(payment)
      @payment = payment
    end

    def process
      if payment.source.data['status'] == 'failed'
        payment.failure!
        payment.order.cancel if payment.order.can_cancel?
      end
    end
  end
end
