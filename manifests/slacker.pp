class notifier::slacker (
  $hook_url,
  $username,
  $icon_url,
  $channel,
  Enum['user', 'agent'] $puppet_conf_section = 'user',
  $puppetboard = $::notifier::params::puppetboard,
) inherits notifier::params {
  validate_re($hook_url, 'https:\/\/hooks.slack.com\/(services\/)?T.+\/B.+\/.+', 'The webhook URL is invalid')
  validate_re($channel, '#.+', 'The channel should start with a hash sign')

  ini_subsetting { 'add_slacker_to_reports':
    ensure               => present,
    path                 => "${settings::confdir}/puppet.conf",
    section              => $puppet_conf_section,
    setting              => 'reports',
    subsetting           => 'slacker',
    subsetting_separator => ','
  }

  file { "${settings::confdir}/slacker.yaml":
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('notifier/slacker.yaml.erb')
  }
  include notifier, notifier::service
  Class['notifier'] -> Class['notifier::slacker'] ~> Class['notifier::service']
}
