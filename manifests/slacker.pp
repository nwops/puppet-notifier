class notifier::slacker (
  $hook_url,
  $username,
  $icon_user,
  $channel,
  $puppetboard = $::notifier::params::puppetboard,
) inherits notifier::params {
  validate_re($hook_url, 'https:\/\/hooks.slack.com\/(services\/)?T.+\/B.+\/.+', 'The webhook URL is invalid')
  validate_re($channel, '#.+', 'The channel should start with a hash sign')

  ini_subsetting { 'add_slacker_to_reports':
    ensure               => present,
    path                 => "${settings::confdir}/puppet.conf",
    section              => 'master',
    setting              => 'reports',
    subsetting           => 'slacker',
    subsetting_separator => ',',
    require              => Ini_setting['enable_reports'],
  }

  file { "${settings::confdir}/slacker.yaml":
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('notifier/slacker.yaml.erb')
  }
  include notifier::service
  Class['notifier::slacker'] ~> Class['notifier::service']
}