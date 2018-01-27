class notifier(
  Enum['puppetserver_gem', 'puppet_gem'] $gem_provider = 'puppetserver_gem',

  ) {
  package { 'mime-types':
    ensure   => '2.6.2',
    provider => $gem_provider
  }
  package { 'rest-client':
    ensure   => '1.8.0',
    provider => $gem_provider,
    require  => Package['mime-types']
  }
  package { 'telegram-bot-ruby':
    ensure   => '0.8.6.1',
    provider => $gem_provider
  }
  package { 'slack-notifier':
    ensure   => '2.3.2',
    provider => $gem_provider
  }

  ini_setting { 'enable_reports':
    ensure  => present,
    section => 'main',
    setting => 'report',
    value   => true,
    path    => "${settings::confdir}/puppet.conf",
  }
}
