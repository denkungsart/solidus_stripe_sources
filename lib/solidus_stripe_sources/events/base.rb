module SolidusStripeSources
  module Events
    class Base
      attr_reader :event, :payment_source, :payment_method

      def initialize(event, payment_source)
        @event = event
        @payment_source = payment_source
        @payment_method = payment_source.payment_method
      end

      # source should have 1 payment
      def payment
        @payment ||= payment_source.payments.first
      end
    end
  end
end
