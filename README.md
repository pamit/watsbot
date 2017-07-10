# Watsbot

[![Gem Version](https://badge.fury.io/rb/watsbot.svg)](https://badge.fury.io/rb/watsbot)
[![Build Status](https://travis-ci.org/pamit/watsbot.svg?branch=master)](https://travis-ci.org/pamit/watsbot)

Talk to [IBM Watson Conversation service](https://www.ibm.com/watson/developercloud/doc/conversation/getting-started.html)!

This gem provides a simple client to communicate with IBM Watson Conversation service using REST API. It utilizes [Redis](https://redis.io/) to store state of the conversation.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'watsbot'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install watsbot

## Requirements

* Redis server ([https://redis.io/topics/quickstart](https://redis.io/topics/quickstart))

## Examples

```ruby
require 'watsbot'

# config/initializers/watsbot.rb
Watsbot::Configuration.new(
  username:  ENV["WATSON_USERNAME"],
  password:  ENV["WATSON_PASSWORD"],
  workspace: ENV["WATSON_WORKSPACE"],
  version:   ENV["WATSON_WORKSPACE_VERSION"],
  redis_url: ENV["REDIS_URL"] # redis://127.0.0.1:6379/2
  )

watsbot = Watsbot::Message.new

# To start a conversation/send a message without context
watsbot.send("A UNIQUE IDENTIFIER, e.g. uuid", "Hi")

# To send a message with custom context variable (NOTICE THAT THE PREVIOUS CONTEXT IS SENT AUTOMATICALLY)
watsbot.send("A UNIQUE IDENTIFIER, e.g. uuid", "Hi", { context: { user_name: "...", ... } })

# To terminate a conversation (delete the state)
watsbot.send("A UNIQUE IDENTIFIER, e.g. uuid", "Hi", { terminated: true })

# To get the current state (context)
Watsbot::State.instance.fetch("THE UNIQUE IDENTIFIER")
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pamit/watsbot.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
