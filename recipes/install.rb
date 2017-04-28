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

url = "https://s3.amazonaws.com/mapzen.software/tile/tapalcatl/tapalcatl_server-#{node[:tapalcatl][:revision]}"
remote_file "#{node[:tapalcatl][:bin]}/tapalcatl_server" do
  source url
  mode '0755'
  action :create
  notifies :restart, 'runit_service[tapalcatl]', :delayed
end

execute 'allow tapalcatl to bind on <1024 ports' do
  command 'setcap cap_net_bind_service=+ep ' + node[:tapalcatl][:bin] + '/tapalcatl_server'
end

# create directory, since runit doesn't seem to do this automatically
directory '/var/log/tapalcatl' do
  action :create
  recursive true
end

# set the default to the max if there's no default set
ruby_block "set default ulimit" do
  block do
    unless node.default[:tapalcatl][:limits][:open_files]
      max = File.read('/proc/sys/fs/file-max').to_i
      # sanity check
      if max >= 1024
        node.default[:tapalcatl][:limits][:open_files] = max
      end
    end
  end
end

runit_service 'tapalcatl' do
  action [:enable]
  log true
  default_logger false
  sv_timeout node[:tapalcatl][:runit][:timeout]
end
