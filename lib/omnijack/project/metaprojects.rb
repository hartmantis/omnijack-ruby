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

require_relative '../config'
require_relative '../project'

class Omnijack
  class Project < Omnijack
  end
end

# Dynamically define classes for each configured project
#
# @author Jonathan Hartman <j@p4nt5.com>
Omnijack::Config::OMNITRUCK_PROJECTS.each do |project_name, _|
  klass = Class.new(Omnijack::Project) do
    define_method(:initialize) do |args = {}|
      super(project_name, args)
    end

    # Override to prevent setting a different project
    #
    # @return [Symbol]
    #
    define_method(:project) do |arg = nil|
      set_or_return(:project,
                    !arg.nil? ? arg.to_sym : nil,
                    equal_to: project_name)
    end
  end
  class_name = project_name.to_s.split('_').map(&:capitalize).join
  Omnijack::Project.const_set(class_name, klass)
end
