#
# Cookbook Name:: tapalcatl
# Recipe:: setup
#
# Copyright 2016, Mapzen
#
# Available under the MIT license, see LICENSE for details
#

user_account node[:tapalcatl][:user][:user] do
  manage_home true
  create_group node[:tapalcatl][:user][:create_group]
  home node[:tapalcatl][:user][:home]
  only_if { node[:tapalcatl][:user][:enabled] }
end

directory node[:tapalcatl][:cfg_path] do
  action :create
  recursive true
end
