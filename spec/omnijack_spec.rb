# Encoding: UTF-8

require_relative 'spec_helper'
require_relative '../lib/omnijack'

describe Omnijack do
  let(:name) { :chef_dk }
  let(:args) { nil }
  let(:obj) { described_class.new(name, args) }

  describe '#initialize' do
    shared_examples_for 'any context' do
      it 'sets the project name' do
        expect(obj.name).to eq(:chef_dk)
        expect(obj.instance_variable_get(:@name)).to eq(:chef_dk)
      end
    end

    context 'no args provided' do
      let(:obj) { described_class.new(name) }

      it_behaves_like 'any context'

      it 'holds an empty hash for the args' do
        expect(obj.args).to eq({})
        expect(obj.instance_variable_get(:@args)).to eq({})
      end
    end

    context 'some additional args' do
      let(:args) { { pants: 'off', shorts: 'on' } }

      it_behaves_like 'any context'

      it 'holds onto the args' do
        expect(obj.args).to eq(args)
        expect(obj.instance_variable_get(:@args)).to eq(args)
      end
    end
  end

  describe '#name' do
    let(:name) { 'chef_container' }

    it 'returns the project name, symbolized' do
      expect(obj.name).to eq(:chef_container)
    end
  end

  describe '#args' do
    let(:args) { { platform: 'thing' } }

    it 'returns the provided args' do
      expect(obj.args).to eq(args)
    end
  end
end
