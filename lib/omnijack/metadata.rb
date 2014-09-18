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
require_relative 'config'
require_relative '../omnijack'

class Omnijack
  # A class for representing an Omnitruck metadata object
  #
  # @author Jonathan Hartman <j@p4nt5.com>
  class Metadata < Omnijack
    include ::Chef::Mixin::ParamsValidate
    include Config

    def initialize(name, args = {})
      super
      args.each { |k, v| send(k, v) unless v.nil? } unless args.nil?
    end

    #
    # Set up an accessor method for each piece of metadata
    #
    METADATA_ATTRIBUTES.each do |a|
      define_method(a) { to_h[a] }
    end
    define_method(:filename) { to_h[:filename] }

    #
    # Make metadata accessible via hash keys
    #
    # @param [Symbol] key
    # @return [String, NilClass]
    #
    def [](key)
      to_h[key]
    end

    #
    # Offer a hash representation of the metadata
    #
    # @return [Hash]
    #
    def to_h
      raw_metadata.split("\n").each_with_object({}) do |line, hsh|
        key = line.split[0].to_sym
        val = case line.split[1]
              when 'true' then true
              when 'false' then false
              else line.split[1]
              end
        hsh[key] = val
        hsh[:filename] = URI.decode(val).split('/')[-1] if key == :url
      end
    end

    #
    # Use the raw metadata string as a string representation
    #
    define_method(:to_s) { raw_metadata }

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
    # Whether to enable prerelease and/or nightly packages
    #
    # @param [TrueClass, FalseClass, NilClass] arg
    # @return [TrueClass, FalseClass]
    #
    [:prerelease, :nightlies].each do |m|
      define_method(m) do |arg = nil|
        set_or_return(m, arg, kind_of: [TrueClass, FalseClass], default: false)
      end
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
    # Fetch the raw metadata from the configured URI
    #
    # @return [String]
    #
    def raw_metadata
      @raw_metadata ||= api_url.open.read
    end

    #
    # Construct the full API query URL from base + endpoint + params
    #
    # @return [URI::HTTP, URI::HTTPS]
    #
    def api_url
      @api_url ||= URI.parse(
        File.join(base_url, "#{endpoint}?#{URI.encode_www_form(query_params)}")
      )
    end

    #
    # Convert all the metadata attrs into params Omnitruck understands
    #
    # @return [Hash]
    #
    def query_params
      { v: version,
        prerelease: prerelease,
        nightlies: nightlies,
        p: platform,
        pv: platform_version,
        m: machine_arch }
    end

    #
    # Return the API endpoint for the metadata of this project
    #
    # @return [String]
    #
    def endpoint
      OMNITRUCK_PROJECTS[name][:endpoints][:metadata]
    end

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
