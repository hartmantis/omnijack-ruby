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

describe Omnijack do
  let(:obj) { described_class.new('chefdk') }

  describe '#initialize' do
    context 'no args provided' do
      it 'is called successfully' do
        expect(obj).to be_an_instance_of(described_class)
      end
    end

    {
      base_url: 'https://example.com',
    }.each do |k, v|
      context "a #{k} arg provided" do
        let(:obj) { described_class.new('cocinero', k => v) }

        it 'sets the given arg' do
          expect(obj.send(k)).to eq(v)
          expect(obj.instance_variable_get(:"@#{k}")).to eq(v)
        end
      end
    end
  end

  describe '#base_url' do
    context 'no argument provided' do
      it 'uses the default' do
        res = obj
        expected = 'https://www.getchef.com/chef'
        expect(res.base_url).to eq(expected)
        expect(res.instance_variable_get(:@base_url)).to eq(expected)
      end
    end

    context 'a valid argument provided' do
      let(:obj) do
        o = super()
        o.base_url('http://example.com') && o
      end

      it 'uses the provided arg' do
        expect(obj.base_url).to eq('http://example.com')
        expect(obj.instance_variable_get(:@base_url))
          .to eq('http://example.com')
      end
    end

    context 'an invalid argument provided' do
      let(:obj) do
        o = super()
        o.base_url(:hello) && o
      end

      it 'raises an exception' do
        expect { obj }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end
  end

  describe '#name' do
    context 'no argument provided' do
      it 'returns the project name' do
        expect(obj.name.to eq(:chefdk)
      end
    end

    context 'a valid argument provided' do
      let(:obj) do
        o = super()
        o.name('chefsalad') && o
      end

      it 'uses the provided arg, symbolized' do
        expect(obj.name).to eq(:chefsalad)
        expect(obj.instance_variable_get(:@name)).to eq(:chefsalad)
      end
    end

    context 'an invalid argument provided' do
      let(:obj) do
        o = super()
        o.name(true) && o
      end

      it 'raises an exception' do
        expect { obj }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end
  end
end
