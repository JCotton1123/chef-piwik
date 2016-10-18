#
# Cookbook Name:: piwik
# Recipe:: _app
#
# Copyright (C) 2016 Jesse Cotton
#
# All rights reserved - Do Not Redistribute
#

piwik_version = node['piwik']['version']
piwik_config_vars = {
  'database' => {
    'host' => node['piwik']['database_host'],
    'user' => node['piwik']['database']['user'],
    'user_pass' => node['piwik']['database']['user_pass'],
    'name' => node['piwik']['database']['name'],
    'prefix' => node['piwik']['database']['prefix']
  },
  'general' => {
    'salt' => node['piwik']['salt'],
    'trusted_hosts' => node['piwik']['trusted_hosts'],
    'force_ssl' => node['piwik']['force_ssl'],
    'assume_secure_protocol' => node['piwik']['assume_secure_protocol'],
    'session_save_handler' => node['piwik']['session_save_handler'],
    'proxy_client_headers' => node['piwik']['proxy_client_headers'],
    'proxy_host_headers' => node['piwik']['proxy_host_headers']
  },
  'mail' => {
    'transport' => 'smtp',
    'host' => 'localhost',
    'port' => 25
  }
}.merge!(node['piwik']['config_overrides'])

%w(curl unzip).each do |pkg|
  package pkg
end

directory "#{node['piwik']['app_base']}/#{piwik_version}" do
  owner node['piwik']['app_user']
  group node['piwik']['app_group']
  mode 0775
  recursive true
  action :create
end

remote_file "#{Chef::Config[:file_cache_path]}/piwik-#{piwik_version}.tar.gz" do
  source "http://builds.piwik.org/piwik-#{piwik_version}.tar.gz"
  action :create_if_missing
end

bash 'install piwik' do
  user 'root'
  cwd Chef::Config[:file_cache_path]
  code <<-EOS
    tar -zxf piwik-#{piwik_version}.tar.gz -C #{node['piwik']['app_base']}/#{piwik_version} --strip-components 1
    echo '#{piwik_version}' > #{node['piwik']['app_base']}/#{piwik_version}/VERSION
    ln -sf #{node['piwik']['app_base']}/#{piwik_version} #{node['piwik']['app_root']}
    chown -R #{node['piwik']['app_user']}:#{node['piwik']['app_group']} #{node['piwik']['app_root']}/
    chmod -R 775 #{node['piwik']['app_root']}/
  EOS
  not_if "test `cat #{node['piwik']['app_root']}/VERSION` = #{piwik_version}"
  notifies :restart, 'service[nginx]', :delayed
end

template "#{node['piwik']['app_root']}/config/config.ini.php" do
  cookbook node['piwik']['config_source_cookbook']
  source 'config.ini.php.erb'
  owner node['piwik']['app_user']
  group node['piwik']['app_group']
  mode 0775
  variables piwik_config_vars
  action node['piwik']['manage_config'] ? :create : :create_if_missing
  only_if { node['piwik']['create_config'] }
end

node['piwik']['plugins'].each do |plugin, properties|
  version = properties['version']
  url = properties.key?('url') ? properties['url'] : nil
  postinstall = properties.key?('postinstall') ? properties['postinstall'] : nil
  postactivate = properties.key?('postactivate') ? properties['postactivate'] : nil
  actions = node['piwik']['create_config'] ? [:install, :activate] : [:install]

  piwik_plugin plugin do
    version version
    url url
    postinstall postinstall
    postactivate postactivate
    action actions
  end
end
