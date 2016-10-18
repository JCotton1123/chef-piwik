require 'spec_helper'

app_root = '/var/www/piwik/current'

describe file("#{app_root}/plugins/CustomDimensions/VERSION") do
  it { should be_file }
  it { should contain '0.1.4' }
end

describe command("#{app_root}/console customdimensions:info | grep '15 Custom Dimensions available in scope \"action\"'") do
  its(:exit_status) { should eq 0 }
end

describe file("#{app_root}/plugins/IP2Location/VERSION") do
  it { should be_file }
  it { should contain '2.1.8' }
end

describe file("#{app_root}/plugins/IP2Location/data/IP2LOCATION-COUNTRY.CSV") do
  it { should be_file }
end
