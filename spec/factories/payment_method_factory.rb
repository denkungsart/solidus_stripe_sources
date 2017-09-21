FactoryGirl.define do
  factory :sofort_payment_method, class: Spree::PaymentMethod::StripeSofort do
    name "SOFORT"
    preferences {
      {
        secret_key: ENV["STRIPE_PRIVATE_KEY"],
        publishable_key: ENV["STRIPE_PUBLIC_KEY"],
        webhook_secret: ENV["STRIPE_WEBHOOK_SECRET"]
      }
    }
  end
end
