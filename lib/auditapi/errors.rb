module AuditAPI
  class AuditAPIError < StandardError; end
  class AuthenticationError < AuditAPIError; end
end
