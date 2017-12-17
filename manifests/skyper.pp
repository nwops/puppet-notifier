class notifier::skyper (
  $chat_id,
  $client_id,
  $client_secret,
  $puppetboard = $::notifier::params::puppetboard,
) inherits notifier::params {

  ini_subsetting { 'slack_report_handler':
    ensure               => present,
    path                 => "${settings::confdir}/puppet.conf",
    section              => 'master',
    setting              => 'reports',
    subsetting           => 'slack',
    subsetting_separator => ',',
    require              => Ini_setting['enable_reports'],
  }

  file { "${settings::confdir}/skyper.yaml":
    ensure  => present,
    owner   => 'pe-puppet',
    group   => 'pe-puppet',
    mode    => '0644',
    content => template('notifier/slacker.yaml.erb'),
  }
  include notifier::service
  Class['notifier::skyper'] ~> Class['notifier::service']
}
