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
require_relative '../../lib/omnijack/project'

describe Omnijack::Project do
  let(:args) { {} }
  let(:obj) { described_class.new(:chef_dk, args) }

  describe '#list' do
    it 'returns a List object' do
      res = obj
      [res.list, res.instance_variable_get(:@list)].each do |i|
        expect(i).to be_an_instance_of(Omnijack::Endpoint::List)
      end
    end
  end

  describe '#metadata' do
    let(:args) do
      { platform: 'ms_dos', platform_version: '1.2.3', machine_arch: 'i386' }
    end

    before(:each) do
      allow_any_instance_of(Omnijack::Endpoint::Metadata).to receive(:to_h)
        .and_return(version: '1.2.3')
    end

    it 'returns a Metadata object' do
      res = obj
      [res.metadata, res.instance_variable_get(:@metadata)].each do |i|
        expect(i).to be_an_instance_of(Omnijack::Endpoint::Metadata)
      end
    end
  end

  describe '#platforms' do
    it 'returns a Platforms object' do
      res = obj
      [res.platforms, res.instance_variable_get(:@platforms)].each do |i|
        expect(i).to be_an_instance_of(Omnijack::Endpoint::Platforms)
      end
    end
  end
end
