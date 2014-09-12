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
require_relative '../../lib/omnijack/platforms'

describe Omnijack::Platforms do
  let(:name) { :chef_dk }
  let(:obj) { described_class.new(name) }

  describe '#method_missing' do
    let(:to_h) { { thing1: 'yup', thing2: 'nope', thing3: 'maybe' } }

    before(:each) do
      allow_any_instance_of(described_class).to receive(:to_h).and_return(to_h)
    end

    it 'sets up methods for the platform hash keys' do
      expect(obj.thing1).to eq('yup')
      expect(obj.thing2).to eq('nope')
      expect(obj.thing3).to eq('maybe')
    end

    it 'raises an exception otherwise' do
      expect { obj.thing4 }.to raise_error(NoMethodError)
    end
  end

  describe '#[]' do
    let(:to_h) { { thing1: 'yup', thing2: 'nope', thing3: 'maybe' } }

    before(:each) do
      allow_any_instance_of(described_class).to receive(:to_h).and_return(to_h)
    end

    it 'returns the correct data' do
      expect(obj[:thing1]).to eq('yup')
      expect(obj[:thing2]).to eq('nope')
      expect(obj[:thing3]).to eq('maybe')
    end
  end

  describe '#to_h' do
    context 'fake data' do
      let(:raw_data) { '{"thing1": "yup", "thing2": "nope"}' }

      before(:each) do
        allow_any_instance_of(described_class).to receive(:raw_data)
          .and_return(raw_data)
      end

      it 'returns the correct result hash' do
        expect(obj.to_h).to eq(thing1: 'yup', thing2: 'nope')
      end
    end

    context 'real data' do
      let(:obj) { described_class.new(:chef) }

      it 'returns the expected data' do
        expect(obj.to_h[:el]).to eq('Enterprise Linux')
      end
    end
  end

  describe '#to_s' do
    let(:raw_data) { 'SOME STUFF' }

    before(:each) do
      allow_any_instance_of(described_class).to receive(:raw_data)
        .and_return(raw_data)
    end

    it 'returns the raw HTTP GET string' do
      expect(obj.to_s).to eq(raw_data)
    end
  end

  describe '#raw_data' do
    let(:read) { '{"thing1": "yup", "thing2": "nope"}' }
    let(:open) { double(read: read) }

    before(:each) do
      allow_any_instance_of(URI::HTTP).to receive(:open).and_return(open)
    end

    it 'returns a GET of the API URL' do
      res = obj
      expect(res.send(:raw_data)).to eq(read)
      expect(res.instance_variable_get(:@raw_data)).to eq(read)
    end
  end

  describe '#api_url' do
    let(:base_url) { 'http://example.com/chef' }
    let(:endpoint) { '/example_platform_names' }

    before(:each) do
      [:base_url, :endpoint].each do |i|
        allow_any_instance_of(described_class).to receive(i).and_return(send(i))
      end
    end

    it 'constructs a URL based on base + endpoint' do
      expected = URI.parse('http://example.com/chef/example_platform_names')
      expect(obj.send(:api_url)).to eq(expected)
    end
  end

  describe '#endpoint' do
    let(:name) { :chef_container }

    it 'returns the appropriate metadata endpoint' do
      expect(obj.send(:endpoint)).to eq('/chef_container_platform_names')
    end
  end
end
