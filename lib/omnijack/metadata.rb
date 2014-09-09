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

require 'open-uri'

class Omnijack
  # A class for representing an Omnitruck metadata object
  #
  # @author Jonathan Hartman <j@p4nt5.com>
  class Metadata
    #
    # The list of attributes for this class to recognize
    #
    # @return [Array]
    #
    def self.attributes
      [:url, :md5, :sha256, :yolo, :filename]
    end

    def initialize(base_url, **args)
      @api_url = URI.parse("#{base_url}?" <<
                           args.map { |k, v| "#{k}=#{v}" }.join('&'))
      self
    end
    attr_reader :api_url

    #
    # Set up an accessor method for each piece of metadata
    #
    attributes.each do |a|
      define_method(a) { to_h[a] }
    end

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
        val = case line.split[1]
              when 'true' then true
              when 'false' then false
              else line.split[1]
              end
        hsh[line.split[0].to_sym] = val
        hsh[:filename] = line.split('/')[-1] if line.split[0].to_sym == :url
      end
    end

    #
    # Use the raw metadata string as a string representation
    #
    #
    def to_s
      raw_metadata
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
  end
end
