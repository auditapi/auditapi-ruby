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

        process_request(url, body)
      end

      def list(params = {})
        raise ArgumentError unless params.is_a?(Hash)

        uri = Addressable::URI.new
        uri.query_values = params.delete_if { |k, v| !VALID_PARAMS.include?(k) || v.nil? }
        url = 'https://api.auditapi.com/v1/events?' + uri.query

        process_request(url)
      end

      def retrieve(uuid)
        raise ArgumentError unless uuid.is_a?(String) && !uuid.strip.empty?

        url = "https://api.auditapi.com/v1/events/#{uuid}"

        process_request(url)
      end

      def search(params)
        raise ArgumentError unless params.is_a?(Hash) && !params[:query].nil? && !params[:query].strip.empty?

        uri = Addressable::URI.new
        uri.query_values = params.delete_if { |k, v| !VALID_PARAMS.include?(k) || v.nil? }
        url = 'https://api.auditapi.com/v1/events/search?' + uri.query

        process_request(url)
      end

      private

      def process_request(url, body = nil)
        raise AuthenticationError, 'No API key provided.' unless AuditAPI.api_key

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
          BaseObject.parse(response)
        else
          raise APIError, "API response code was #{response.code}"
        end
      end
    end
  end
end
