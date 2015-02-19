$left_ip = $ipaddress_eth2
$left_subnet = "${network_eth1}/16"

case $hostname {
  'moon': {
    $left_id      = '@moon.strongswan.org'
    $right_ip     = '192.168.0.2'
    $right_subnet = '10.2.0.0/16'
    $right_id     = '@sun.strongswan.org'
    }
  'sun': {
    $left_id      = '@sun.strongswan.org'
    $right_ip     = '192.168.0.1'
    $right_subnet = '10.1.0.0/16'
    $right_id     = '@moon.strongswan.org'
  }
}

exec { "apt-get update":
  command => "/usr/bin/apt-get update",
}

package { "tcpdump":
  ensure  => installed,
  require => Exec["apt-get update"],
}

package { "strongswan":
  ensure  => installed,
  require => Exec["apt-get update"],
}

package { "strongswan-plugin-gmp":
  ensure  => installed,
  require => Package["strongswan"],
}

service { "strongswan":
  ensure => running,
  enable => true,
  require => Package["strongswan"],
}

augeas { "enable ip forwarding":
  context => "/files/etc/sysctl.conf",
  changes => [
    "set net.ipv4.conf.all.forwarding 1",
    ],
}

exec { "refresh sysctl.conf":
  command => "/sbin/sysctl -p",
  require => Augeas["enable ip forwarding"],
}

file { "ipsec.conf":
  notify  => Service["strongswan"],
  path    => "/etc/ipsec.conf",
  ensure  => present,
  mode    => 0644,
  content => template("/vagrant/templates/ipsec.conf.erb"),
  require => Package["strongswan-plugin-gmp"],
}

file { "strongswan.conf":
  notify  => Service["strongswan"],
  path    => "/etc/strongswan.conf",
  ensure  => present,
  mode    => 0644,
  content => template("/vagrant/templates/strongswan.conf.erb"),
  require => Package["strongswan-plugin-gmp"],
}

file { "ipsec.secrets":
  notify  => Service["strongswan"],
  path    => "/etc/ipsec.secrets",
  ensure  => present,
  mode    => 0600,
  content => template("/vagrant/templates/ipsec.secrets.erb"),
  require => Package["strongswan-plugin-gmp"],
}

exec { "add route to the right subnet":
  command => "/bin/echo 'up route add -net ${right_subnet} gw ${right_ip} dev eth2' >> /etc/network/interfaces",
  unless  => "/sbin/route | grep ${right_ip}",
  notify  => Exec["restart eth2"],
}

exec { "restart eth2":
  command     => "/sbin/ifdown eth2 && /sbin/ifup eth2",
  refreshonly => true,
}

