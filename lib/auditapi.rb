# frozen_string_literal: true

require 'addressable/uri'
require 'httparty'

require 'auditapi/errors'
require 'auditapi/version'

require 'auditapi/resources/event'

module AuditAPI
  class << self
    attr_accessor :api_key
  end
end
