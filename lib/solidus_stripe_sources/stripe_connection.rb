module SolidusStripeSources
  class StripeConnection
    def initialize(api_key)
      Stripe.api_key = api_key
    end

    def query(token)
      Stripe::Source.retrieve(token)
    end

    def create_source(params)
      Stripe::Source.create(params)
    end

    def charge_source(params)
      Stripe::Charge.create(params)
    end
  end
end
