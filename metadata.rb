name             'piwik'
maintainer       'Jesse Cotton'
source_url       'https://github.com/JCotton1123/chef-piwik'
issues_url       'https://github.com/JCotton1123/chef-piwik/issues'
license          'All rights reserved'
description      'Installs/Configures piwik'
long_description 'Installs/Configures piwik'
version          '1.0.0'

depends 'database', '~> 4.0.9'
depends 'mysql2_chef_gem', '~> 1.0.0'
depends 'mysql', '~> 6.1.2'
depends 'nginx', '~> 2.7.6'
depends 'php', '~> 1.8.0'
