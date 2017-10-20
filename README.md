# Referable

Referable provides you with a generator that happily creates a multi-tenant referral
system for your app with rewards, in just two steps.

1.
```bash
rails g referable user && rails db:migrate
```

2.
```ruby
ReferableReward.create! reward: 'A new car',
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

user.distance_to_next_reward
#=> 9

user.percent_to_next_reward
#=> 10.0

user.last_acquired_reward.name
#=> 'nothing'
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'referable'
```

And then execute:

    $ bundle

Or install it yourself:
```bash
gem install referable
```

## Usage

The generator modifies an existing Rails model to allow referral functionality. The model
does not need to have any other dependencies.

To enable referrals for a specific model, run
```bash
rails generate referable name_of_model
```

This will create the necessary migration(s). Next, check the contents of the migrations.
Notably, the _add_referral_fields_to_XXX_ migration, as this updates each record for your
model with a referral slug.

Then,
```bash
rails db:migrate
```

This can be added for any number of models in your application.

### Creating rewards

Rewards are set for each model type individually. IE a President will have a different set
of rewards to a PrimeMinister.

Creating rewards is as simple as:
```ruby
ReferableReward.create! reward: 'A new car',
                        referrals_required: 10,
                        acquireable_by: 'user'
```

### Callback when model reaches a reward

Want to notify someone or do something when a user acquires a new reward?
Just hook in to `Referable#acquired_reward!`

### Adding a recruit in devise

At [eola](https://eola.co.uk), we hook in to the `Devise::RegistrationsController#post`
action, checking for the referral slug in the params. If it exists, the user is given
the new recruit.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/referable. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Referable project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/referable/blob/master/CODE_OF_CONDUCT.md).
