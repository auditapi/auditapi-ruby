# frozen_string_literal: true

require 'httparty'

require 'auditapi/errors'
require 'auditapi/version'

require 'auditapi/resources/base_object'
require 'auditapi/resources/event'
require 'auditapi/resources/list_object'

module AuditAPI
  class << self
    attr_accessor :api_key
  end
end
