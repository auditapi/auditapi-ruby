# frozen_string_literal: true

module AuditAPI
  class Event < BaseObject
    def initialize(values)
      @values = values
    end

    define_method(:id) { @values['id'] }
    define_method(:object) { @values['object'] }
    define_method(:timestamp) { @values['timestamp'] }
    define_method(:payload) { @values['payload'] }

    class << self
      def create(body, api_key: nil)
        raise ArgumentError unless body.is_a?(Hash) && !body.empty?

        url = 'https://notify.auditapi.com'

        process_request(url: url, body: body, api_key: api_key)
      end

      def list(start_date: nil, end_date: nil, starting_after: nil, ending_before: nil, limit: nil, filters: nil, api_key: nil)
        url = 'https://api.auditapi.com/v1/events'

        params = {
          start_date: start_date,
          end_date: end_date,
          starting_after: starting_after,
          ending_before: ending_before,
          limit: limit,
          filters: filters
        }

        process_request(url: url, params: params, api_key: api_key)
      end

      def retrieve(id, api_key: nil)
        raise ArgumentError unless id.is_a?(String) && !id.strip.empty?

        url = "https://api.auditapi.com/v1/events/#{id}"

        process_request(url: url, api_key: api_key)
      end

      def search(start_date: nil, end_date: nil, starting_after: nil, ending_before: nil, limit: nil, filters: nil, query:, api_key: nil)
        raise ArgumentError unless !query.strip.empty?

        url = 'https://api.auditapi.com/v1/events/search'

        params = {
          start_date: start_date,
          end_date: end_date,
          starting_after: starting_after,
          ending_before: ending_before,
          limit: limit,
          filters: filters,
          query: query
        }

        process_request(url: url, params: params, api_key: api_key)
      end

      private

      def process_request(url:, params: {}, body: nil, api_key: nil)
        raise AuthenticationError, 'No API key provided.' if AuditAPI.api_key.nil? && api_key.nil?

        options = {}
        options[:body] = body.to_json unless body.nil?
        options[:headers] = {
          'Authorization' => "Bearer #{api_key || AuditAPI.api_key}",
          "User-Agent" => "AuditAPI/v1 RubyBindings/#{AuditAPI::VERSION}"
        }
        options[:query] = params

        response = if body.nil?
                     HTTParty.get(url, options)
                   else
                     HTTParty.post(url, options)
                   end

        case response.code
        when 200..299
          BaseObject.parse(response, params)
        else
          raise APIError, "API response code was #{response.code}"
        end
      end
    end
  end
end
