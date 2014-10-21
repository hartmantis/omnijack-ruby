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

require 'multi_json'
require_relative '../spec_helper'
require_relative '../../lib/omnijack/metadata'

describe Omnijack::Metadata do
  let(:name) { :chef_dk }
  let(:args) { nil }
  let(:obj) { described_class.new(name, args) }

  before(:each) do
    allow_any_instance_of(described_class).to receive(:to_h).and_return(true)
  end

  describe '#initialize' do
    it 'initializes the object hash data' do
      expect_any_instance_of(described_class).to receive(:to_h).and_return(true)
      obj
    end

    {
      platform: 'linspire',
      platform_version: '3.3.3',
      machine_arch: 'risc'
    }.each do |k, v|
      context "a #{k} arg provided" do
        let(:args) { { k => v } }

        it 'sets the given arg' do
          expect(obj.send(k)).to eq(v)
          expect(obj.instance_variable_get(:"@#{k}")).to eq(v)
        end
      end
    end

    context 'an invalid arg provided' do
      let(:args) { { potatoes: 'peeled' } }

      it 'raises an exception' do
        expect { obj }.to raise_error(NoMethodError)
      end
    end
  end

  [:url, :md5, :sha256, :yolo, :filename, :build].each do |i|
    describe "##{i}" do
      before(:each) do
        allow_any_instance_of(described_class).to receive(:to_h)
          .and_return(i => 'a thing')
      end

      it "returns the #{i} attribute" do
        expect(obj.send(i)).to eq('a thing')
      end
    end
  end

  describe '#[]' do
    let(:attributes) do
      [:url, :md5, :sha256, :yolo, :filename, :version, :build]
    end

    before(:each) do
      allow_any_instance_of(described_class).to receive(:to_h)
        .and_return(attributes.each_with_object({}) do |a, hsh|
                      hsh[a] = "#{a} things"
                      hsh
                    end)
    end

    [:url, :md5, :sha256, :yolo, :filename, :version, :build].each do |a|
      it "returns the correct #{a}" do
        expect(obj[a]).to eq("#{a} things")
      end
    end
  end

  describe '#to_h' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:to_h)
        .and_call_original
    end

    context 'fake normal package data' do
      let(:url) do
        'https://opscode-omnibus-packages.s3.amazonaws.com/el/6/x86_64/' \
          'chefdk-0.2.1-1.el6.x86_64.rpm'
      end
      let(:md5) { 'feb2e06fdecae3bae79f8ec8d32d6ab6' }
      let(:sha256) do
        'afd487ab6f0cd0286a0a3d2808a041c784c064eddb6193d688edfb6741065b56'
      end
      let(:yolo) { true }
      let(:raw_metadata) do
        "url\t#{url}\nmd5\t#{md5}\nsha256\t#{sha256}\nyolo\t#{yolo}"
      end

      before(:each) do
        allow_any_instance_of(described_class).to receive(:raw_metadata)
          .and_return(raw_metadata)
      end

      it 'returns the correct result hash' do
        expected = { url: url, md5: md5, sha256: sha256, yolo: yolo,
                     filename: 'chefdk-0.2.1-1.el6.x86_64.rpm',
                     version: '0.2.1', build: '1' }
        expect(obj.to_h).to eq(expected)
      end

      it 'overwrites the requested version with the actual package version' do
        expect(obj.version).to eq('0.2.1')
        expect(obj.instance_variable_get(:@version)).to eq('0.2.1')
      end

      [true, false].each do |tf|
        context "data with a #{tf} value in it" do
          let(:yolo) { tf }

          it 'converts that string into a boolean' do
            expect(obj.to_h[:yolo]).to eq(tf)
          end
        end
      end
    end

    context 'fake nightly build data' do
      let(:url) do
        'https://opscode-omnibus-packages.s3.amazonaws.com/mac_os_x/' \
          '10.8/x86_64/chefdk-0.2.2%2B20140916163521.git.23.997cf31-1.dmg'
      end
      let(:md5) { 'e7f3ab946c851b50971d117bfa0f6e2c' }
      let(:sha256) do
        'b9ecab8f2ebb258c3bdc341ab82310dfbfc8b8a5b27802481f27daf607ba7f99'
      end
      let(:yolo) { true }
      let(:raw_metadata) do
        "url\t#{url}\nmd5\t#{md5}\nsha256\t#{sha256}\nyolo\t#{yolo}"
      end

      before(:each) do
        allow_any_instance_of(described_class).to receive(:raw_metadata)
          .and_return(raw_metadata)
      end

      it 'decodes the encoded URL' do
        expected = {
          url: url, md5: md5, sha256: sha256, yolo: yolo,
          filename: 'chefdk-0.2.2+20140916163521.git.23.997cf31-1.dmg',
          version: '0.2.2+20140916163521.git.23.997cf31', build: '1'
        }
        expect(obj.to_h).to eq(expected)
      end
    end

    json = ::File.open(File.expand_path('../../support/real_test_data.json',
                                        __FILE__)).read
    MultiJson.load(json, symbolize_names: true).each do |data|
      context "#{data[:platform]} Chef-DK" do
        let(:obj) do
          described_class.new(:chef_dk,
                              version: data[:version],
                              prerelease: data[:prerelease],
                              nightlies: data[:nightlies],
                              platform: data[:platform][:name],
                              platform_version: data[:platform][:version],
                              machine_arch: 'x86_64')
        end

        it 'returns the expected data' do
          if !data[:expected]
            expect { obj.to_h }.to raise_error(OpenURI::HTTPError)
          else
            expect(obj.to_h).to eq(data[:expected])
          end
        end
      end
    end
  end

  describe '#to_s' do
    let(:raw_metadata) { 'SOME METADATA' }
    before(:each) do
      allow_any_instance_of(described_class).to receive(:raw_metadata)
        .and_return(raw_metadata)
    end

    it 'returns the raw metadata string' do
      expect(obj.to_s).to eq(raw_metadata)
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
        o.version('1.2.3') && o
      end

      it 'uses the provided arg' do
        expect(obj.version).to eq('1.2.3')
        expect(obj.instance_variable_get(:@version)).to eq('1.2.3')
      end
    end

    context 'an invalid argument provided' do
      let(:obj) do
        o = super()
        o.version(false) && o
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
        o.prerelease(true) && o
      end

      it 'uses the provided arg' do
        expect(obj.prerelease).to eq(true)
        expect(obj.instance_variable_get(:@prerelease)).to eq(true)
      end
    end

    context 'an invalid argument provided' do
      let(:obj) do
        o = super()
        o.prerelease('wigglebot') && o
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
        o.nightlies(true) && o
      end

      it 'uses the provided arg' do
        expect(obj.nightlies).to eq(true)
        expect(obj.instance_variable_get(:@nightlies)).to eq(true)
      end
    end

    context 'an invalid argument provided' do
      let(:obj) do
        o = super()
        o.nightlies('hello') && o
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
        o.platform('ms_bob') && o
      end

      it 'uses the provided arg' do
        expect(obj.platform).to eq('ms_bob')
        expect(obj.instance_variable_get(:@platform)).to eq('ms_bob')
      end
    end

    context 'an invalid argument provided' do
      let(:obj) do
        o = super()
        o.platform(%w(windows linux)) && o
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
        o.platform_version('6.6.6') && o
      end

      it 'uses the provided arg' do
        expect(obj.platform_version).to eq('6.6.6')
        expect(obj.instance_variable_get(:@platform_version)).to eq('6.6.6')
      end
    end

    context 'an invalid argument provided' do
      let(:obj) do
        o = super()
        o.platform_version(%w(1 2 3)) && o
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
        o.machine_arch('arm') && o
      end

      it 'uses the provided arg' do
        expect(obj.machine_arch).to eq('arm')
        expect(obj.instance_variable_get(:@machine_arch)).to eq('arm')
      end
    end

    context 'an invalid argument provided' do
      let(:obj) do
        o = super()
        o.machine_arch(%w(some things)) && o
      end

      it 'raises an exception' do
        expect { obj }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end
  end

  describe '#raw_metadata' do
    let(:open) { double(read: 'SOME STUFF') }

    before(:each) do
      allow_any_instance_of(URI::HTTP).to receive(:open).and_return(open)
    end

    it 'returns a GET of the API URL' do
      expect(obj.send(:raw_metadata)).to eq('SOME STUFF')
      expect(obj.instance_variable_get(:@raw_metadata)).to eq('SOME STUFF')
    end
  end

  describe '#api_url' do
    let(:base_url) { 'http://example.com/chef' }
    let(:endpoint) { '/metadata-example' }
    let(:query_params) { { v: '1.2.3', p: 'ubuntu' } }

    before(:each) do
      [:base_url, :endpoint, :query_params].each do |i|
        allow_any_instance_of(described_class).to receive(i).and_return(send(i))
      end
    end

    it 'constructs a URL based on base + endpoint + params' do
      expected = URI.parse('http://example.com/chef/metadata-example?' \
                           'v=1.2.3&p=ubuntu')
      expect(obj.send(:api_url)).to eq(expected)
    end
  end

  describe '#query_params' do
    let(:args) do
      { version: '1.2.3',
        prerelease: true,
        nightlies: true,
        platform: 'ubuntu',
        platform_version: '14.04',
        machine_arch: 'x86_64' }
    end

    before(:each) do
      args.each do |k, v|
        allow_any_instance_of(described_class).to receive(k).and_return(v)
      end
    end

    it 'returns all the data with keys Omnitruck understands' do
      expected = { v: '1.2.3',
                   prerelease: true,
                   nightlies: true,
                   p: 'ubuntu',
                   pv: '14.04',
                   m: 'x86_64' }
      expect(obj.send(:query_params)).to eq(expected)
    end
  end

  describe '#endpoint' do
    let(:name) { 'chef_container' }

    it 'returns the appropriate metadata endpoint' do
      expect(obj.send(:endpoint)).to eq('/metadata-container')
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

  describe '#parsed_url_data' do
    let(:url) { nil }
    let(:res) { obj.send(:parse_url_data, url) }

    context 'a standard RHEL package URL' do
      let(:url) do
        'https://opscode-omnibus-packages.s3.amazonaws.com/el/6/x86_64/' \
          'chefdk-0.2.1-1.el6.x86_64.rpm'
      end

      it 'extracts the right filename' do
        expect(res[:filename]).to eq('chefdk-0.2.1-1.el6.x86_64.rpm')
      end

      it 'extracts the right version' do
        expect(res[:version]).to eq('0.2.1')
      end

      it 'extracts the right build' do
        expect(res[:build]).to eq('1')
      end
    end

    context 'a standard Ubuntu package URL' do
      let(:url) do
        'https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/' \
          'x86_64/chefdk_0.2.1-1_amd64.deb'
      end

      it 'extracts the right filename' do
        expect(res[:filename]).to eq('chefdk_0.2.1-1_amd64.deb')
      end

      it 'extracts the right version' do
        expect(res[:version]).to eq('0.2.1')
      end

      it 'extracts the right build' do
        expect(res[:build]).to eq('1')
      end
    end

    context 'a nightly package URL' do
      let(:url) do
        'https://opscode-omnibus-packages.s3.amazonaws.com/mac_os_x/' \
          '10.8/x86_64/chefdk-0.2.2%2B20140916163521.git.23.997cf31-1.dmg'
      end

      it 'extracts the right filename' do
        expected = 'chefdk-0.2.2+20140916163521.git.23.997cf31-1.dmg'
        expect(res[:filename]).to eq(expected)
      end

      it 'extracts the right version' do
        expect(res[:version]).to eq('0.2.2+20140916163521.git.23.997cf31')
      end

      it 'extracts the right build' do
        expect(res[:build]).to eq('1')
      end
    end
  end
end
