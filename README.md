# AuditAPI Ruby Library

The AuditAPI Ruby library provides convenient access to the AuditAPI API from applications written in the Ruby language.

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
# configure gem
AuditAPI.api_key = "abc123..."

# list events
AuditAPI::Event.list
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
