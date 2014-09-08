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

class Omnijack
  # A template for all the Omnitruck projects
  #
  # @author Jonathan Hartman <j@p4nt5.com>
  class Project
    def initialize(**args)
      [
        :base_url, :project, :version, :prerelease, :nightlies,
        :platform_version, :platform, :machine_arch
      ].each do |i|
        send(i, args[i]) unless args[i].nil?
      end
    end

    #
    # The base URL for the API
    #
    # @param [String, NilClass] arg
    # @return [String]
    #
    def base_url(arg = nil)
      @base_url ||= arg
    end

    #
    # The name of the project
    #
    # @param [String, NilClass] arg
    # @return [String]
    #
    def project(arg = nil)
      @project ||= arg
    end

    #
    # The version of the project
    #
    # @param [String, NilClass] arg
    # @return [String]
    #
    def version(arg = nil)
      @version ||= !arg.nil? ? arg : 'latest'
    end

    #
    # Whether to enable prerelease packages
    #
    # @param [TrueClass, FalseClass, NilClass] arg
    # @return [TrueClass, FalseClass]
    #
    def prerelease(arg = nil)
      @prerelease ||= !arg.nil? ? arg : false
    end

    #
    # Whether to enable nightly packages
    #
    # @param [TrueClass, FalseClass, NilClass] arg
    # @return [TrueClass, FalseClass]
    #
    def nightlies(arg = nil)
      @nightlies ||= !arg.nil? ? arg : false
    end

    #
    # The version of the desired platform
    #
    # @param [String, NilClass] arg
    # @return [String]
    #
    def platform_version(arg = nil)
      @platform_version ||= !arg.nil? ? arg : case platform
                                              when 'mac_os_x'
                                                platform_version_mac_os_x
                                              when 'windows'
                                                platform_version_windows
                                              else
                                                node['platform_version']
                                              end
    end

    #
    # The name of the desired platform
    #
    # @param [String, NilClass]
    # @return [String]
    #
    def platform(arg = nil)
      @platform ||= !arg.nil? ? arg : node[:platform]
    end

    #
    # The machine architecture of the desired platform
    #
    # @param [String, NilClass]
    # @return [String]
    #
    def machine_arch(arg = nil)
      @machine_arch ||= !arg.nil? ? arg : node[:kernel][:machine]
    end

    private

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
      # See: http://msdn.microsoft.com/en-us/library/windows/desktop/ms724832(v=vs.85).aspx
      {
        '6.3' => '2012r2', '6.2' => '2012', '6.1' => '2008r2', '6.0' => '2008',
        '5.2' => '2003r2', '5.1' => 'xp', '5.0' => '2000'
      }[node[:platform_version].match(/^[0-9]+\.[0-9]+/).to_s]
    end

    #
    # Fetch and return node data from Ohai
    #
    # @return [Mash]
    #
    def node
      @node ||= Ohai::System.new.all_plugins('platform')[0].data
    end
  end
end
