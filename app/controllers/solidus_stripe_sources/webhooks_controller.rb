# NOTE: Fix issue when main app didn't load Webhook class
require "solidus_stripe_sources/webhook"

module SolidusStripeSources
  class WebhooksController < ApplicationController
    protect_from_forgery except: :stripe

    before_action :load_provider
    respond_to :json

    # https://stripe.com/docs/webhooks
    def stripe
      if @provider
        event = SolidusStripeSources::Webhook
          .build_event(
            request.body.read,
            request.env["HTTP_STRIPE_SIGNATURE"],
            @provider.payment_method.preferences[:webhook_secret]
          )

        if SolidusStripeSources::Webhook::SUPPORTED_EVENTS.include?(event.type)
          webhook = SolidusStripeSources::Webhook.new(event, @provider)
          webhook.process
        end
      end

      render body: nil, status: 200
    end

    private
      def load_provider
        # TODO: how to fetch source token
        if params.dig("data", "object", "object") == "source"
          token = params.dig("data", "object", "id")
        else
          token = params.dig("data", "object", "source", "id")
        end
        @provider ||= Spree::StripeSource.find_by(token: token)
      end
  end
end
