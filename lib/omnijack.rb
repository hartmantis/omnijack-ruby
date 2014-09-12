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

unless Module.const_defined?(:Chef)
  require_relative '../vendor/chef/lib/chef/exceptions'
  require_relative '../vendor/chef/lib/chef/mixin/params_validate'
end
require_relative 'omnijack/config'
require_relative 'omnijack/project'
require_relative 'omnijack/list'
require_relative 'omnijack/metadata'
require_relative 'omnijack/platforms'
require_relative 'omnijack/version'

# Provide a base class with some commons everyone can inherit
#
# @author Jonathan Hartman <j@p4nt5.com>
class Omnijack
  include ::Chef::Mixin::ParamsValidate
  include Config

  def initialize(name, args = {})
    @name = name.to_sym
    @args = args
    base_url(args[:base_url]) if args && args[:base_url]
  end
  attr_reader :name, :args

  #
  # The base URL of the Omnitruck API
  #
  # @param [String, NilClass] arg
  # @return [String]
  #
  def base_url(arg = nil)
    # TODO: Better URL validation
    set_or_return(:base_url, arg, kind_of: String, default: DEFAULT_BASE_URL)
  end

  # TODO: Every class' `endpoint` method is similar enough they could go here
end
