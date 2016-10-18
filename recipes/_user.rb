#
# Cookbook Name:: piwik
# Recipe:: _user
#
# Copyright (C) 2016 Jesse Cotton
#
# All rights reserved - Do Not Redistribute
#

if node['piwik']['is_master_slave_setup']
  secrets = data_bag_item('piwik', 'secrets')
end

user node['piwik']['sync_user'] do
  group node['piwik']['app_group']
  home "/home/#{node['piwik']['sync_user']}"
  manage_home true
end

if node['piwik']['is_master_slave_setup']
  directory "/home/#{node['piwik']['sync_user']}/.ssh" do
    owner node['piwik']['sync_user']
    mode 0700
  end
  file "/home/#{node['piwik']['sync_user']}/.ssh/authorized_keys" do
    content secrets['master_public_key']
    owner node['piwik']['sync_user']
    mode 0600
  end
  file "/home/#{node['piwik']['sync_user']}/.ssh/id_rsa" do
    content secrets['master_private_key']
    owner node['piwik']['sync_user']
    mode 0600
  end
  execute "keyscan #{node['piwik']['master_host']}" do
    command "ssh-keyscan #{node['piwik']['master_host']} >> ~/.ssh/known_hosts"
    not_if { ::File.exist?('~/.ssh/known_hosts') }
    user node['piwik']['sync_user']
    environment 'HOME' => "/home/#{node['piwik']['sync_user']}"
  end
end
