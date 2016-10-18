default['piwik']['nginx']['server_name'] = node['fqdn']

default['piwik']['nginx']['enable_ssl'] = false
default['piwik']['nginx']['ssl_cert_file'] = nil
default['piwik']['nginx']['ssl_key_file'] = nil
default['piwik']['nginx']['enable_https_redirect'] = false

default['piwik']['nginx']['enable_https_x_forwarded_proto_redirect'] = false
