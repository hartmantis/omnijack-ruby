# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../lib/omnijack/endpoint'

describe Omnijack::Endpoint do
  let(:name) { :chef_dk }
  let(:args) { {} }
  let(:obj) { described_class.new(name, args) }

  describe '#initialize' do
    shared_examples_for 'any context' do
      it 'sets the project name' do
        expect(obj.name).to eq(:chef_dk)
        expect(obj.instance_variable_get(:@name)).to eq(:chef_dk)
      end
    end

    context 'no extra args provided' do
      let(:obj) { described_class.new(name) }

      it_behaves_like 'any context'

      it 'holds an empty hash for the args' do
        expect(obj.args).to eq({})
        expect(obj.instance_variable_get(:@args)).to eq({})
      end
    end

    context 'a base_url arg provided' do
      let(:args) { { base_url: 'https://example.com' } }

      it_behaves_like 'any context'

      it 'sets the given arg' do
        expect(obj.send(:base_url)).to eq(args[:base_url])
        expect(obj.instance_variable_get(:@base_url)).to eq(args[:base_url])
      end
    end
  end

  describe '#method_missing' do
    let(:to_h) { { thing1: 'yup', thing2: 'nope', thing3: 'maybe' } }

    before(:each) do
      allow_any_instance_of(described_class).to receive(:to_h).and_return(to_h)
    end

    it 'sets up methods for the platform hash keys' do
      expect(obj.thing1).to eq('yup')
      expect(obj.thing2).to eq('nope')
      expect(obj.thing3).to eq('maybe')
    end

    it 'raises an exception otherwise' do
      expect { obj.thing4 }.to raise_error(NoMethodError)
    end
  end

  describe '#[]' do
    let(:to_h) { { thing1: 'yup', thing2: 'nope', thing3: 'maybe' } }

    before(:each) do
      allow_any_instance_of(described_class).to receive(:to_h).and_return(to_h)
    end

    it 'returns the correct data' do
      expect(obj[:thing1]).to eq('yup')
      expect(obj[:thing2]).to eq('nope')
      expect(obj[:thing3]).to eq('maybe')
    end
  end

  describe '#to_h' do
    context 'fake data' do
      let(:raw_data) { '{"thing1": "yup", "thing2": "nope"}' }

      before(:each) do
        allow_any_instance_of(described_class).to receive(:raw_data)
          .and_return(raw_data)
      end

      it 'returns the correct result hash' do
        expect(obj.to_h).to eq(thing1: 'yup', thing2: 'nope')
      end
    end

    context 'real data' do
      let(:endpoint) { '/full_client_list' }
      let(:obj) { described_class.new(:chef) }

      before(:each) do
        allow_any_instance_of(described_class).to receive(:endpoint)
          .and_return(endpoint)
      end

      it 'returns the expected data' do
        expected = '/el/6/i686/chef-10.12.0-1.el6.i686.rpm'
        expect(obj.to_h[:suse][:'12.1'][:i686][:'10.12.0-1']).to eq(expected)
      end
    end
  end

  describe '#to_s' do
    let(:raw_data) { 'SOME STUFF' }

    before(:each) do
      allow_any_instance_of(described_class).to receive(:raw_data)
        .and_return(raw_data)
    end

    it 'returns the raw data' do
      expect(obj.to_s).to eq('SOME STUFF')
    end
  end

  describe '#base_url' do
    context 'no argument provided' do
      it 'uses the default' do
        res = obj
        expected = 'https://www.chef.io/chef'
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

  describe '#raw_data' do
    let(:read) { '{"thing1": "yup", "thing2": "nope"}' }
    let(:api_url) { double(open: double(read: read)) }

    before(:each) do
      allow_any_instance_of(described_class).to receive(:api_url)
        .and_return(api_url)
    end

    it 'returns a GET of the API URL' do
      res = obj
      expect(res.send(:raw_data)).to eq(read)
      expect(res.instance_variable_get(:@raw_data)).to eq(read)
    end
  end

  describe '#api_url' do
    let(:base_url) { 'http://example.com/chef' }
    let(:endpoint) { '/example_list' }

    before(:each) do
      [:base_url, :endpoint].each do |i|
        allow_any_instance_of(described_class).to receive(i).and_return(send(i))
      end
    end

    it 'constructs a URL based on base + endpoint' do
      expected = URI.parse('http://example.com/chef/example_list')
      expect(obj.send(:api_url)).to eq(expected)
    end
  end

  describe '#endpoint' do
    let(:name) { :cook }

    before(:each) do
      stub_const('::Omnijack::Endpoint::OMNITRUCK_PROJECTS',
                 cook: { endpoints: { endpoint: '/there' } })
    end

    it 'returns the appropriate metadata endpoint' do
      expect(obj.send(:endpoint)).to eq('/there')
    end
  end
end
