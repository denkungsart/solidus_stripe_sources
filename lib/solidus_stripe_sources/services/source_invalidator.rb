module SolidusStripeSources
  class SourceInvalidator
    attr_reader :payment

    def initialize(payment)
      @payment = payment
    end

    def process
      payment.failure! if payment.source.data['status'] == 'failed'
    end
  end
end
