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

require_relative '../../spec_helper'
require_relative '../../../lib/omnijack/metadata/chef_dk'

describe Omnijack::Metadata::ChefDk do
  let(:obj) { described_class.new(base_url) }

  describe '#initialize' do
    context 'no base URL provided' do
      let(:base_url) { nil }

      it 'uses the default Chef API' do
        expected = URI.parse('https://www.getchef.com/chef/metadata-chefdk')
        expect(obj.api_url).to eq(expected)
      end
    end

    context 'a base URL provided' do
      let(:base_url) { 'http://example.com' }

      it 'uses the provided API' do
        expected = URI.parse('http://example.com/metadata-chefdk')
        expect(obj.api_url).to eq(expected)
      end
    end
  end
end
