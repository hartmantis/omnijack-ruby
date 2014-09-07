Omnijack
========

[![Gem Version](https://badge.fury.io/rb/omnijack.png)][fury]
[![Build Status](http://img.shields.io/travis/RoboticCheese/omnijack-ruby.svg)][travis]
[![Code Climate](http://img.shields.io/codeclimate/github/kabisaict/flow.svg)][codeclimate]
[![Coverage Status](http://img.shields.io/coveralls/RoboticCheese/omnijack-ruby.svg)][coveralls]
[![Dependency Status](http://img.shields.io/gemnasium/RoboticCheese/omnijack.svg)][gemnasium]

[fury]: http://badge.fury.io/rb/omnijack
[travis]: http://travis-ci.org/RoboticCheese/omnijack-ruby
[codeclimate]: https://codeclimate.com/github/RoboticCheese/omnijack-ruby
[coveralls]: https://coveralls.io/r/RoboticCheese/omnijack-ruby
[gemnasium]: https://gemnasium.com/RoboticCheese/omnijack-ruby

A Ruby client interface to Chef's
[Omnitruck](https://github.com/opscode/opscode-omnitruck) API.

A pallet jack to get the boxes out of the Omnitruck.

Installation
------------

Add this line to your application's Gemfile:

```ruby
gem 'omnijack'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omnijack

Usage
-----

Getting Chef-DK package metadata from the official Chef API:

```ruby
metadata = Omnijack::Metadata::ChefDk.new

puts metadata.url
puts metadata.filename
puts metadata.md5
puts metadata.sha256
puts metadata.yolo
puts metadata[:url]
puts metadata[:filename]
puts metadata[:md5]
puts metadata[:sha256]
puts metadata[:yolo]
```

Getting Chef-DK package metadata from an unofficial Omnitruck API:

```ruby
metadata = Omnijack::Metadata::ChefDk.new('http://yoursite.example.com/chef')
```

TODO: Example usage scenarios that this project should support:

```ruby
metadata = Omnijack::Chef.new
```

```ruby
metadata = Omnijack::AngryChef.new
```

```ruby
metadata = Omnijack::Server.new
```

```ruby
metadata = Omnijack::ChefDk.new
```

```ruby
metadata = Omnijack::Container.new
```

```ruby
metadata = Omnijack.new(project = :container)
```

```ruby
metadata = Omnijack.new.container
puts metadata.url
puts metadata.md5
puts metadata.sha256
puts metadata.yolo
```

Contributing
------------

1. Fork it ( https://github.com/[my-github-username]/omnijack/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
