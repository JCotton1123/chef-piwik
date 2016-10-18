# Chef Piwik Cookbook

Setup an instance of the Piwik analytics platform.

## Supported Platforms

Ubuntu 14.04

## Usage

This cookbook can bring up a fully configured instance of Piwik if you supply
a mysqldump containing your data. Alternatively, if you do not supply a
mysqldump it will handle all of the configuration up to but excluding the setup
`wizard`.

There are a number of deployment configurations that are optimized for the volume
of traffic you anticipate.

### Low Volume/Testing + Development

For small volume sites, or development and testing, you can deploy Piwik and MySQL
on the same server.

Include the `piwik::default` recipe in your run list.

### Medium Volume

For medium volume sites you can deploy Piwik on one server and MySQL on another.
You can also choose to take advantage of a service like AWS RDS and completely
outsource MySQL.

On the database server, include `piwik::database`.
On the web/application server, include `piwik::master`.

### Medium - High Volume

On higher volume sites you can horizontally scale your Piwik servers. You should deploy
at least one master, which should be used for adminstrative tasks, and *n* slaves which
will handle the bulk of the tracking traffic.

On the database server, include `piwik::database`.
On the master web/application server, include `piwik::master`.
On the slave web/application servers, include `piwik::slave`.

Note: the master serves as the authoritative configuration source. Its configuration
is rsynced to the slaves.

## Attributes

Only the important ones are documented here. See the `attributes/` directory
for additional configurable attributes.

### piwik.version

The specified version of Piwik will be installed. Note that you can supply `latest`.

### piwik.plugins

Supply a hash of plugins to be installed. Example:

```ruby
default['piwik']['plugins'] = {
  'IP2Location' => {
    'version' => '2.1.8',
    'postinstall_cmd' => [
      'cd data',
      'curl http://www.ip2location.com/downloads/sample.bin.db2.zip',
      'unzip sample.bin.db2.zip' 
    ].join(' && ')
  },
  'CustomPlugin' => {
    'version' => '0.5.3',
    'url' => 'http://artifacts.example.com/path/to/plugin.zip'
  }
}
```

### piwik.database\_host

The FQDN of the database server. This only needs to be specified if 
you're deploying the MySQL database on a separate server.

### piwik.master\_host

The FQDN of the master server. This only needs to be specified if you're
deploying slaves.

### piwik.database.import\_file

Initialize the Piwik database with the supplied file. The specified file must
be a local file and it must already exist. Wrap this cookbook to implement
any custom functionality required to deploy this file.

### piwik.force\_ssl

Set this to `1` to enforce SSL.

### piwik.session\_save\_handler

Configure whether sessions are stored on disk or within the MySQL database.
The later is required if you want to deploy multiple Piwik servers. This
defaults to `dbtable` as a result.

## Mail Settings

Why are the mail settings intentionally hardcoded to use the local MTA?

There are a number of cron jobs that may be configured by this cookbook.
*You should setup the local MTA* so that these messages will reach you
in the event of failures. This is outside the scope of this cookbook
however and should likely be handled within your base cookbook.

## Testing

Lint and unit tests: `chef exec rake test`

Lint, unit, and integration tests: `chef exec rake test_all`
