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

require 'json'
require_relative '../spec_helper'
require_relative '../../lib/omnijack/metadata'

describe Omnijack::Metadata do
  let(:attributes) { [:url, :md5, :sha256, :yolo, :filename] }
  let(:base_url) { 'http://example.com' }
  let(:obj) { described_class.new(base_url) }

  describe '#attributes' do
    it 'returns all the recognized metadata attributes' do
      expect(described_class.attributes).to eq(attributes)
    end
  end

  describe '#initialize' do
    context 'no additional args' do
      it 'sets the API URL instance variable' do
        [obj.api_url, obj.instance_variable_get(:@api_url)].each do |i|
          expect(i).to eq(URI.parse("#{base_url}?"))
        end
      end
    end

    context 'all the possible additional args' do
      let(:obj) do
        described_class.new(base_url,
                            v: '1.2',
                            prerelease: true,
                            nightlies: true,
                            p: 'mac_os_x',
                            pv: '10.9',
                            m: 'x86_64')
      end

      it 'formats the API URL properly' do
        expected = URI.parse("#{base_url}?v=1.2&prerelease=true&" \
                             'nightlies=true&p=mac_os_x&pv=10.9&m=x86_64')
        expect(obj.api_url).to eq(expected)
        expect(obj.instance_variable_get(:@api_url)).to eq(expected)
      end
    end
  end

  [:url, :md5, :sha256, :yolo, :filename].each do |i|
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
    before(:each) do
      allow_any_instance_of(described_class).to receive(:to_h)
        .and_return(attributes.each_with_object({}) do |a, hsh|
                      hsh[a] = "#{a} things"
                      hsh
                    end)
    end

    [:url, :md5, :sha256, :yolo, :filename].each do |a|
      it "returns the correct #{a}" do
        expect(obj[a]).to eq("#{a} things")
      end
    end
  end

  describe '#to_h' do
    context 'fake data' do
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
                     filename: 'chefdk-0.2.1-1.el6.x86_64.rpm' }
        expect(obj.to_h).to eq(expected)
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

    json = ::File.open(File.expand_path('../../support/real_test_data.json',
                                        __FILE__)).read
    JSON.parse(json, symbolize_names: true).each do |data|
      context "#{data[:platform]} Chef-DK" do
        let(:obj) do
          described_class.new('https://www.getchef.com/chef/metadata-chefdk',
                              v: data[:version],
                              prerelease: data[:prerelease],
                              nightlies: data[:nightlies],
                              p: data[:platform][:name],
                              pv: data[:platform][:version],
                              m: 'x86_64')
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
end
