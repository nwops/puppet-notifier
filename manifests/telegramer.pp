class notifier::telegramer (
  $token,
  $chat_id,
  $puppetboard            = $::notifier::params::puppetboard,
  $send_stickers = $::notifier::params::telegram_send_stickers
) inherits notifier::params {

  ini_subsetting { 'add_telegramer_to_reports':
    ensure               => present,
    path                 => "${settings::confdir}/puppet.conf",
    section              => 'master',
    setting              => 'reports',
    subsetting           => 'telegramer',
    subsetting_separator => ',',
    require              => Ini_setting['enable_reports'],
  }

  file { "${settings::confdir}/telegramer.yaml":
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('notifier/telegramer.yaml.erb')
  }
  include notifier::service
  Class['notifier::telegramer'] ~> Class['notifier::service']
}
