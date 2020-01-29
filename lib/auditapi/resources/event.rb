# frozen_string_literal: true

module AuditAPI
  class Event
    class << self
      def create(body)
        validate_api_key!
        raise ArgumentError unless body.is_a?(Hash) && !body.empty?

        url = 'https://notify.auditapi.com'

        process_request(url, body)
      end

      def list(params = {})
        validate_api_key!
        raise ArgumentError unless params.is_a?(Hash)

        uri = Addressable::URI.new
        uri.query_values = params
        url = 'https://api.auditapi.com/v1/events?' + uri.query

        process_request(url)
      end

      def retrieve(uuid)
        validate_api_key!
        raise ArgumentError unless uuid.is_a?(String) && !uuid.strip.empty?

        url = "https://api.auditapi.com/v1/events/#{uuid}"

        process_request(url)
      end

      def search(params)
        validate_api_key!
        raise ArgumentError unless params.is_a?(Hash) && !params[:query].nil? && !params[:query].strip.empty?

        uri = Addressable::URI.new
        uri.query_values = params
        url = 'https://api.auditapi.com/v1/events/search?' + uri.query

        process_request(url)
      end

      private

      def process_request(url, body = nil)
        options = {}
        options[:headers] = {
          'Authorization' => "Bearer #{AuditAPI.api_key}",
          "User-Agent" => "AuditAPI/v1 RubyBindings/#{AuditAPI::VERSION}"
        }
        options[:body] = body.to_json unless body.nil?

        response = if body.nil?
                     HTTParty.get(url, options)
                   else
                     HTTParty.post(url, options)
                   end

        case response.code
        when 200..299
          JSON.parse(response.body)
        else
          raise APIError, "API response code was #{response.code}"
        end
      end

      def validate_api_key!
        raise AuthenticationError, 'No API key provided.' unless AuditAPI.api_key
      end
    end
  end
end
