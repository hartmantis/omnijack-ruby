# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../lib/omnijack/config'

describe Omnijack::Config do
  describe 'DEFAULT_BASE_URL' do
    it 'uses the official Chef API' do
      expected = 'https://www.chef.io/chef'
      expect(described_class::DEFAULT_BASE_URL).to eq(expected)
    end
  end

  describe 'OMNITRUCK_PROJECTS' do
    it 'recognizes all the valid Omnitruck projects' do
      expected = [:angry_chef, :chef, :chef_dk, :chef_container, :chef_server]
      expect(described_class::OMNITRUCK_PROJECTS.keys).to eq(expected)
    end

    described_class::OMNITRUCK_PROJECTS.each do |project, attrs|
      attrs[:endpoints].each do |name, endpoint|
        it "uses a valid #{project}::#{name} endpoint" do
          url = "http://www.chef.io/chef#{endpoint}"
          url << '?v=latest&p=ubuntu&pv=12.04&m=x86_64' if name == :metadata

          # Some endpoints aren't available on Chef's public Omnitruck API
          if [:angry_chef, :chef_dk, :chef_container].include?(project) && \
             [:list, :platforms].include?(name)
            expected = 301
          else
            expected = 200
          end

          expect(Net::HTTP.get_response(URI(url)).code.to_i).to eq(expected)
        end
      end
    end
  end
end
