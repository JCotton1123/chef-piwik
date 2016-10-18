#
# Cookbook Name:: piwik
# Recipe:: _nginx
#
# Copyright (C) 2016 Jesse Cotton
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'nginx'

nginx_site 'default' do
  enable false
end

nginx_site 'piwik' do
  enable true
  template 'nginx-site.erb'
  variables(
    'server_name' => node['piwik']['nginx']['server_name'],
    'app_root' => node['piwik']['app_root'],
    'enable_ssl' => node['piwik']['nginx']['enable_ssl'],
    'ssl_cert_file' => node['piwik']['nginx']['ssl_cert_file'],
    'ssl_key_file' => node['piwik']['nginx']['ssl_key_file'],
    'enable_https_redirect' => node['piwik']['nginx']['enable_https_redirect'],
    'enable_https_x_forwarded_proto_redirect' => node['piwik']['nginx']['enable_https_x_forwarded_proto_redirect']
  )
end
