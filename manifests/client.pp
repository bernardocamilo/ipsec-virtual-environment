case $hostname {
  'alice': {
    $gateway   = '10.1.0.1'
    $right_subnet = '10.2.0.0/16'
  }
  'bob': {
    $gateway   = '10.2.0.1'
    $right_subnet = '10.1.0.0/16'
  }
}

exec { "apt-get update":
  command => "/usr/bin/apt-get update",
}

package { "iperf":
  ensure  => installed,
  require => Exec["apt-get update"],
}

exec { "add route to the right subnet":
  command => "/bin/echo 'up route add -net ${right_subnet} gw ${gateway} dev eth1' >> /etc/network/interfaces",
  unless  => "/sbin/route | grep ${gateway}",
  notify  => Exec["restart eth1"],
}

exec { "restart eth1":
  command     => "/sbin/ifdown eth1 && /sbin/ifup eth1",
  refreshonly => true,
}

