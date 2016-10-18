default['piwik']['version'] = 'latest'

default['piwik']['app_user'] = node['nginx']['user']
default['piwik']['app_group'] = node['nginx']['user']
default['piwik']['sync_user'] = 'piwik_sync'

default['piwik']['app_base'] = '/var/www/piwik'
default['piwik']['app_root'] = '/var/www/piwik/current'

default['piwik']['database_host'] = node['ipaddress']
default['piwik']['master_host'] = node['ipaddress']

default['piwik']['create_config'] = false
default['piwik']['manage_config'] = false

default['piwik']['config_source_cookbook'] = 'piwik'
default['piwik']['config_overrides'] = {}

default['piwik']['salt'] = '7a3a2f32e2d8d2cff502859492df6b8a'
default['piwik']['trusted_hosts'] = [
  node['ipaddress'],
  node['domain']
]
default['piwik']['force_ssl'] = 0
default['piwik']['assume_secure_protocol'] = 0
default['piwik']['session_save_handler'] = 'dbtable'
default['piwik']['proxy_client_headers'] = []
default['piwik']['proxy_host_headers'] = []

default['piwik']['base_plugin_url'] = 'https://plugins.piwik.org/api/2.0/plugins'
default['piwik']['plugins'] = {}
