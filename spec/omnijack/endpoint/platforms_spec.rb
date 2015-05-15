# Encoding: UTF-8

require_relative '../../spec_helper'
require_relative '../../../lib/omnijack/endpoint/platforms'

describe Omnijack::Endpoint::Platforms do
  let(:name) { :chef_dk }
  let(:obj) { described_class.new(name) }

  describe '#endpoint' do
    let(:name) { :chef_container }

    it 'returns the appropriate metadata endpoint' do
      expect(obj.send(:endpoint)).to eq('/chef_container_platform_names')
    end
  end
end
