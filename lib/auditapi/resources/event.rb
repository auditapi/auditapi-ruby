module AuditAPI
  class Event
    class << self
      def create(payload)
        validate_api_key!
        raise ArgumentError unless payload.is_a?(Hash) && !payload.empty?

        url = 'https://notify.auditapi.com'
        options = {
          body: payload.to_json,
          headers: { 'Authorization' => "Bearer #{AuditAPI.api_key}" }
        }
        response = HTTParty.post(url, options)
        JSON.parse(response.body)
      end

      def list(params = {})
        validate_api_key!
        raise ArgumentError unless params.is_a?(Hash)

        uri = Addressable::URI.new
        uri.query_values = params
        url = 'https://api.auditapi.com/v1/events?' + uri.query
        options = {
          headers: { 'Authorization' => "Bearer #{AuditAPI.api_key}" }
        }
        response = HTTParty.get(url, options)
        JSON.parse(response.body)
      end

      def retrieve(uuid)
        validate_api_key!
        raise ArgumentError unless uuid.is_a?(String) && !uuid.strip.empty?

        url = "https://api.auditapi.com/v1/events/#{uuid}"
        options = {
          headers: { 'Authorization' => "Bearer #{AuditAPI.api_key}" }
        }
        response = HTTParty.get(url, options)
        JSON.parse(response.body)
      end

      def search(params)
        validate_api_key!
        raise ArgumentError unless params.is_a?(Hash) && !params[:query].nil? && !params[:query].strip.empty?

        uri = Addressable::URI.new
        uri.query_values = params
        url = 'https://api.auditapi.com/v1/events/search?' + uri.query
        options = {
          headers: { 'Authorization' => "Bearer #{AuditAPI.api_key}" }
        }
        response = HTTParty.get(url, options)
        JSON.parse(response.body)
      end

      private

      def validate_api_key!
        unless AuditAPI.api_key
          raise AuthenticationError, 'No API key provided.'
        end
      end
    end
  end
end
