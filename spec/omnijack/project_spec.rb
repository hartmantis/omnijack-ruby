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
  let(:attributes) do
    [:base_url, :project, :version, :prerelease, :nightlies, :platform_version,
     :platform, :machine_arch]
  end
  [
    :base_url, :project, :version, :prerelease, :nightlies, :platform_version,
    :platform, :machine_arch
  ].each { |a| let(a) { nil } }
  let(:obj) do
    args = attributes.each_with_object({}) do |a, hsh|
      hsh[a] = send(a)
      hsh
    end
    described_class.new(args.empty? ? nil : args)
  end

  describe '#initialize' do
    context 'no arguments provided' do
      [
        :base_url, :project, :version, :prerelease, :nightlies,
        :platform_version, :platform, :machine_arch
      ].each do |a|
        it "sets #{a} to nil" do
          expect(obj.instance_variable_get(:"@#{a}")).to eq(nil)
        end
      end
    end

    [
      :base_url, :project, :version, :prerelease, :nightlies,
      :platform_version, :platform, :machine_arch
    ].each do |a|
      context "a #{a} argument provided" do
        let(a) { 'something' }

        it 'uses the provided arg' do
          expect(obj.instance_variable_get(:"@#{a}")).to eq('something')
        end
      end
    end
  end

  describe '#base_url' do
    context 'no argument provided' do
      it 'returns nil' do
        res = obj
        expect(res.base_url).to eq(nil)
        expect(res.instance_variable_get(:@base_url)).to eq(nil)
      end
    end

    context 'an argument provided' do
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
  end

  describe '#project' do
    context 'no argument provided' do
      it 'returns nil' do
        expect(obj.project).to eq(nil)
      end
    end

    context 'an argument provided' do
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
  end

  describe '#project' do
    context 'no argument provided' do
      it 'returns nil' do
        expect(obj.project).to eq(nil)
      end
    end

    context 'an argument provided' do
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
  end

  describe '#version' do
    context 'no argument provided' do
      it 'returns latest' do
        res = obj
        expect(res.version).to eq('latest')
        expect(res.instance_variable_get(:@version)).to eq('latest')
      end
    end

    context 'an argument provided' do
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
  end

  describe '#prerelease' do
    context 'no argument provided' do
      it 'returns false' do
        res = obj
        expect(res.prerelease).to eq(false)
        expect(res.instance_variable_get(:@prerelease)).to eq(false)
      end
    end

    context 'an argument provided' do
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
  end

  describe '#nightlies' do
    context 'no argument provided' do
      it 'returns false' do
        res = obj
        expect(res.nightlies).to eq(false)
        expect(res.instance_variable_get(:@nightlies)).to eq(false)
      end
    end

    context 'an argument provided' do
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
  end

  describe '#platform_version' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:platform)
        .and_return(platform)
      allow_any_instance_of(described_class).to receive(:node)
        .and_return(platform_version: platform_version)
    end

    context 'no argument provided' do
      context 'Mac OS X' do
        let(:platform) { 'mac_os_x' }

        it 'calls the specialized OS X method' do
          pending
          res = obj
          expect(res).to receive(:platform_version_mac_os_x).and_return(true)
          expect(res.platform_version).to eq(true)
          expect(res.instance_variable_get(:@platform_version)).to eq(true)
        end
      end

      context 'Windows' do
        let(:platform) { 'windows' }

        it 'calls the specialized Windows method' do
          pending
          res = obj
          expect(res).to receive(:platform_version_windows).and_return(true)
          expect(res.platform_version).to eq(true)
          expect(res.instance_variable_get(:@platform_version)).to eq(true)
        end
      end

      context 'CentOS' do
        let(:platform) { 'centos' }
        let(:platform_version) { '6.5' }

        it 'returns the platform version from Ohai' do
          pending
          res = obj
          expect(res.platform_version).to eq('6.5')
          expect(res.instance_variable_get(:@platform_version)).to eq(true)
        end
      end

      context 'Ubuntu' do
        let(:platform) { 'ubuntu' }
        let(:platform_version) { '12.04' }

        it 'returns the platform version from Ohai' do
          pending
          res = obj
          expect(res.platform_version).to eq('12.04')
          expect(res.instance_variable_get(:@platform_version)).to eq(true)
        end
      end
    end

    context 'an argument provided' do
      let(:obj) do
        o = super()
        o.platform_version('1.2.3')
        o
      end

      context 'Mac OS X' do
        let(:platform) { 'mac_os_x' }

        it 'calls the specialized OS X method' do
          pending
          expect(obj).to receive(:platform_version_mac_os_x).and_return(true)
          expect(obj.platform_version).to eq(true)
          expect(obj.instance_variable_get(:@platform_version)).to eq(true)
        end
      end

      context 'Windows' do
        let(:platform) { 'windows' }

        it 'calls the specialized Windows method' do
          pending
          res = obj
          expect(res).to receive(:platform_version_windows).and_return(true)
          expect(res.platform_version).to eq(true)
          expect(res.instance_variable_get(:@platform_version)).to eq(true)
        end
      end

      context 'CentOS' do
        let(:platform) { 'centos' }

        it 'uses the provided arg' do
          pending
          expect(obj.platform_version).to eq('1.2.3')
          expect(obj.instance_variable_get(:@platform_version)).to eq('1.2.3')
        end
      end

      context 'Ubuntu' do
        let(:platform) { 'ubuntu' }

        it 'uses the provided arg' do
          expect(obj.platform_version).to eq('1.2.3')
          expect(obj.instance_variable_get(:@platform_version)).to eq('1.2.3')
        end
      end
    end
  end

  describe '#platform' do
    let(:node) { { platform: 'ms_dos' } }

    before(:each) do
      allow_any_instance_of(described_class).to receive(:node).and_return(node)
    end

    context 'no argument provided' do
      it 'uses the platform from Ohai' do
        res = obj
        expect(res.platform).to eq('ms_dos')
        expect(res.instance_variable_get(:@platform)).to eq('ms_dos')
      end
    end

    context 'an argument provided' do
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
  end

  describe '#machine_arch' do
    let(:node) { { kernel: { machine: 'x86_64' } } }

    before(:each) do
      allow_any_instance_of(described_class).to receive(:node).and_return(node)
    end

    context 'no argument provided' do
      it 'uses the machine arch from Ohai' do
        res = obj
        expect(res.machine_arch).to eq('x86_64')
        expect(res.instance_variable_get(:@machine_arch)).to eq('x86_64')
      end
    end

    context 'an argument provided' do
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

  describe '#node' do
    it 'loads and returns Ohai platform data' do
      node = obj.send(:node)
      expect(node[:platform]).to be_an_instance_of(String)
      expect(node[:platform_version]).to be_an_instance_of(String)
    end
  end
end
