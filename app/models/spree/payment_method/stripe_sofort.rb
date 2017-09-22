require "stripe"

module Spree
  class PaymentMethod::StripeSofort < Spree::PaymentMethod
    preference :secret_key, :string
    preference :publishable_key, :string
    preference :webhook_secret, :string

    if SolidusSupport.solidus_gem_version < Gem::Version.new('2.3.x')
      def method_type
        'stripe_sofort'
      end
    else
      def partial_name
        'stripe_sofort'
      end
    end

    def payment_source_class
      StripeSource
    end

    def auto_capture?
      false
    end

    def supported_countries
      %w(AT BE DE ES IT)
    end

    def support_country?(country_iso)
      supported_countries.include?(country_iso)
    end

    def authorize(money, source, gateway_options)
      response = create_source(money, gateway_options)
      update_source(source, response) and response
    end

    # Send request to Stripe for processing
    # No actual charge will be done
    # Waiting for notification
    def capture_request(source)
      response = charge_source(source.amount, source.token, source.currency)
      update_capture(source, response) and response
    end

    # Fake charge will move payment to complete
    def capture(*_args)
      ActiveMerchant::Billing::Response.new(true, "", {}, {})
    end

    private
      def connection
        @connection ||= SolidusStripeSources::StripeConnection.new(preferences[:secret_key])
      end

      def send_request
        response = yield
        StripeResponse.build(response)
      rescue => e
        StripeResponse.build_error_response(e.message)
      end

      def create_source(money, gateway_options)
        return_url = gateway_options[:originator].source.return_url
        order = gateway_options[:originator].order

        send_request do
          connection.create_source(
            type: "sofort",
            amount: money,
            currency: gateway_options[:currency],
            owner: {
              email: gateway_options[:customer],
              name: gateway_options.dig(:billing_address, :name)
            },
            metadata: { order_id: order.number },
            redirect: { return_url: return_url },
            sofort: { country: gateway_options.dig(:billing_address, :country) },
            statement_descriptor: "Spree Order ID: #{gateway_options[:order_id]}"
          )
        end
      end

      def charge_source(money, token, currency)
        send_request do
          connection.charge_source(
            amount: money,
            currency: currency,
            source: token
          )
        end
      end

      # TODO: to make general source / capture update
      def update_source(payment, response)
        new_data = {}.tap do |hsh|
          %w(amount status currency redirect flow sofort client_secret id).each do |key|
            hsh[key.to_sym] = response.params[key]
          end
        end

        payment.update_attributes(token: new_data[:id], data: new_data)
      end

      def update_capture(payment, response)
        payment.data[:capture] = response.params
        payment.save
      end
  end
end
