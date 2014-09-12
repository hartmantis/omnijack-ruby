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

require 'json'
require 'open-uri'
require_relative 'config'
require_relative '../omnijack'

class Omnijack
  # A class for representing an Omnitruck list of platform names
  #
  # @author Jonathan Hartman <j@p4nt5.com>
  class Platforms < Omnijack
    include Config

    # TODO: Lots of duplicate code in platforms and list

    #
    # Make list items accessible via methods
    #
    # @param [Symbol] method_id
    #
    def method_missing(method_id, args = nil)
      args.nil? && to_h[method_id] || super
    end

    #
    # Make list items accessible via hash keys
    #
    # @param [Symbol] key
    # @return [String, NilClass]
    #
    def [](key)
      to_h[key]
    end

    #
    # Offer a hash representation of the list
    #
    # @return [Hash]
    #
    def to_h
      # TODO: Use a Mash -- some keys are better off addressed as strings
      JSON.parse(raw_data, symbolize_names: true)
    end

    #
    # Use the raw data string as a string representation
    #
    #
    def to_s
      raw_data
    end

    private

    #
    # Fetch the raw list from the configured URI
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
      OMNITRUCK_PROJECTS[name][:endpoints][:platform_names]
    end
  end
end
