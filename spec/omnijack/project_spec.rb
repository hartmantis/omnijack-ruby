# Encoding: UTF-8

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
