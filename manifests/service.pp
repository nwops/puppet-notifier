class notifier::service {
  service { 'puppetserver':
    ensure => present
  }
}
