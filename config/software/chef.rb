#
# Copyright:: Copyright (c) 2012 Opscode, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

name "chef"
case project.name
when "chef", "chef-server"
  version Omnibus::BuildVersion.version_tag
else
  version "0.10.8"
end

dependencies ["ruby", "rubygems", "yajl"]

build do
  gem ["install chef",
      "-v #{version}",
      "-n #{install_dir}/bin",
      "--no-rdoc --no-ri"].join(" ")

  gem ["install highline net-ssh-multi", # TODO: include knife gems?
       "-n #{install_dir}/bin",
       "--no-rdoc --no-ri"].join(" ")

  #
  # TODO: the "clean up" section below was cargo-culted from the
  # clojure version of omnibus that depended on the build order of the
  # tasks and not dependencies. if we really need to clean stuff up,
  # we should probably stick the clean up steps somewhere else
  #

  # clean up
  ["docs",
   "share/man",
   "share/doc",
   "share/gtk-doc",
   "ssl/man",
   "man",
   "info"].each do |dir|
    command "rm -rf #{install_dir}/embedded/#{dir}"
  end
end
