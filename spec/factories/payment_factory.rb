require 'spree/testing_support/factories/order_factory'
require 'spree/testing_support/factories/payment_factory'

FactoryGirl.define do
  factory :sofort_payment, class: Spree::Payment, parent: :payment do
    association(:payment_method, factory: :sofort_payment_method)
    association(:source, factory: :stripe_source)
  end
end
