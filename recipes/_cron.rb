#
# Cookbook Name:: piwik
# Recipe:: master
#
# Copyright (C) 2016 Jesse Cotton
#
# All rights reserved - Do Not Redistribute
#

cron 'piwik cache deletion' do
  minute '*/5'
  hour '*'
  user node['piwik']['app_user']
  command "rm -rf #{node['piwik']['app_root']}/tmp/cache/tracker/* > /dev/null"
  only_if { node['piwik']['cron']['enable_cache_deletion'] }
end

cron 'piwik archive' do
  minute '12'
  user node['piwik']['app_user']
  command "#{node['piwik']['app_root']}/misc/cron/archive.sh > /dev/null"
  only_if { node['piwik']['cron']['enable_archive'] }
end

cron 'piwik config sync' do
  minute '*'
  hour '*'
  user node['piwik']['sync_user']
  command [
    'rsync -e ssh',
    "#{node['piwik']['master_host']}:#{node['piwik']['app_root']}/config/config.ini.php",
    "#{node['piwik']['app_root']}/config/config.ini.php"
  ].join(' ')
  only_if { node['piwik']['cron']['enable_config_sync'] }
end
