require 'spec_helper'

describe 'piwik::master' do
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

  it 'setup ssh authorized_keys file' do
    expect(chef_run).to create_file('/home/piwik_sync/.ssh/authorized_keys').with(
      owner: 'piwik_sync',
      mode: 0600
    )
    expect(chef_run).to render_file('/home/piwik_sync/.ssh/authorized_keys').with_content(
      'ssh-rsa AAAAB3Nz ... piwik@master'
    )
  end

  it 'create cache deletion cron job' do
    expect(chef_run).to create_cron('piwik cache deletion').with(
      user: 'www-data',
      command: 'rm -rf /var/www/piwik/current/tmp/cache/tracker/* > /dev/null'
    )
  end

  it 'create archive cron job' do
    expect(chef_run).to create_cron('piwik archive').with(
      user: 'www-data',
      command: '/var/www/piwik/current/misc/cron/archive.sh > /dev/null'
    )
  end

  it 'do not create config sync cron job' do
    expect(chef_run).to_not create_cron('piwik config sync')
  end
end
