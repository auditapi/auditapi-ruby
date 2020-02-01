# frozen_string_literal: true

module AuditAPI
  class Event < BaseObject
    VALID_PARAMS = [:start_date, :end_date, :starting_after, :ending_before, :limit, :filters, :query].freeze

    def initialize(values)
      @values = values
    end

    define_method(:id) { @values['id'] }
    define_method(:object) { @values['object'] }
    define_method(:timestamp) { @values['timestamp'] }
    define_method(:payload) { @values['payload'] }

    class << self
      def create(body)
        raise ArgumentError unless body.is_a?(Hash) && !body.empty?

        url = 'https://notify.auditapi.com'

        process_request(url, nil, body)
      end

      def list(params = {})
        raise ArgumentError unless params.is_a?(Hash)

        url = 'https://api.auditapi.com/v1/events'
        params = params.delete_if { |k, v| !VALID_PARAMS.include?(k) || v.nil? }

        process_request(url, params)
      end

      def retrieve(uuid)
        raise ArgumentError unless uuid.is_a?(String) && !uuid.strip.empty?

        url = "https://api.auditapi.com/v1/events/#{uuid}"

        process_request(url)
      end

      def search(params)
        raise ArgumentError unless params.is_a?(Hash) && !params[:query].nil? && !params[:query].strip.empty?

        url = 'https://api.auditapi.com/v1/events/search'
        params = params.delete_if { |k, v| !VALID_PARAMS.include?(k) || v.nil? }

        process_request(url, params)
      end

      private

      def process_request(url, params = {}, body = nil)
        raise AuthenticationError, 'No API key provided.' unless AuditAPI.api_key

        options = {}
        options[:body] = body.to_json unless body.nil?
        options[:headers] = {
          'Authorization' => "Bearer #{AuditAPI.api_key}",
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
