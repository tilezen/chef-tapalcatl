#
# Cookbook Name:: tapalcatl
# Recipe:: install
#
# Copyright 2016, Mapzen
#
# Available under the MIT license, see LICENSE for details
#

include_recipe "runit"

template "#{node[:tapalcatl][:cfg_path]}/#{node[:tapalcatl][:cfg_file]}" do
  source 'tapalcatl-config.conf.erb'
  notifies :restart, 'runit_service[tapalcatl]', :delayed
end

golang_package node[:tapalcatl][:package] do
  action [:update, :install]
  notifies :restart, 'runit_service[tapalcatl]', :delayed
end

execute 'allow tapalcatl to bind on <1024 ports' do
  command 'setcap cap_net_bind_service=+ep ' + node['go']['gobin'] + '/tapalcatl_server'
end

runit_service 'tapalcatl' do
  action [:enable]
  log true
  default_logger true
  sv_timeout node[:tapalcatl][:runit][:timeout]
end
