class torquebox::config {  

  file { "/etc/profile.d/torquebox.sh":
    ensure => present,
    source => "puppet:///modules/torquebox/torquebox.sh",
    owner => "root",
    group => "root",
    mode => 644,
    require => Class["torquebox::install"],
    notify => Class["torquebox::service"],
  }

}