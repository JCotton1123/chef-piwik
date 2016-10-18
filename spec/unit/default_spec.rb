require 'spec_helper'

describe 'piwik::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(file_cache_path: '/tmp') do |node|
      node.set['piwik']['version'] = '2.16.0'
      node.set['piwik']['plugins'] = {
        'IP2Location' => {
          'version' => '2.1.8',
          'postinstall' => [
            'cd data',
            'curl http://www.ip2location.com/downloads/sample.bin.db2.zip > db.zip',
            'unzip db.zip'
          ].join(' && ')
        }
      }
      node.set['piwik']['nginx']['server_name'] = 'test.example.com'
      node.set['piwik']['php']['max_children'] = 50
      node.set['piwik']['php']['start_servers'] = 25
      node.set['piwik']['php']['min_spare_servers'] = 10
      node.set['piwik']['php']['max_spare_servers'] = 10
      node.set['piwik']['php']['memory_limit'] = '256M'
      node.set['piwik']['php']['date_timezone'] = 'America/New_York'
    end.converge(described_recipe)
  end

  it 'include nginx::default recipe' do
    expect(chef_run).to include_recipe('nginx')
  end

  it 'include php::default recipe' do
    expect(chef_run).to include_recipe('php')
  end

  it 'install php extensions' do
    expect(chef_run).to install_package('php5-gd')
    expect(chef_run).to install_package('php5-mysql')
  end

  it 'create piwik php fpm pool' do
    expect(chef_run).to install_php_fpm_pool('piwik').with(
      max_children: 50,
      start_servers: 25,
      min_spare_servers: 10,
      max_spare_servers: 10,
      additional_config: {
        'php_admin_flag[log_errors]' => 'on',
        'php_admin_value[memory_limit]' => '256M',
        'php_admin_value[date.timezone]' => 'America/New_York'
      }
    )
  end

  it 'create piwik_sync user' do
    expect(chef_run).to create_user('piwik_sync').with(
      group: 'www-data',
      home: '/home/piwik_sync'
    )
  end

  it 'install app package dependencies' do
    expect(chef_run).to install_package('curl')
    expect(chef_run).to install_package('unzip')
  end

  it 'create piwik base directory' do
    expect(chef_run).to create_directory('/var/www/piwik/2.16.0').with(
      owner: 'www-data',
      group: 'www-data',
      mode: 0775
    )
  end

  it 'download piwik source tarball' do
    expect(chef_run).to create_remote_file_if_missing('/tmp/piwik-2.16.0.tar.gz').with(
      source: 'http://builds.piwik.org/piwik-2.16.0.tar.gz'
    )
  end

  it 'install plugins' do
    expect(chef_run).to install_piwik_plugin('IP2Location').with(
      version: '2.1.8',
      postinstall: 'cd data && curl http://www.ip2location.com/downloads/sample.bin.db2.zip > db.zip && unzip db.zip'
    )
  end
end
