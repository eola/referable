# Referrable

Referrable provides you with a generator that happily creates a multi-tenant referral
system for your app with rewards, in just two steps.

1.
```bash
rails g referrable user && rails db:migrate
```

2.
```ruby
ReferrableReward.create! reward: 'A new car',
                         referrals_required: 10,
                         acquireable_by: 'user'
```

aaand... you're done!

```ruby
user = User.first

user.recruits
#=> #<ActiveRecord::Associations::CollectionProxy [...]>

user.recruits << User.create(name: 'Dan')
#=> #<ActiveRecord::Associations::CollectionProxy [...]>

user.referrals.count
#=> 1

user.distance_to_next_prize
#=> 9

user.percent_to_next_prize
#=> 10.0

user.last_acquired_prize.name
#=> 'nothing'
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'referrable'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install referrable

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/referrable. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Referrable project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/referrable/blob/master/CODE_OF_CONDUCT.md).
