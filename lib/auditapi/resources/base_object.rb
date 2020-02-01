# frozen_string_literal: true

module AuditAPI
  class BaseObject
    def self.parse(obj, params = {})
      body = obj.is_a?(HTTParty::Response) ? JSON.parse(obj.body) : obj

      case body['object']
      when 'event'
        Event.new(body)
      when 'list'
        ListObject.new(body, params)
      end
    end
  end
end
