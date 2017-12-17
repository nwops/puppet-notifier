class notifier::service {
  service { 'puppetserver':
    ensure => running
  }
}
