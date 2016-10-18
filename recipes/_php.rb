#
# Cookbook Name:: piwik
# Recipe:: _php
#
# Copyright (C) 2016 Jesse Cotton
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'php'

[
  'php5-mysql', 'php5-gd'
].each do |pkg|
  package pkg
end

php_fpm_pool 'piwik' do
  listen 'localhost:9000'
  process_manager 'dynamic'
  max_children node['piwik']['php']['max_children']
  start_servers node['piwik']['php']['start_servers']
  min_spare_servers node['piwik']['php']['min_spare_servers']
  max_spare_servers node['piwik']['php']['max_spare_servers']
  additional_config(
    'php_admin_flag[log_errors]' => 'on',
    'php_admin_value[memory_limit]' => node['piwik']['php']['memory_limit'],
    'php_admin_value[date.timezone]' => node['piwik']['php']['date_timezone']
  )
  action :install
end
