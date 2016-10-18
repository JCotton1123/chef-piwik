#
# Cookbook Name:: piwik
# Recipe:: default
#
# Copyright (C) 2016 Jesse Cotton
#
# All rights reserved - Do Not Redistribute
#

node.default['piwik']['is_master_slave_setup'] = false

include_recipe 'piwik::_mysql_server'
include_recipe 'piwik::_nginx'
include_recipe 'piwik::_php'
include_recipe 'piwik::_user'
include_recipe 'piwik::_app'
