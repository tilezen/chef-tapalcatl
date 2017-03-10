#
# Cookbook Name:: tapalcatl
# Recipe:: install
#
# Copyright 2016, Mapzen
#
# Available under the MIT license, see LICENSE for details
#

include_recipe "runit"

storage = {
  's3' => {
    'bucket' => node[:tapalcatl][:s3][:bucket],
    'keypattern' => node[:tapalcatl][:s3][:keypattern],
    'layer' => 'all',
    'metatilesize' => 1,
    'healthcheck' => node[:tapalcatl][:s3][:healthcheck],
  }
}
pattern = {
  '/mapzen/vector/v1/all/{z:[0-9]+}/{x:[0-9]+}/{y:[0-9]+}.{fmt}' => {
    'storage' => 's3',
    'prefix' => node[:tapalcatl][:handler][:s3][:prefix],
  }
}
handler_cfg = {
  'aws' => {
    'region' => node[:tapalcatl][:aws][:region],
  },
  'mime' => node[:tapalcatl][:mime],
  'storage' => storage,
  'pattern' => pattern,
}

template "#{node[:tapalcatl][:cfg_path]}/#{node[:tapalcatl][:cfg_file]}" do
  source 'tapalcatl-config.conf.erb'
  notifies :restart, 'runit_service[tapalcatl]', :delayed
  variables(
    handler_cfg: handler_cfg
  )
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

runit_service 'tapalcatl' do
  action [:enable]
  log true
  default_logger false
  sv_timeout node[:tapalcatl][:runit][:timeout]
end
