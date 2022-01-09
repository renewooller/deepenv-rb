# Deepenv

[Best practice](https://12factor.net/config) demands that configuration that changes across environments should be contained in the environment rather than in code. This helps with security, managing environments, portability and open-source development.

Unfortunately environment variables are **flat** string key-value pairs, whereas most apps organise their configuration in **deeply nested** objects. Environment variable names cannot include symbols to indicate nesting. 

This means backend developers have to take environment variables such as
```bash
MYAPP_MYDATASTORE_CONNECTION_RETRY_INTERVAL=5s
```

are manually wire them into the configuration object.

## Installation

Add the deepenv gem:

    $ bundle add deepenv

this adds deepenv to your Gemfile and runs bundle install
## Usage



## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/deepenv. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/deepenv/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Deepenv project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/deepenv/blob/master/CODE_OF_CONDUCT.md).
