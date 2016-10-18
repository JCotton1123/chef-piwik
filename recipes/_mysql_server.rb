#
# Cookbook Name:: piwik
# Recipe:: _mysql_server
#
# Copyright (C) 2016 Jesse Cotton
#
# All rights reserved - Do Not Redistribute
#

mysql_conn_info = {
  host: 'localhost',
  username: 'root',
  password: node['piwik']['database']['root_password'],
  socket: '/run/mysql-default/mysqld.sock'
}

template '/root/.my.cnf' do
  source 'client.my.cnf.erb'
  owner 'root'
  mode '0600'
  variables mysql_conn_info
end

mysql2_chef_gem 'default' do
  action :install
end

mysql_service 'default' do
  port '3306'
  version node['piwik']['database']['version']
  initial_root_password node['piwik']['database']['root_password']
  action [:create, :start]
end

mysql_database node['piwik']['database']['name'] do
  connection mysql_conn_info
  action :create
end

bash "init #{node['piwik']['database']['name']} database" do
  user 'root'
  code "mysql #{node['piwik']['database']['name']} < #{node['piwik']['database']['import_file']}"
  environment 'HOME' => '/root'
  action :nothing
  not_if { node['piwik']['database']['import_file'].nil? }
  subscribes :run, "mysql_database[#{node['piwik']['database']['name']}]", :immediately
end

mysql_database_user node['piwik']['database']['user'] do
  connection mysql_conn_info
  password node['piwik']['database']['user_pass']
  database_name node['piwik']['database']['name']
  host '%'
  privileges ['ALL']
  action [:create, :grant]
end
