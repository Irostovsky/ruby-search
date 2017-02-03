# Description:
https://github.com/Irostovsky/ruby-search/blob/master/Programming%20problem.pdf

![alt tag](https://github.com/Irostovsky/ruby-search/blob/master/Programming%20problem-page-001.jpg)

# Ruby::Search

How to use this gem:

1. install bundler if not instaled( ```bundler init```)
2. Add ```gem 'ruby-search', git: 'git@github.com:Irostovsky/ruby-search.git'``` to the Gemfile
3. run ```bundle install```
4. in the folder add some text files to test.
5. run ```bundle exec index %{filename}```. For each file separatelly. Check that index.yml is added and changed
6. to search run ```bundle exec search my super string```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby-search'
```

As to check file is binary we used: https://github.com/blackwinter/ruby-filemagic, please add native libs:

* Debian/Ubuntu:: ```libmagic-dev```
* Fedora/SuSE::   ```file-devel```
* Gentoo::        ```sys-libs/libmagic```
* OS X::          ```brew install libmagic```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby-search


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Ivan Rostovsky/ruby-search. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

