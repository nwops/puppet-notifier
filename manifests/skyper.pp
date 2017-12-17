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
    subsetting           => 'skyper',
    subsetting_separator => ','
  }

  file { "${settings::confdir}/skyper.yaml":
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('notifier/skyper.yaml.erb'),
  }
  include notifier, notifier::service
  Class['notifier'] -> Class['notifier::skyper'] ~> Class['notifier::service']
}
