# Encoding: UTF-8

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
