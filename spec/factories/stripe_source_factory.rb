FactoryGirl.define do
  factory :stripe_source, class: Spree::StripeSource do
    data {{}}
    return_url "http://localhost:3000/return"
    association(:payment_method, factory: :sofort_payment_method)
  end
end
