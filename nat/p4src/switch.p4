// example5: NAT

/* Definitions */

#define ETHERTYPE_BF_FABRIC    0x9000
#define ETHERTYPE_VLAN         0x8100
#define ETHERTYPE_QINQ         0x9100
#define ETHERTYPE_MPLS         0x8847
#define ETHERTYPE_IPV4         0x0800
#define ETHERTYPE_IPV6         0x86dd
#define ETHERTYPE_ARP          0x0806
#define ETHERTYPE_RARP         0x8035
#define ETHERTYPE_NSH          0x894f
#define ETHERTYPE_ETHERNET     0x6558
#define ETHERTYPE_ROCE         0x8915
#define ETHERTYPE_FCOE         0x8906
#define ETHERTYPE_TRILL        0x22f3
#define ETHERTYPE_VNTAG        0x8926
#define ETHERTYPE_LLDP         0x88cc
#define ETHERTYPE_LACP         0x8809

#define IP_PROTOCOLS_ICMP              1
#define IP_PROTOCOLS_IGMP              2
#define IP_PROTOCOLS_IPV4              4
#define IP_PROTOCOLS_TCP               6
#define IP_PROTOCOLS_UDP               17
#define IP_PROTOCOLS_IPV6              41
#define IP_PROTOCOLS_GRE               47
#define IP_PROTOCOLS_IPSEC_ESP         50
#define IP_PROTOCOLS_IPSEC_AH          51
#define IP_PROTOCOLS_ICMPV6            58
#define IP_PROTOCOLS_EIGRP             88
#define IP_PROTOCOLS_OSPF              89
#define IP_PROTOCOLS_PIM               103
#define IP_PROTOCOLS_VRRP              112

#define IP_PROTOCOLS_IPHL_ICMP         0x501
#define IP_PROTOCOLS_IPHL_IPV4         0x504
#define IP_PROTOCOLS_IPHL_TCP          0x506
#define IP_PROTOCOLS_IPHL_UDP          0x511
#define IP_PROTOCOLS_IPHL_IPV6         0x529
#define IP_PROTOCOLS_IPHL_GRE 		   0x52f

#define UDP_PORT_BOOTPS                67
#define UDP_PORT_BOOTPC                68
#define UDP_PORT_RIP                   520
#define UDP_PORT_RIPNG                 521
#define UDP_PORT_DHCPV6_CLIENT         546
#define UDP_PORT_DHCPV6_SERVER         547
#define UDP_PORT_HSRP                  1985
#define UDP_PORT_BFD                   3785
#define UDP_PORT_LISP                  4341
#define UDP_PORT_VXLAN                 4789
#define UDP_PORT_VXLAN_GPE             4790
#define UDP_PORT_ROCE_V2               4791
#define UDP_PORT_GENV                  6081
#define UDP_PORT_SFLOW 				   6343

/* metadata */

header_type l3_addr_t {
    fields {
        addr : 32;    
    }
}

metadata l3_addr_t l3_addr;

/* header */

header_type ethernet_t {
    fields {
        dstAddr : 48;
        srcAddr : 48;
        etherType : 16;
    }
}

header_type ipv4_t {
    fields {
        version : 4;
        ihl : 4;
        diffserv : 8;
        totalLen : 16;
        identification : 16;
        flags : 3;
        fragOffset : 13;
        ttl : 8;
        protocol : 8;
        hdrChecksum : 16;
        srcAddr : 32;
        dstAddr: 32;
    }
}

header_type icmp_t {
    fields {
        typeCode : 16;
        hdrChecksum : 16;
    }
}

header_type tcp_t {
    fields {
        srcPort : 16;
        dstPort : 16;
        seqNo : 32;
        ackNo : 32;
        dataOffset : 4;
        res : 4;
        flags : 8;
        window : 16;
        checksum : 16;
        urgentPtr : 16;
    }
}

header_type udp_t {
    fields {
        srcPort : 16;
        dstPort : 16;
        length_ : 16;
        checksum : 16;
    }
}

/* parser */

parser start {
    return parse_ethernet;
}

header ethernet_t ethernet;

parser parse_ethernet {
    extract(ethernet);
    return select(latest.etherType) {
        ETHERTYPE_IPV4 : parse_ipv4;
        default: ingress;
    }
}

header ipv4_t ipv4;

parser parse_ipv4 {
    extract(ipv4);
    return select(latest.fragOffset, latest.ihl, latest.protocol) {
        IP_PROTOCOLS_IPHL_ICMP : parse_icmp;
        IP_PROTOCOLS_IPHL_TCP : parse_tcp;
        IP_PROTOCOLS_IPHL_UDP : parse_udp;
        default: ingress;
    }
}

header icmp_t icmp;

parser parse_icmp {
    extract(icmp);
    return select(latest.typeCode) { 
        default: ingress;
    }
} 

header tcp_t tcp;

parser parse_tcp {
    extract(tcp);
    return select(latest.dstPort) { 
        default: ingress;
    }
}

header udp_t udp;

parser parse_udp {
    extract(udp);
    return select(latest.dstPort) { 
        default: ingress;
    }
}

/* actions */

action _drop() {
	drop();
}

action _nop() {
}

action doNATOperations(etherAddr, ipAddr, fwdPort) {
    // change the source MAC address 
    modify_field(ethernet.srcAddr, etherAddr);
    // modify the source IP address, 
    // that means keep the same address
    modify_field(l3_addr.addr, ipv4.srcAddr);
    modify_field(ipv4.srcAddr, ipAddr);
    modify_field(ipv4.srcAddr, l3_addr.addr);
    // forwarding
    modify_field(standard_metadata.egress_spec, fwdPort);
}

/* tables */

// PrivateToPublicTranslation
table nat {
	reads { 
		ethernet.srcAddr : exact;
		ethernet.dstAddr : exact;
        	ipv4.srcAddr : lpm;
		ipv4.dstAddr : exact;
	}
	actions {
		_nop; doNATOperations; _drop;
	}	
}

/* control flows */

control ingress {
	apply(nat);
}

control egress {
}
