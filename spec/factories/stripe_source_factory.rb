FactoryGirl.define do
  factory :stripe_source, class: Spree::StripeSource do
    token 'src_1B45owBxRuikat2VMLUj1qld'
    data { {} }
    return_url 'http://localhost:3000/return'
    association(:payment_method, factory: :sofort_payment_method)
  end
end
