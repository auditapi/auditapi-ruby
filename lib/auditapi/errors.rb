# frozen_string_literal: true

module AuditAPI
  class AuditAPIError < StandardError; end

  class APIError < AuditAPIError; end
  class AuthenticationError < AuditAPIError; end
  class InvalidRequestError < AuditAPIError; end
end
