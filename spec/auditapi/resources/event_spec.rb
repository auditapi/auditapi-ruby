# frozen_string_literal: true

RSpec.describe 'AuditAPI::Event' do
  before do
    AuditAPI.api_key = '1234'
  end

  describe '.create' do
    it 'requires a valid argument' do
      stub_request(:post, 'https://notify.auditapi.com').to_return(status: 200, body: {}.to_json)

      expect{AuditAPI::Event.create({foo: 'bar'})}.not_to raise_error

      [nil, {}, '', ' ', 'string', 123, true].each do |f|
        expect{AuditAPI::Event.create(f)}.to raise_error(ArgumentError)
      end
    end
  end

  describe '.list' do
    it 'requires a valid argument' do
      stub_request(:get, /https:\/\/api.auditapi.com\/v1\/events.*/).to_return(status: 200, body: {}.to_json)

      expect{AuditAPI::Event.list}.not_to raise_error
      expect{AuditAPI::Event.list({limit: 1})}.not_to raise_error

      [nil, '', ' ', 'string', 123, true].each do |f|
        expect{AuditAPI::Event.list(f)}.to raise_error(ArgumentError)
      end
    end

    it 'constructs the correct URL' do
      stub_request(:get, /https:\/\/api.auditapi.com\/v1\/events.*/).to_return(status: 200, body: {}.to_json)

      AuditAPI::Event.list(
        start_date: 1, end_date: 1,
        starting_after: 2, ending_before: 2,
        limit: 3,
        filter: 4
      )

      url = 'https://api.auditapi.com/v1/events?start_date=1&end_date=1&starting_after=2&ending_before=2&limit=3&filter=4'
      expect(WebMock).to have_requested(:get, url).once
    end
  end

  describe '.retrieve' do
    it 'requires a valid argument' do
      stub_request(:get, /https:\/\/api.auditapi.com\/v1\/events.*/).to_return(status: 200, body: {}.to_json)

      expect{AuditAPI::Event.retrieve('sample-id')}.not_to raise_error
      expect{AuditAPI::Event.retrieve}.to raise_exception(ArgumentError)
      expect{AuditAPI::Event.retrieve('')}.to raise_exception(ArgumentError)
      expect{AuditAPI::Event.retrieve(' ')}.to raise_exception(ArgumentError)
      expect{AuditAPI::Event.retrieve({foo: 'bar'})}.to raise_exception(ArgumentError)
    end
  end

  describe '.search' do
    it 'requires a valid argument' do
      stub_request(:get, /https:\/\/api.auditapi.com\/v1\/events.*/).to_return(status: 200, body: {}.to_json)

      expect{AuditAPI::Event.search(query: '123')}.not_to raise_error
      expect{AuditAPI::Event.search(query: 123)}.not_to raise_error
      expect{AuditAPI::Event.search(query: true)}.not_to raise_error
      expect{AuditAPI::Event.search(query: false)}.not_to raise_error
      expect{AuditAPI::Event.search(query: nil)}.to raise_exception(ArgumentError)
      expect{AuditAPI::Event.search(query: '')}.to raise_exception(ArgumentError)
      expect{AuditAPI::Event.search(query: ' ')}.to raise_exception(ArgumentError)
    end

    it 'constructs the correct URL' do
      stub_request(:get, /https:\/\/api.auditapi.com\/v1\/events.*/).to_return(status: 200, body: {}.to_json)

      AuditAPI::Event.search(
        start_date: 1, end_date: 1,
        starting_after: 2, ending_before: 2,
        limit: 3,
        filter: 4,
        query: 'foo'
      )

      url = 'https://api.auditapi.com/v1/events/search?start_date=1&end_date=1&starting_after=2&ending_before=2&limit=3&filter=4&query=foo'
      expect(WebMock).to have_requested(:get, url).once
    end
  end

  describe '.process_request' do
    it 'requires an api key' do
      AuditAPI.api_key = nil
      url = 'https://api.auditapi.com/v1/events'

      expect{AuditAPI::Event.send(:process_request, url: url)}.to raise_error(AuditAPI::AuthenticationError)
    end

    it 'returns a valid object on success' do
      url = 'https://api.auditapi.com/v1/events'

      body = { object: 'list', has_more: false, data: [] }
      stub_request(:get, url).to_return(status: 200, body: body.to_json)
      expect(AuditAPI::Event.send(:process_request, url: url)).to be_a_kind_of(AuditAPI::ListObject)

      body = { object: 'event', id: '', timestamp: '', payload: {} }
      stub_request(:get, url).to_return(status: 200, body: body.to_json)
      expect(AuditAPI::Event.send(:process_request, url: url)).to be_a_kind_of(AuditAPI::Event)
    end

    it 'raises an exception on error' do
      url = 'https://api.auditapi.com/v1/events'

      stub_request(:get, url).to_return(status: 500, body: '')

      expect{AuditAPI::Event.send(:process_request, url: url)}.to raise_error(AuditAPI::APIError)
    end
  end
end
