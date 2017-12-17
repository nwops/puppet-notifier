class notifier {
  package { 'mime-types':
    ensure   => '2.6.2',
    provider => 'puppetserver_gem'
  }
  package { 'rest-client':
    ensure   => '1.8.0',
    provider => 'puppetserver_gem',
    require  => Package['mime-types']
  }
  package { 'telegram-bot-ruby':
    ensure   => '0.8.6.1',
    provider => 'puppetserver_gem'
  }
  package { 'slack-notifier':
    ensure   => '1.5.1',
    provider => 'puppetserver_gem'
  }

  ini_setting { 'enable_reports':
    ensure  => present,
    section => 'agent',
    setting => 'report',
    value   => true,
    path    => "${settings::confdir}/puppet.conf",
  }
}
