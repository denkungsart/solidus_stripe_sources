module Spree
  class StripeSource < Spree::PaymentSource
    serialize :data, Hash

    belongs_to :user, class_name: Spree::UserClassHandle.new, foreign_key: 'user_id'
    belongs_to :payment_method, class_name: 'Spree::PaymentMethod'
    has_many :payments, as: :source, class_name: "Spree::Payment"

    def actions
      %w(authorize capture refund)
    end

    def redirect?
      %w(redirect).include?(data.dig(:flow))
    end

    def redirect_success?
      data.dig(:redirect, :status) == "succeeded"
    end

    def redirect_url
      data.dig(:redirect, :url)
    end

    def client_secret
      data[:client_secret]
    end

    def amount
      data[:amount]
    end

    def currency
      data[:currency]
    end

    def capture_details
      data[:capture]
    end
  end
end
