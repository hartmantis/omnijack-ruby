[![Gem Version](https://img.shields.io/gem/v/omnijack.svg)][gem]
[![Build Status](https://img.shields.io/travis/RoboticCheese/omnijack-ruby.svg)][travis]
[![Code Climate](https://img.shields.io/codeclimate/github/RoboticCheese/omnijack-ruby.svg)][codeclimate]
[![Coverage Status](https://img.shields.io/coveralls/RoboticCheese/omnijack-ruby.svg)][coveralls]
[![Dependency Status](https://img.shields.io/gemnasium/RoboticCheese/omnijack-ruby.svg)][gemnasium]

[gem]: https://rubygems.org/gems/omnijack
[travis]: https://travis-ci.org/RoboticCheese/omnijack-ruby
[codeclimate]: https://codeclimate.com/github/RoboticCheese/omnijack-ruby
[coveralls]: https://coveralls.io/r/RoboticCheese/omnijack-ruby
[gemnasium]: https://gemnasium.com/RoboticCheese/omnijack-ruby

Omnijack
========

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

Getting Chef-DK project data from the official Chef API:

```ruby
require 'omnijack'

chef_dk = Omnijack::Project::ChefDk.new
```

Getting Chef-DK package metadata (requires additional target platform
information):

```ruby
chef_dk = Omnijack::Project::ChefDk.new(platform: 'ubuntu',
                                        platform_version: '14.04',
                                        machine_arch: 'x86_64')
metadata = chef_dk.metadata

puts metadata

puts metadata.url
puts metadata.filename
puts metadata.md5
puts metadata.sha256
puts metadata.yolo
puts metadata.version
puts metadata.build

puts metadata[:url]
puts metadata[:filename]
puts metadata[:md5]
puts metadata[:sha256]
puts metadata[:yolo]
puts metadata[:version]
puts metadata[:build]
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
Getting Chef project data:

```ruby
Omnijack::Project::Chef.new
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

Getting Chef-Container project data:

```ruby
Omnijack::Project::ChefContainer.new
```

Getting Chef Server project data:

```ruby
Omnijack::Project::ChefServer.new
```

Contributing
------------

1. Fork it ( https://github.com/[my-github-username]/omnijack/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add tests for any new code and ensure all tests pass (`rake`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request
