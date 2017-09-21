module SolidusStripeSources
  class Webhook
    # https://stripe.com/docs/sources/sofort
    SUPPORTED_EVENTS = %w(
      source.chargeable
      source.failed
      source.canceled
      charge.succeeded
      charge.failed
    ).freeze

    def self.build_event(body, signature, secret_key)
      Stripe::Webhook.construct_event(body, signature, secret_key)
    end

    attr_reader :event, :payment_source

    def initialize(stripe_event, payment_source)
      @event = stripe_event
      @payment_source = payment_source
    end

    def event_handler
      event_object = event.type.split(".").first
      raise "Unsupported object" unless event_object

      @event_handler ||= "SolidusStripeSources::Events::#{event_object.capitalize}"
        .constantize.new(event, payment_source)
    end

    def process
      # TODO: source pending - nothing, invalid/cancel - invalid payment
      # TODO: charge success - process, invalid/cancel - invalid
      event_handler.process
    end
  end
end
