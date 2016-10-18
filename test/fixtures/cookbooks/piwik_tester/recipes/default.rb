#
# Cookbook Name:: piwik_tester
# Recipe:: default
#

node.default['piwik']['database']['import_file'] = '/tmp/piwik-v2-16-0.sql'

cookbook_file node['piwik']['database']['import_file'] do
  source 'piwik-v2-16-0.sql'
  owner node['piwik']['app_user']
  group node['piwik']['app_group']
end

include_recipe 'piwik::default'
