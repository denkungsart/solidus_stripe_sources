module SolidusStripeSources
  class Engine < ::Rails::Engine
    isolate_namespace SolidusStripeSources
    engine_name 'solidus_stripe_sources'

    config.autoload_paths += %W(#{config.root}/lib)

    initializer "spree.gateway.payment_methods", :after => "spree.register.payment_methods" do |app|
      app.config.spree.payment_methods << Spree::PaymentMethod::StripeSofort
      Spree::PermittedAttributes.source_attributes.concat [:source, :return_url]
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare &method(:activate).to_proc
  end
end
