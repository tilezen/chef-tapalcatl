#
# Cookbook Name:: tapalcatl
# Recipe:: default
#
# Copyright 2016, Mapzen
#
# Available under the MIT license, see LICENSE for details
#

%w(
  apt::default
  tapalcatl::setup
  tapalcatl::install
).each do |r|
  include_recipe r
end
