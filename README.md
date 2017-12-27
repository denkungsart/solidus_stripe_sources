# SolidusStripeSources
`solidus_stripe_sources` is an extension that adds support for [Stripe Sources](https://stripe.com/docs/sources) for Solidus. It supports SEPA Direct Debit, Alipay, Sofort, Giropay, iDEAL, P24.

**Supported payment methods**
- Sofort

**Supported Soludus Version**
- 2.2.x

other version of Solouds might work as well, but not guarantied.

**Note:** for now, payments are finished only by webhook, admin can't finish payments from admin interface.

## Installation
Add solidus_stripe_sources to your Gemfile:

```
gem 'solidus_stripe_sources', github: 'denkungsart/solidus_stripe_sources', branch: :master
```

Bundle your dependencies and run the installation generator:

```
bundle
bundle exec rails g solidus_stripe_sources:install
```

## Usage

**Note:**
- Stripe Sources [webhook-based](https://stripe.com/docs/sources/best-practices#the-required-use-of-webhooks) payment methods, it expects to get webhook from Stripe to process payments.
- Stripe uses **secret** and **publishable_key** for differ live from test, no additional test flag is needed.

Setup Payment Method in admin interface:
![admin_ui](https://user-images.githubusercontent.com/63340/31602352-095ef216-b25d-11e7-8bc6-35e5b127854e.png)

Setup [webhooks](https://stripe.com/docs/webhooks) in Stripe dashboard.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
