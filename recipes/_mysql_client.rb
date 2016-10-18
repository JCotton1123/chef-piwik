#
# Cookbook Name:: piwik
# Recipe:: default
#
# Copyright (C) 2016 Jesse Cotton
#
# All rights reserved - Do Not Redistribute
#

mysql_client 'default' do
  version node['piwik']['database']['version']
  action :create
end
