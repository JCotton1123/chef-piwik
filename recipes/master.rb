#
# Cookbook Name:: piwik
# Recipe:: master
#
# Copyright (C) 2016 Jesse Cotton
#
# All rights reserved - Do Not Redistribute
#

node.default['piwik']['is_master_slave_setup'] = true
node.default['piwik']['cron']['enable_archive'] = true
node.default['piwik']['cron']['enable_cache_deletion'] = true

include_recipe 'piwik::_mysql_client'
include_recipe 'piwik::_nginx'
include_recipe 'piwik::_php'
include_recipe 'piwik::_user'
include_recipe 'piwik::_app'
include_recipe 'piwik::_cron'
