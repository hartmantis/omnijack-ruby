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
  let(:obj) { described_class.new }

  describe '#initialize' do
    context 'no additional args' do
      it 'initializes a chef_dk project' do
        res = obj
        expect(res.project).to eq(:chef_dk)
        expect(res.instance_variable_get(:@project)).to eq(:chef_dk)
      end
    end

    context 'some additional args' do
      let(:obj) { described_class.new(version: '6.6.6', prerelease: true) }

      it 'passes those args on to the superclass' do
        res = obj
        expect(res.version).to eq('6.6.6')
        expect(res.instance_variable_get(:@version)).to eq('6.6.6')
        expect(res.prerelease).to eq(true)
        expect(res.instance_variable_get(:@prerelease)).to eq(true)
      end
    end
  end

  describe '#project' do
    it 'returns chef_dk' do
      expect(obj.project).to eq(:chef_dk)
    end

    it 'refuses attempts to override' do
      expect { obj.project('bad') }.to raise_error
    end
  end
end
