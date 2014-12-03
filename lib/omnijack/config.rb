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
    DEFAULT_BASE_URL ||= 'https://www.chef.io/chef'
    OMNITRUCK_PROJECTS ||= {
      angry_chef: {
        endpoints: {
          metadata: '/metadata-angrychef',
          list: '/full_angrychef_list',
          platforms: '/angrychef_platform_names'
        }
      },
      chef: {
        endpoints: {
          metadata: '/metadata',
          list: '/full_client_list',
          platforms: '/chef_platform_names'
        }
      },
      chef_dk: {
        endpoints: {
          metadata: '/metadata-chefdk',
          list: '/full_chefdk_list',
          platforms: '/chefdk_platform_names'
        }
      },
      chef_container: {
        endpoints: {
          metadata: '/metadata-container',
          list: '/full_container_list',
          platforms: '/chef_container_platform_names'
        }
      },
      chef_server: {
        endpoints: {
          metadata: '/metadata-server',
          list: '/full_server_list',
          platforms: '/chef_server_platform_names'
        }
      }
    }
    METADATA_ATTRIBUTES ||= [:url, :md5, :sha256, :yolo]
  end
end
