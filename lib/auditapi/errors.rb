module AuditAPI
  class AuditAPIError < StandardError; end

  class APIError < AuditAPIError; end
  class AuthenticationError < AuditAPIError; end
end
