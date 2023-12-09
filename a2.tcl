set ns [new Simulator]
set na [open a2.nam w]
$ns namtrace-all-wireless $na 700 700
set nt [open a2.tr w]
$ns trace-all $nt

set topo [new Topography]
$topo load_flatgrid 700 700
$ns node-config -adhocRouting DSR
$ns node-config -llType LL
$ns node-config -macType Mac/802_11
$ns node-config -ifqType Queue/DropTail
$ns node-config -ifqLen 50
$ns node-config -phyType Phy/WirelessPhy
$ns node-config -channelType Channel/WirelessChannel
$ns node-config -propType Propagation/TwoRayGround
$ns node-config -antType Antenna/OmniAntenna
$ns node-config -topoInstance $topo
$ns node-config -agentTrace ON
$ns node-config -routerTrace ON
create-god 6

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$n0 set X_ 150.0
$n0 set Y_ 300.0
$n0 set Z_ 0.0
$n1 set X_ 300.0
$n1 set Y_ 500.0
$n1 set Z_ 0.0
$n2 set X_ 500.0
$n2 set Y_ 500.0
$n2 set Z_ 0.0
$n3 set X_ 300.0
$n3 set Y_ 100.0
$n3 set Z_ 0.0
$n4 set X_ 500.0
$n4 set Y_ 100.0
$n4 set Z_ 0.0
$n5 set X_ 650.0
$n5 set Y_ 300.0
$n5 set Z_ 0.0

$ns at 2.0 "$n3 setdest 301.0 500.0 5.0"

set tcp1 [new Agent/TCP]
$ns attach-agent $n0 $tcp1

set sink1 [new Agent/TCPSink]
$ns attach-agent $n5 $sink1

set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $tcp1

$ns connect $tcp1 $sink1

proc End {} {
global ns na nt
$ns flush-trace
close $na
close $nt
exec nam a2.nam &
}

$ns at 1.0 "$cbr1 start"
$ns at 10.0 "End"
$ns run
