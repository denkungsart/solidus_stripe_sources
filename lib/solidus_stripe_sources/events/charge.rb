module SolidusStripeSources
  module Events
    class Charge < Base
      def process
        case event.type
        when "charge.succeeded"
          payment.capture!(payment_source.amount)
        when "charge.failed"
          payment.failure!
        end
      end
    end
  end
end
