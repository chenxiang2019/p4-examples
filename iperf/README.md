## Iperf Tests

Follow the example to use iperf to test bmv2 performance.

Example(we assume that your directory are `p4-examples/iperf`): 

```
$ cd example_dir/
$ ./run_14_demo.sh

mininet> xterm h1 h2

// in the console of h2, start server
h2> cd ../iperf/
h2> ./server.sh

// in the console of h1, generate 1Gbps traffic
h1> cd ../iperf/
h1> ./client.sh
```
