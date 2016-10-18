require 'spec_helper'

describe file('/var/www/piwik/current/VERSION') do
  it { should be_file }
  it { should contain '2.16.0' }
end

describe port(80) do
  it { should be_listening }
end

describe command('curl -L http://localhost | grep "Sign in"') do
  its(:exit_status) { should eq 0 }
end
