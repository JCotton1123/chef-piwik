#
# Cookbook Name:: piwik
# Resource:: plugin
#
# Copyright (C) 2016 Jesse Cotton
#
# All rights reserved - Do Not Redistribute
#

actions :install, :uninstall, :activate, :deactivate
default_action :install

property :plugin_name, String, name_property: true
property :version, String, required: true
property :url, [String, nil], required: false, default: nil
property :postinstall, [String, nil], required: false, default: nil
property :postactivate, [String, nil], required: false, default: nil

plugins_dir = "#{node['piwik']['app_root']}/plugins"

action :install do
  if url.nil?
    url = "#{node['piwik']['base_plugin_url']}/#{plugin_name}/download/#{version}"
  end

  local_zip_file = "#{plugin_name}-#{version}.zip"
  remote_file "#{Chef::Config[:file_cache_path]}/#{local_zip_file}" do
    source url
    owner node['piwik']['app_user']
    action :create_if_missing
  end

  b = bash "install piwik plugin #{plugin_name}-#{version}" do
    user node['piwik']['app_user']
    group node['piwik']['app_group']
    cwd Chef::Config[:file_cache_path]
    umask '002'
    code <<-EOH
      rm -rf #{plugins_dir}/#{plugin_name}
      unzip #{local_zip_file} -d #{plugins_dir}
      echo '#{version}' > #{plugins_dir}/#{plugin_name}/VERSION
      chown -R #{node['piwik']['app_user']}:#{node['piwik']['app_group']} #{plugins_dir}/#{plugin_name}
      chmod -R 775 #{plugins_dir}/#{plugin_name}
    EOH
    not_if "test `cat #{plugins_dir}/#{plugin_name}/VERSION` = #{version}"
  end

  bash "piwik plugin #{plugin_name}-#{version} postinstall cmd" do
    user node['piwik']['app_user']
    group node['piwik']['app_group']
    cwd "#{plugins_dir}/#{plugin_name}"
    umask '002'
    code postinstall
    only_if { !postinstall.nil? && b.updated_by_last_action? }
  end

  new_resource.updated_by_last_action(b.updated_by_last_action?)
end

action :uninstall do
  d = directory "#{plugins_dir}/#{plugin_name}" do
    recursive true
    action :delete
  end

  new_resource.updated_by_last_action(d.updated_by_last_action?)
end

action :activate do
  b = bash "activate piwik plugin #{plugin_name}-#{version}" do
    guard_interpreter :bash
    user node['piwik']['app_user']
    group node['piwik']['app_group']
    umask '002'
    code "#{node['piwik']['app_root']}/console --no-ansi plugin:activate #{plugin_name}"
    not_if "#{node['piwik']['app_root']}/console --no-ansi plugin:list | grep -e \"\\s#{plugin_name}\\s\" | grep -e \"Activated\""
  end

  bash "piwik plugin #{plugin_name}-#{version} postactivate cmd" do
    user node['piwik']['app_user']
    group node['piwik']['app_group']
    cwd "#{plugins_dir}/#{plugin_name}"
    umask '002'
    code postactivate
    only_if { !postactivate.nil? && b.updated_by_last_action? }
  end

  new_resource.updated_by_last_action(b.updated_by_last_action?)
end

action :deactivate do
  b = bash "deactivate piwik plugin #{plugin_name}-#{version}" do
    guard_interpreter :bash
    user node['piwik']['app_user']
    group node['piwik']['app_group']
    umask '002'
    code "#{node['piwik']['app_root']}/console --no-ansi plugin:deactivate #{plugin_name}"
    not_if "#{node['piwik']['app_root']}/console --no-ansi plugin:list | grep -e \"\\s#{plugin_name}\\s\" | grep -e \"Not activated\""
  end

  new_resource.updated_by_last_action(b.updated_by_last_action?)
end
