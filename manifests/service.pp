class torquebox::service {
	
  service { "torquebox":
    ensure => running,
    hasstatus => true,
    hasrestart => false,
    require => Class["torquebox::config"],
  }

}