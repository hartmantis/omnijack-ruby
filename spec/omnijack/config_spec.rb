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

require_relative '../spec_helper'
require_relative '../../lib/omnijack/config'

describe Omnijack::Config do
  describe 'DEFAULT_BASE_URL' do
    it 'uses the official Chef API' do
      expected = 'https://www.getchef.com/chef'
      expect(described_class::DEFAULT_BASE_URL).to eq(expected)
    end
  end

  describe 'OMNITRUCK_PROJECTS' do
    it 'recognizes all the valid Omnitruck projects' do
      expected = [:angry_chef, :chef, :chef_dk, :chef_container, :chef_server]
      expect(described_class::OMNITRUCK_PROJECTS.keys).to eq(expected)
    end

    described_class::OMNITRUCK_PROJECTS.each do |project, attrs|
      attrs[:endpoints].each do |name, endpoint|
        it "uses a valid #{project}::#{name} endpoint" do
          url = "http://www.getchef.com/chef#{endpoint}"
          url << '?v=latest&p=ubuntu&pv=12.04&m=x86_64' if name == :metadata

          # Some endpoints aren't available on Chef's public Omnitruck API
          if [:angry_chef, :chef_dk, :chef_container].include?(project) && \
            [:package_list, :platform_names].include?(name)
            expected = 301
          else
            expected = 200
          end

          expect(Net::HTTP.get_response(URI(url)).code.to_i).to eq(expected)
        end
      end
    end
  end
end
