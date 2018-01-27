class notifier::service( Boolean $masterless = true ) {
  unless $masterless {
    service { 'puppetserver':
      ensure => running
    }
  }

}
