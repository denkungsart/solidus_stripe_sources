module SolidusStripeSources
  class SourceUpdater
    def initialize(source)
      @source = source
    end

    def fetch_and_update
      return if source.nil?
      connection = initialize_connection(source)
      response = connection.query(source.token)

      %i[sofort redirect].each do |key|
        source.data[key] = response[key].to_h if response[key].present?
      end
      source.data['status'] = response.status
      source.save
    end

    private

    attr_reader :source

    def initialize_connection(source)
      SolidusStripeSources::StripeConnection
        .new(source.payment_method.preferences[:secret_key])
    end
  end
end
