module SolidusStripeSources
  module Events
    class Source < Base
      def process
        case event.type
        when "source.chargeable"
          payment.capture_request!
        when "source.failed"
          payment.failure!
        when "source.canceled"
          # NOTE: temporary solution
          payment.invalidate! if payment.can_invalidate?
        when "source.pending"
          payment.pend!
        end
      end
    end
  end
end
