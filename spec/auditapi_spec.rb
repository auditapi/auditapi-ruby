RSpec.describe 'AuditAPI::Event' do
  before do
    AuditAPI.api_key = '1234'
  end

  describe '.create' do
    it 'requires an api key' do
      AuditAPI.api_key = nil
      expect{AuditAPI::Event.create({foo: 'bar'})}.to raise_error(AuditAPI::AuthenticationError)
    end

    it 'requires a valid argument' do
      stub_request(:post, 'https://notify.auditapi.com').to_return(status: 200, body: {}.to_json)

      expect{AuditAPI::Event.create({foo: 'bar'})}.not_to raise_error
      expect{AuditAPI::Event.create}.to raise_error(ArgumentError)
      expect{AuditAPI::Event.create({})}.to raise_error(ArgumentError)
      expect{AuditAPI::Event.create('')}.to raise_error(ArgumentError)
      expect{AuditAPI::Event.create(' ')}.to raise_error(ArgumentError)
      expect{AuditAPI::Event.create('string')}.to raise_error(ArgumentError)
      expect{AuditAPI::Event.create(123)}.to raise_error(ArgumentError)
      expect{AuditAPI::Event.create(true)}.to raise_error(ArgumentError)
    end

    it 'returns a hash on success' do
      returned_body = {'id'=>'28d90ccf-3a6b-492e-b7e9-0aecae96311d', 'type'=>'event'}
      stub_request(:post, 'https://notify.auditapi.com').to_return(status: 200, body: returned_body.to_json)
      expect(AuditAPI::Event.create({foo: 'bar'})).to eq(returned_body)
    end

    it 'raises an exception on error' do
      stub_request(:post, 'https://notify.auditapi.com').to_return(status: 500, body: '')
      expect{AuditAPI::Event.create({foo: 'bar'})}.to raise_error(AuditAPI::APIError)
    end
  end

  describe '.list' do
    it 'requires an api key' do
      AuditAPI.api_key = nil
      expect{AuditAPI::Event.list({limit: 1})}.to raise_error(AuditAPI::AuthenticationError)
    end

    it 'requires a valid argument' do
      stub_request(:get, /https:\/\/api.auditapi.com\/v1\/events.*/).to_return(status: 200, body: {}.to_json)

      expect{AuditAPI::Event.list}.not_to raise_error
      expect{AuditAPI::Event.list({limit: 1})}.not_to raise_error
      expect{AuditAPI::Event.list('')}.to raise_error(ArgumentError)
      expect{AuditAPI::Event.list(' ')}.to raise_error(ArgumentError)
      expect{AuditAPI::Event.list('string')}.to raise_error(ArgumentError)
      expect{AuditAPI::Event.list(123)}.to raise_error(ArgumentError)
      expect{AuditAPI::Event.list(true)}.to raise_error(ArgumentError)
    end

    it 'constructs the correct URL' do
      # TODO
    end
  end

  describe '.retrieve' do
    it 'requires an api key' do
      AuditAPI.api_key = nil
      expect{AuditAPI::Event.retrieve('uuid')}.to raise_error(AuditAPI::AuthenticationError)
    end

    it 'requires a valid argument' do
      stub_request(:get, /https:\/\/api.auditapi.com\/v1\/events.*/).to_return(status: 200, body: {}.to_json)

      expect{AuditAPI::Event.retrieve('uuid')}.not_to raise_error
      expect{AuditAPI::Event.retrieve}.to raise_exception(ArgumentError)
      expect{AuditAPI::Event.retrieve('')}.to raise_exception(ArgumentError)
      expect{AuditAPI::Event.retrieve(' ')}.to raise_exception(ArgumentError)
      expect{AuditAPI::Event.retrieve({foo: 'bar'})}.to raise_exception(ArgumentError)
    end
  end

  describe '.search' do
    it 'requires an api key' do
      AuditAPI.api_key = nil
      expect{AuditAPI::Event.search({query: 'foo'})}.to raise_error(AuditAPI::AuthenticationError)
    end

    it 'requires a valid argument' do
      stub_request(:get, /https:\/\/api.auditapi.com\/v1\/events.*/).to_return(status: 200, body: {}.to_json)

      expect{AuditAPI::Event.search({query: 'foo'})}.not_to raise_error
      expect{AuditAPI::Event.search}.to raise_error(ArgumentError)
      expect{AuditAPI::Event.search({})}.to raise_error(ArgumentError)
      expect{AuditAPI::Event.search('')}.to raise_error(ArgumentError)
      expect{AuditAPI::Event.search(' ')}.to raise_error(ArgumentError)
      expect{AuditAPI::Event.search('string')}.to raise_error(ArgumentError)
      expect{AuditAPI::Event.search(123)}.to raise_error(ArgumentError)
      expect{AuditAPI::Event.search(true)}.to raise_error(ArgumentError)
    end

    it 'constructs the correct URL' do
      # TODO
    end
  end
end

RSpec.describe 'AuditAPI::VERSION' do
  it 'has a version number' do
    expect(AuditAPI::VERSION).not_to be nil
  end
end

# TODO: stub api responses
# TODO: returns proper error codes
