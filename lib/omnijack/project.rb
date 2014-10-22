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

require_relative '../omnijack'
require_relative 'config'
require_relative 'endpoint'
require_relative 'project/metaprojects'

class Omnijack
  # A parent project that can contain metadata, a pkg list, and platforms
  #
  # @author Jonathan Hartman <j@p4nt5.com>
  class Project < Omnijack
    include Config

    #
    # The Metadata instance for the project
    #
    # @return [Omnijack::Metadata]
    #
    def metadata
      # TODO: This requires too much knowledge of the Metadata class
      @metadata ||= Endpoint::Metadata.new(name, args)
    end

    #
    # The full list instance for the project
    #
    # @return [Omnijack::List]
    #
    def list
      @list ||= Endpoint::List.new(name, args)
    end

    #
    # The platform names instance for the project
    #
    # @return [Omnijack::Platforms]
    #
    def platforms
      @platforms ||= Endpoint::Platforms.new(name, args)
    end
  end
end
