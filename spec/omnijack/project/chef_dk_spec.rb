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
require_relative '../../../lib/omnijack/project/metaprojects'

describe Omnijack::Project::ChefDk do
  let(:args) { nil }
  let(:obj) { described_class.new(args) }

  describe '#initialize' do
    context 'no additional args' do
      it 'initializes a chef_dk project' do
        res = obj
        expect(res.name).to eq(:chef_dk)
        expect(res.instance_variable_get(:@name)).to eq(:chef_dk)
      end
    end

    context 'some additional args' do
      let(:args) { { version: '6.6.6', prerelease: true } }

      it 'holds onto those args' do
        res = obj
        expect(res.args).to eq(args)
        expect(res.instance_variable_get(:@args)).to eq(args)
      end
    end
  end

  describe '#name' do
    it 'returns chef_dk' do
      expect(obj.name).to eq(:chef_dk)
    end

    it 'refuses attempts to override' do
      expect { obj.name('bad') }.to raise_error
    end
  end
end
