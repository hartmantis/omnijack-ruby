Omnijack
========

[![Gem Version](https://badge.fury.io/rb/omnijack.png)][fury]
[![Build Status](http://img.shields.io/travis/RoboticCheese/omnijack-ruby.svg)][travis]
[![Code Climate](http://img.shields.io/codeclimate/github/kabisaict/flow.svg)][codeclimate]
[![Coverage Status](http://img.shields.io/coveralls/RoboticCheese/omnijack-ruby.svg)][coveralls]
[![Dependency Status](http://img.shields.io/gemnasium/RoboticCheese/omnijack-ruby.svg)][gemnasium]

[fury]: http://badge.fury.io/rb/omnijack
[travis]: http://travis-ci.org/RoboticCheese/omnijack-ruby
[codeclimate]: https://codeclimate.com/github/RoboticCheese/omnijack-ruby
[coveralls]: https://coveralls.io/r/RoboticCheese/omnijack-ruby
[gemnasium]: https://gemnasium.com/RoboticCheese/omnijack-ruby

A Ruby client interface to Chef's
[Omnitruck](https://github.com/opscode/opscode-omnitruck) API.

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
require 'omnijack'

chef_dk = Omnijack::Project::ChefDk.new
metadata = chef_dk.metadata

puts metadata

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
Getting Chef-DK project data from an unofficial Omnitruck API:

```ruby
Omnijack::Project::ChefDk.new(
  base_url: 'https://some.custom.chef.api/endpoint'
)
```

Getting Chef-DK project data for a version other than the latest release:

```ruby
Omnijack::Project::ChefDk.new(
  version: '1.2.3',
  prerelease: true,
  nightlies: true
)
```

Getting Chef-DK project data for a platform other than the one running:

```ruby
Omnijack::Project::ChefDk.new(
  platform: 'ubuntu',
  platform_version: '14.04',
  machine_arch: 'x86_64'
)
```

Getting the Chef project's list of packages:

```ruby
list = Omnijack::Project::Chef.new.list
puts list.to_h
```

Getting the Chef project's platform mappings:

```ruby
platforms = Omnijack::Project::Chef.new.platforms
puts platforms.to_h
```

Getting AngryChef project data:

```ruby
Omnijack::Project::AngryChef.new
```
Getting Chef project data:

```ruby
Omnijack::Project::Chef.new
```

Getting Chef-Container project data:

```ruby
Omnijack::Project::Container.new
```

Getting Chef Server project data:

```ruby
Omnijack::Project::Server.new
```

Contributing
------------

1. Fork it ( https://github.com/[my-github-username]/omnijack/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
