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
require_relative '../../../lib/omnijack/endpoint/list'

describe Omnijack::Endpoint::List do
  let(:name) { :chef_dk }
  let(:obj) { described_class.new(name) }

  describe '#endpoint' do
    let(:name) { :chef_container }

    it 'returns the appropriate metadata endpoint' do
      expect(obj.send(:endpoint)).to eq('/full_container_list')
    end
  end
end
