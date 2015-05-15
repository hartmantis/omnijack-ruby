# Encoding: UTF-8
#
# Author:: Jonathan Hartman (<j@p4nt5.com>)
#
# Copyright (C) 2014-2015 Jonathan Hartman
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

require 'multi_json'
require 'open-uri'
unless Module.const_defined?(:Chef)
  require_relative '../../vendor/chef/lib/chef/exceptions'
  require_relative '../../vendor/chef/lib/chef/mixin/params_validate'
end
require_relative '../omnijack'
require_relative 'endpoint/list'
require_relative 'endpoint/metadata'
require_relative 'endpoint/platforms'

class Omnijack
  # A parent class for Omnijack API endpoints
  #
  # @author Jonathan Hartman <j@p4nt5.com>
  class Endpoint < Omnijack
    include ::Chef::Mixin::ParamsValidate
    include Config

    def initialize(name, args = {})
      super
      base_url(args[:base_url])
    end

    #
    # Make class items accessible via methods
    #
    # @param [Symbol] method_id
    #
    def method_missing(method_id, args = nil)
      args.nil? && to_h[method_id] || super
    end

    #
    # Make class items accessible via hash keys
    #
    # @param[Symbol] key
    # @return [String, NilClass]
    #
    def [](key)
      to_h[key]
    end

    #
    # Offer a hash representation of the object
    #
    # @return [Hash]
    #
    def to_h
      # TODO: Use a Mash -- some keys are better off addressed as strings
      MultiJson.load(raw_data, symbolize_names: true)
    end

    #
    # Use the raw data string as a string representation
    #
    define_method(:to_s) { raw_data }

    #
    # The base URL of the Omnitruck API
    #
    # @param [String, NilClass] arg
    # @return [String]
    #
    def base_url(arg = nil)
      # TODO: Better URL validation
      set_or_return(:base_url, arg, kind_of: String, default: DEFAULT_BASE_URL)
    end

    private

    #
    # Fetch the raw data from the configured URI
    #
    # @return [String]
    #
    def raw_data
      @raw_data ||= api_url.open.read
    end

    #
    # Construct the full API query URL from base + endpoint
    #
    # @return [URI::HTTP, URI::HTTPS]
    #
    def api_url
      @api_url ||= URI.parse(::File.join(base_url, endpoint))
    end

    #
    # Return the API endpoint for the package list of this project
    #
    # @return [String]
    #
    def endpoint
      cl = self.class.to_s.split(':')[-1].downcase.to_sym
      OMNITRUCK_PROJECTS[name][:endpoints][cl]
    end
  end
end
