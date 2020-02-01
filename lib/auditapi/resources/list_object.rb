# frozen_string_literal: true

module AuditAPI
  class ListObject < BaseObject
    def initialize(values)
      @values = values
      @values['data'].map! { |f| BaseObject.parse(f) }
    end

    define_method(:object) { @values['object'] }
    define_method(:has_more) { @values['has_more'] }
    define_method(:has_more?) { @values['has_more'] }
    define_method(:data) { @values['data'] }

    def previous_page
      return ListObject.new({}) unless has_more?

      first_id = data.first.id

      AuditAPI::Event.list(ending_before: first_id)
    end

    def next_page
      return ListObject.new({}) unless has_more?

      last_id = data.last.id

      AuditAPI::Event.list(starting_after: last_id)
    end
  end
end
