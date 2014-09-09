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
  let(:obj) { described_class.new }

  describe '#initialize' do
    context 'no args provided' do
      it 'is called successfully' do
        expect(obj).to be_an_instance_of(described_class)
      end
    end

    {
      base_url: 'https://example.com',
      project: 'cocinero',
      version: '1.2.3-1',
      prerelease: true,
      nightlies: true,
      platform: 'gentoo',
      platform_version: '21'
    }.each do |k, v|
      context "a #{k} arg provided" do
        let(:obj) { described_class.new(k => v) }

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
        o.base_url('http://example.com')
        o
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
        o.base_url(:hello)
        o
      end

      it 'raises an exception' do
        expect { obj }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end
  end

  describe '#project' do
    context 'no argument provided' do
      it 'raises an exception' do
        expect { obj.project }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end

    context 'a valid argument provided' do
      let(:obj) do
        o = super()
        o.project('chefsalad')
        o
      end

      it 'uses the provided arg' do
        expect(obj.project).to eq('chefsalad')
        expect(obj.instance_variable_get(:@project)).to eq('chefsalad')
      end
    end

    context 'no argument provided' do
      let(:obj) do
        o = super()
        o.project
        o
      end

      it 'raises an exception' do
        expect { obj }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end
  end

  describe '#version' do
    context 'no argument provided' do
      it 'returns latest' do
        res = obj
        expect(res.version).to eq('latest')
        expect(res.instance_variable_get(:@version)).to eq('latest')
      end
    end

    context 'a valid argument provided' do
      let(:obj) do
        o = super()
        o.version('1.2.3')
        o
      end

      it 'uses the provided arg' do
        expect(obj.version).to eq('1.2.3')
        expect(obj.instance_variable_get(:@version)).to eq('1.2.3')
      end
    end

    context 'an invalid argument provided' do
      let(:obj) do
        o = super()
        o.version(false)
        o
      end

      it 'raises an exception' do
        expect { obj }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end
  end

  describe '#prerelease' do
    context 'no argument provided' do
      it 'returns false' do
        res = obj
        expect(res.prerelease).to eq(false)
        expect(res.instance_variable_get(:@prerelease)).to eq(false)
      end
    end

    context 'a valid argument provided' do
      let(:obj) do
        o = super()
        o.prerelease(true)
        o
      end

      it 'uses the provided arg' do
        expect(obj.prerelease).to eq(true)
        expect(obj.instance_variable_get(:@prerelease)).to eq(true)
      end
    end

    context 'an invalid argument provided' do
      let(:obj) do
        o = super()
        o.prerelease('wigglebot')
        o
      end

      it 'raises an exception' do
        expect { obj }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end
  end

  describe '#nightlies' do
    context 'no argument provided' do
      it 'returns false' do
        res = obj
        expect(res.nightlies).to eq(false)
        expect(res.instance_variable_get(:@nightlies)).to eq(false)
      end
    end

    context 'a valid argument provided' do
      let(:obj) do
        o = super()
        o.nightlies(true)
        o
      end

      it 'uses the provided arg' do
        expect(obj.nightlies).to eq(true)
        expect(obj.instance_variable_get(:@nightlies)).to eq(true)
      end
    end

    context 'an invalid argument provided' do
      let(:obj) do
        o = super()
        o.nightlies('hello')
        o
      end

      it 'raises an exception' do
        expect { obj }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end
  end

  describe '#platform' do
    let(:node) { { platform: 'ms_dos' } }

    before(:each) do
      allow_any_instance_of(described_class).to receive(:node).and_return(node)
    end

    context 'no argument provided' do
      it 'uses the node Ohai data' do
        res = obj
        expect(res.platform).to eq('ms_dos')
        expect(res.instance_variable_get(:@platform)).to eq('ms_dos')
      end
    end

    context 'a valid argument provided' do
      let(:obj) do
        o = super()
        o.platform('ms_bob')
        o
      end

      it 'uses the provided arg' do
        expect(obj.platform).to eq('ms_bob')
        expect(obj.instance_variable_get(:@platform)).to eq('ms_bob')
      end
    end

    context 'an invalid argument provided' do
      let(:obj) do
        o = super()
        o.platform(%w(windows linux))
        o
      end

      it 'raises an exception' do
        expect { obj }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end
  end

  describe '#platform_version' do
    let(:node) { { platform_version: '1.2.3' } }

    before(:each) do
      allow_any_instance_of(described_class).to receive(:node).and_return(node)
    end

    context 'no argument provided' do
      it 'uses the node Ohai data' do
        expect(obj.platform_version).to eq('1.2.3')
        expect(obj.instance_variable_get(:@platform_version)).to eq('1.2.3')
      end
    end

    context 'a valid argument provided' do
      let(:obj) do
        o = super()
        o.platform_version('6.6.6')
        o
      end

      it 'uses the provided arg' do
        expect(obj.platform_version).to eq('6.6.6')
        expect(obj.instance_variable_get(:@platform_version)).to eq('6.6.6')
      end
    end

    context 'an invalid argument provided' do
      let(:obj) do
        o = super()
        o.platform_version(%w(1 2 3))
        o
      end

      it 'raises an exception' do
        expect { obj }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end
  end

  describe '#machine_arch' do
    let(:node) { { kernel: { machine: 'x86_64' } } }

    before(:each) do
      allow_any_instance_of(described_class).to receive(:node).and_return(node)
    end

    context 'no argument provided' do
      it 'uses the node Ohai data' do
        res = obj
        expect(res.machine_arch).to eq('x86_64')
        expect(res.instance_variable_get(:@machine_arch)).to eq('x86_64')
      end
    end

    context 'a valid argument provided' do
      let(:obj) do
        o = super()
        o.machine_arch('arm')
        o
      end

      it 'uses the provided arg' do
        expect(obj.machine_arch).to eq('arm')
        expect(obj.instance_variable_get(:@machine_arch)).to eq('arm')
      end
    end

    context 'an invalid argument provided' do
      let(:obj) do
        o = super()
        o.machine_arch(%w(some things))
        o
      end

      it 'raises an exception' do
        expect { obj }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end
  end

  describe '#node' do
    let(:platform) { nil }
    let(:platform_version) { nil }
    let(:system) do
      double(all_plugins: [
        double(data: { platform: platform, platform_version: platform_version })
      ])
    end

    before(:each) do
      unless platform.nil? || platform_version.nil?
        allow(Ohai::System).to receive(:new).and_return(system)
      end
    end

    it 'loads and returns Ohai platform data' do
      node = obj.send(:node)
      expect(node[:platform]).to be_an_instance_of(String)
      expect(node[:platform_version]).to be_an_instance_of(String)
    end

    context 'Mac OS X' do
      let(:platform) { 'mac_os_x' }
      let(:platform_version) { '10.9.2' }

      it 'calls the custom Mac OS X version logic' do
        o = obj
        expect(o).to receive(:platform_version_mac_os_x).and_call_original
        expect(o.send(:node)[:platform_version]).to eq('10.9')
      end
    end

    context 'Windows' do
      let(:platform) { 'windows' }
      let(:platform_version) { '6.3' }

      it 'calls the custom Windows version logic' do
        o = obj
        expect(o).to receive(:platform_version_windows).and_call_original
        expect(o.send(:node)[:platform_version]).to eq('2012r2')
      end
    end

    context 'CentOS' do
      let(:platform) { 'centos' }
      let(:platform_version) { '7.0' }

      it 'does not modify the version' do
        expect(obj.send(:node)[:platform_version]).to eq('7.0')
      end
    end

    context 'Ubuntu' do
      let(:platform) { 'ubuntu' }
      let(:platform_version) { '14.04' }

      it 'does not modify the version' do
        expect(obj.send(:node)[:platform_version]).to eq('14.04')
      end
    end
  end

  describe '#version' do
    context 'a "latest" version' do
      let(:res) { obj.send(:valid_version?, 'latest') }

      it 'returns true' do
        expect(res).to eq(true)
      end
    end

    context 'a valid major.minor.patch version' do
      let(:res) { obj.send(:valid_version?, '12.34.56') }

      it 'returns true' do
        expect(res).to eq(true)
      end
    end

    context 'a valid major.minor.patch-build version' do
      let(:res) { obj.send(:valid_version?, '12.34.9-42') }

      it 'returns true' do
        expect(res).to eq(true)
      end
    end

    context 'an invalid version' do
      let(:res) { obj.send(:valid_version?, 'x.y.z') }

      it 'returns false' do
        expect(res).to eq(false)
      end
    end
  end

  describe '#platform_version_mac_os_x' do
    let(:node) { { platform_version: platform_version } }

    before(:each) do
      allow_any_instance_of(described_class).to receive(:node).and_return(node)
    end

    { '10.9' => '10.9', '10.9.4' => '10.9' }.each do |ver, expected|
      context "Mac OS X version #{ver}" do
        let(:platform_version) { ver }

        it "returns Mac OSX #{expected}" do
          expect(obj.send(:platform_version_mac_os_x)).to eq(expected)
        end
      end
    end
  end

  describe '#platform_version_windows' do
    let(:node) { { platform_version: platform_version } }

    before(:each) do
      allow_any_instance_of(described_class).to receive(:node).and_return(node)
    end

    {
      '6.3.123456.789' => '2012r2',
      '6.2.123456.789' => '2012',
      '6.1.123456.789' => '2008r2',
      '6.0.123456.789' => '2008',
      '5.2.123456.789' => '2003r2',
      '5.1.123456.789' => 'xp',
      '5.0.123456.789' => '2000'
    }.each do |ver, expected|
      context "Windows version #{ver}" do
        let(:platform_version) { ver }

        it "returns Windows #{expected}" do
          expect(obj.send(:platform_version_windows)).to eq(expected)
        end
      end
    end
  end
end
