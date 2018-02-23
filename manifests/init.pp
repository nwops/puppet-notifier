class notifier(
  Enum['user', 'agent'] $puppet_conf_section = 'user',
  Enum['puppetserver_gem', 'puppet_gem', 'gem'] $gem_provider = 'puppetserver_gem',

  ) {
  package { 'mime-types':
    ensure   => '2.6.2',
    provider => $gem_provider
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
    section => $puppet_conf_section,
    setting => 'report',
    value   => true,
    path    => "${settings::confdir}/puppet.conf",
  }
}
