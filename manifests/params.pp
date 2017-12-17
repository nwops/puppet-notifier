# Class: report_hipchat::params
#
# Notifier Parameters
#
class notifier::params {
  $puppetboard            = undef
  $puppetconf_path        = '/etc/puppetlabs/puppet'
  $slack_icon_url         = undef
  $slack_username         = 'Puppet'
  $telegram_send_stickers = undef
}
