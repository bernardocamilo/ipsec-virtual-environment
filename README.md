# IPsec Virtual Environment

A virtual environment created with Vagrant for playing with IPsec.

## Requirements

 * [VirtualBox](https://www.virtualbox.org/)
 * [Vagrant](https://www.vagrantup.com/)

## Description

This scenario is based on a [strongSwan configuration example](http://www.strongswan.org/uml/testresults/ikev2/net2net-psk/).

### Gateways:
 * moon.gateway
 * sun.gateway

### Clients:
 * alice.client
 * bob.client

## Useful commands

Bring up all the machines:

```
vagrant up
```

SSH to a machine:

```
vagrant ssh [hostname]
```

Establish an IPsec connection between the clients:

  1. SSH to a gateway machine:

  ```
  vagrant ssh moon.gateway
  vagrant ssh sun.gateway
  ```

  2. Bring up the configured IPsec connection net-net:

  ```
  sudo ipsec up net-net
  ```

* More IPsec commands:

  ```
  sudo ipsec down net-net # bring down the IPsec connection
  sudo ipsec statusall    # IPsec detailed status
  ```

Destroy the machines after testing:

```
vagrant destroy
```

Other [configuration examples](https://wiki.strongswan.org/projects/strongswan/wiki/ConfigurationExamples).
