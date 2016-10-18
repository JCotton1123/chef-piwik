require 'spec_helper'

describe 'piwik::slave' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['piwik']['version'] = '2.16.0'
    end.converge(described_recipe)
  end

  before do
    stub_data_bag_item('piwik', 'secrets').and_return(
      'master_public_key' => 'ssh-rsa AAAAB3Nz ... piwik@master',
      'master_private_key' => '-----BEGIN RSA PRIVATE KEY----- ... -----END RSA PRIVATE KEY-----'
    )
  end

  it 'setup ssh access to master' do
    expect(chef_run).to create_file('/home/piwik_sync/.ssh/id_rsa').with(
      owner: 'piwik_sync',
      mode: 0600
    )
    expect(chef_run).to render_file('/home/piwik_sync/.ssh/id_rsa').with_content(
      '-----BEGIN RSA PRIVATE KEY----- ... -----END RSA PRIVATE KEY-----'
    )
  end

  it 'create cache deletion cron job' do
    expect(chef_run).to create_cron('piwik cache deletion').with(
      user: 'www-data',
      command: 'rm -rf /var/www/piwik/current/tmp/cache/tracker/* > /dev/null'
    )
  end

  it 'create config sync cron job' do
    expect(chef_run).to create_cron('piwik config sync').with(
      user: 'piwik_sync',
      command: [
        'rsync -e ssh',
        '10.0.0.2:/var/www/piwik/current/config/config.ini.php',
        '/var/www/piwik/current/config/config.ini.php'
      ].join(' ')
    )
  end

  it 'do not create archive cron job' do
    expect(chef_run).to_not create_cron('piwik archive')
  end
end
