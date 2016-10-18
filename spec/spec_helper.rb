require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.platform = 'ubuntu'
  config.version = '12.04'

  config.before(:each) do
    stub_command('which nginx').and_return(1)

    stub_command('test `cat /var/www/piwik/current/VERSION` = 2.16.0').and_return(1)
  end
end
