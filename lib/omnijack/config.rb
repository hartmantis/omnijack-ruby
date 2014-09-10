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

class Omnijack
  # Offer a config to base all the metaruby off of
  #
  # @author Jonathan Hartman <j@p4nt5.com>
  module Config
    DEFAULT_BASE_URL ||= 'https://www.getchef.com/chef'
    OMNITRUCK_PROJECTS ||= {
      angry_chef: {
        api_endpoints: {
          metadata: '/metadata-angrychef',
          package_list: '/full_angrychef_list',
          platform_names: '/angrychef_platform_names'
        }
      },
      chef: {
        api_endpoints: {
          metadata: '/metadata',
          package_list: '/full_client_list',
          platform_names: '/chef_platform_names'
        }
      },
      chef_dk: {
        api_endpoints: {
          metadata: '/metadata-chefdk',
          package_list: '/full_chefdk_list',
          platform_names: '/chefdk_platform_names'
        }
      },
      chef_container: {
        api_endpoints: {
          metadata: '/metadata-container',
          package_list: '/full_container_list',
          platform_names: '/chef_container_platform_names'
        }
      },
      chef_server: {
        api_endpoints: {
          metadata: '/metadata-server',
          package_list: '/full_server_list',
          platform_names: '/chef_server_platform_names'
        }
      }
    }
  end
end
