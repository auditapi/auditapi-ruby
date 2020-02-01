# frozen_string_literal: true

module AuditAPI
  class ListObject < BaseObject
    def initialize(values, params)
      @values = values
      @values['data']&.map! { |f| BaseObject.parse(f) }
      @params = params
    end

    define_method(:object) { @values['object'] }
    define_method(:has_more) { @values['has_more'] }
    define_method(:has_more?) { @values['has_more'] }
    define_method(:data) { @values['data'] }
    define_method(:params) { @params }

    def previous_page
      return ListObject.new({}, {}) unless has_more?

      params.delete(:starting_after)
      params[:ending_before] = data.first.id

      AuditAPI::Event.list(params)
    end

    def next_page
      return ListObject.new({}, {}) unless has_more?

      params[:starting_after] = data.last.id
      params.delete(:ending_before)

      AuditAPI::Event.list(params)
    end
  end
end
