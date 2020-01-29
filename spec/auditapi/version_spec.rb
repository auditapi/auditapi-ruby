# frozen_string_literal: true

RSpec.describe 'AuditAPI::VERSION' do
  it 'has a version number' do
    expect(AuditAPI::VERSION).not_to be nil
  end
end
