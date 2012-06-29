class torquebox::install {

  package { ["openjdk-6-jdk", "unzip"]:
    ensure => present,
  }

  file { ["/root/src", "/opt", "/opt/torquebox"]:
    ensure => directory,
  }

  group { "torquebox":
    ensure => present,
  }

  user { "torquebox": 
    ensure => present,
    gid => "torquebox",
    comment => "This user created by puppet.",
    require => Group["torquebox"],
  }

  exec { "build-torquebox":
    cwd => "/root/src",
    command => "/usr/bin/wget -N http://torquebox.org/release/org/torquebox/torquebox-dist/2.0.3/torquebox-dist-2.0.3-bin.zip &&
                /usr/bin/unzip torquebox-dist-2.0.3-bin.zip && 
                /bin/mv torquebox-2.0.3 /opt/torquebox/2.0.3 &&
                /bin/ln -s /opt/torquebox/2.0.3 /opt/torquebox/current &&
                /bin/chown -R torquebox:torquebox /opt/torquebox",
    creates => "/opt/torquebox/current/jboss/bin/standalone.sh",
    logoutput => on_failure,
    timeout => 0,
    require => [Package["openjdk-6-jdk"], Package["unzip"], File["/root/src"]],
  }

  file { "/etc/init/torquebox.conf":
    ensure => present,
    source => "puppet:///modules/torquebox/torquebox.conf",
    owner => "root",
    group => "root",
    mode => 644,
    require => Exec["build-torquebox"],
  }

  file { "/etc/init.d/torquebox":
    ensure => link,
    target => "/lib/init/upstart-job",
    require => File["/etc/init/torquebox.conf"]
  }

}
