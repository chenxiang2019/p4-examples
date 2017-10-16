# MoonGen Tests

For testing these examples with MoonGen, you should first buy 2x10G NICs that supported by DPDK. Then take the following steps:

- 1.Modify the switch ports of `rule/*.txt` based on the `ifconfig` output.
- 2.Connect the traffic generator which runs MoonGen and target machine which runs bmv2. Make sure all the ports are correctly placed.
- 3.Run the switch on the target machine. Populate the tables with rules.
- 4.Generate traffic by using MoonGen scripts.

All the examples here could be tested by [p4sc-test.lua](https://github.com/Wasdns/packet-configurations/blob/master/moongen/p4sc-test.lua).
Feel free to modify this script on your demand.
