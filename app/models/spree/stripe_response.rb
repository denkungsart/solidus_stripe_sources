module Spree
  class StripeResponse < ActiveMerchant::Billing::Response
    class << self
      def status
        params["status"]
      end

      def build(result)
        success?(result.status) ? build_success(result) : build_failure(result)
      end

      def build_error_response(message)
        build_failure(message)
      end

      private

        def success?(status)
          %w(pending).include?(status)
        end

        def build_success(result)
          options = {
            test: !result.livemode,
            id: result.id,
            status: result.status
          }

          # TODO: make this more Stripe friendly
          params = build_params(result)
          message = I18n.t("sofort.response.#{result.status}")

          new(true, message, params, options)
        end

        def build_failure(message)
          new(false, message)
        end

        def build_params(result)
          case result.object
          when "source"
            build_source_params(result)
          when "charge"
            build_charge_params(result)
          end
        end

        def build_source_params(result)
          {
            id: result.id,
            client_secret: result.client_secret,
            sofort: result.sofort.to_h,
            redirect: result.redirect.to_h,
            flow: result.flow,
            status: result.status,
            currency: result.currency,
            amount: result.amount
          }
        end

        def build_charge_params(result)
          {
            id: result.id,
            status: result.status,
            outcome: result.outcome.to_h,
            amount: result.amount,
            currency: result.currency
          }
        end
    end
  end
end
