# Encoding: UTF-8
#
# Author:: Jonathan Hartman (<j@p4nt5.com>)
#
# Copyright (C) 2014, Jonathan Hartman
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'ohai'
require 'open-uri'
require_relative 'helpers'
require_relative 'list'
require_relative 'metadata'
require_relative '../../vendor/chef/lib/chef/exceptions'
require_relative '../../vendor/chef/lib/chef/mixin/params_validate'
require_relative 'project/angry_chef'
require_relative 'project/chef'
require_relative 'project/chef_dk'
require_relative 'project/container'
require_relative 'project/server'

class Omnijack
  # A template for all the Omnitruck projects
  #
  # @author Jonathan Hartman <j@p4nt5.com>
  class Project
    include ::Chef::Mixin::ParamsValidate
    include Helpers

    # TODO: Make project the static first arg since it's required
    def initialize(project_arg, args = {})
      project(project_arg)
      [
        :base_url, :version, :prerelease, :nightlies, :platform,
        :platform_version, :machine_arch
      ].each do |i|
        send(i, args[i]) unless args[i].nil?
      end
      self
    end

    #
    # The Metadata instance for the project
    #
    # @return [Omnijack::Metadata]
    #
    def metadata
      # TODO: This requires too much knowledge of the Metadata class
      @metadata ||= Metadata.new(URI("#{base_url}/metadata-#{project}").to_s,
                                 v: version,
                                 prerelease: prerelease,
                                 nightlies: nightlies,
                                 p: platform,
                                 pv: platform_version,
                                 m: machine_arch)
    end

    #
    # The full list instance for the project
    #
    # @return [Omnijack::List]
    #
    def list
      @list ||= List.new(URI("#{base_url}/full_#{project}_list").to_s)
    end

    #
    # The base URL for the API
    #
    # @param [String, NilClass] arg
    # @return [String]
    #
    def base_url(arg = nil)
      # TODO: Better URL validation
      set_or_return(:base_url, arg, kind_of: String, default: DEFAULT_BASE_URL)
    end

    #
    # The name of the project
    #
    # @param [String, NilClass] arg
    # @return [String]
    #
    def project(arg = nil)
      set_or_return(:project, arg, kind_of: String, required: true)
    end

    #
    # The version of the project
    #
    # @param [String, NilClass] arg
    # @return [String]
    #
    def version(arg = nil)
      set_or_return(:version,
                    arg,
                    kind_of: String,
                    default: 'latest',
                    callbacks: {
                      'Invalid version string' => ->(a) { valid_version?(a) }
                    })
    end

    #
    # Whether to enable prerelease packages
    #
    # @param [TrueClass, FalseClass, NilClass] arg
    # @return [TrueClass, FalseClass]
    #
    def prerelease(arg = nil)
      set_or_return(:prerelease,
                    arg,
                    kind_of: [TrueClass, FalseClass],
                    default: false)
    end

    #
    # Whether to enable nightly packages
    #
    # @param [TrueClass, FalseClass, NilClass] arg
    # @return [TrueClass, FalseClass]
    #
    def nightlies(arg = nil)
      set_or_return(:nightlies,
                    arg,
                    kind_of: [TrueClass, FalseClass],
                    default: false)
    end

    #
    # The name of the desired platform
    #
    # @param [String, NilClass]
    # @return [String]
    #
    def platform(arg = nil)
      set_or_return(:platform, arg, kind_of: String, default: node[:platform])
    end

    #
    # The version of the desired platform
    #
    # @param [String, NilClass] arg
    # @return [String]
    #
    def platform_version(arg = nil)
      # TODO: The platform version parser living in `node` means passing e.g.
      # '10.9.2' here won't result in it being shortened to '10.9'
      set_or_return(:platform_version,
                    arg,
                    kind_of: String,
                    default: node[:platform_version])
    end

    #
    # The machine architecture of the desired platform
    #
    # @param [String, NilClass]
    # @return [String]
    #
    def machine_arch(arg = nil)
      set_or_return(:machine_arch,
                    arg,
                    kind_of: String,
                    default: node[:kernel][:machine])
    end

    private

    #
    # Fetch and return node data from Ohai
    #
    # @return [Mash]
    #
    def node
      unless @node
        @node = Ohai::System.new.all_plugins('platform')[0].data
        case @node[:platform]
        when 'mac_os_x'
          @node[:platform_version] = platform_version_mac_os_x
        when 'windows'
          @node[:platform_version] = platform_version_windows
        end
      end
      @node
    end

    #
    # Apply special logic for the version of an OS X platform
    #
    # @return [String]
    #
    def platform_version_mac_os_x
      node[:platform_version].match(/^[0-9]+\.[0-9]+/).to_s
    end

    #
    # Apply special logic for the version of a Windows platform
    #
    # @return [String]
    #
    def platform_version_windows
      # Make a best guess and assume a server OS
      # See: http://msdn.microsoft.com/en-us/library/windows/
      #      desktop/ms724832(v=vs.85).aspx
      {
        '6.3' => '2012r2', '6.2' => '2012', '6.1' => '2008r2', '6.0' => '2008',
        '5.2' => '2003r2', '5.1' => 'xp', '5.0' => '2000'
      }[node[:platform_version].match(/^[0-9]+\.[0-9]+/).to_s]
    end

    #
    # Determine whether a string is a valid version string
    #
    # @param [String] arg
    # @return [TrueClass, FalseClass]
    #
    def valid_version?(arg)
      return true if arg == 'latest'
      arg.match(/^[0-9]+\.[0-9]+\.[0-9]+(-[0-9]+)?$/) ? true : false
    end
  end
end
