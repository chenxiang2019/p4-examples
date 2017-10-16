# p4-examples

## Installation

(1)BMv2(enabling high performance):

```
$ git clone https://github.com/p4lang/behavioral-model.git
$ mv behavioral-model bmv2
$ cd bmv2
$ ./install_deps.sh
$ ./autogen.sh
$ ./configure --disable-logging-macros --disable-elogger
$ make 
$ make install
```

(2)p4c-bm:

```
$ sudo apt-get install python-pip
$ git clone https://github.com/p4lang/p4c-bm.git
$ cd p4c-bm
$ sudo pip install -r requirements.txt
$ sudo pip install -r requirements_v1_1.txt
$ sudo python setup.py install
```

## Examples

- skeleton/bridge: port forwarding for measuring performance baseline;
- l2fwd: dst MAC address forwarding;
- l3fwd: dst IP address forwarding, with lpm match;
- Firewall: 5-tuple Firewall;
- NAT: private to public address translation.

## Questions

Mail: wasdnsxchen@gmail.com
