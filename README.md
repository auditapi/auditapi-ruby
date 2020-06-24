# AuditAPI Ruby Library

The AuditAPI Ruby library provides convenient access to the AuditAPI API from applications written in the Ruby language.

## Documentation
See the [Ruby API docs](https://www.auditapi.com/docs/api?ruby).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'auditapi'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install auditapi

## Usage

```ruby
require "auditapi"
AuditAPI.api_key = "abc123..."

# list events
AuditAPI::Event.list

# retrieve a single event
AuditAPI::Event.retrieve("event_id...")

# create an event
AuditAPI::Event.create({foo: 'bar'})

# search for events
AuditAPI::Event.search(query: 'foo')
```

## Development

Run all tests:

```sh
bundle exec rspec
```

Run the linter:

```sh
bundle exec rubocop
```
