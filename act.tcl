# Create a simulator object
set ns [new Simulator]
set nt [open act.tr w]
$ns trace-all $nt
set na [open act.nam w]
$ns namtrace-all $na

# Set up nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]

# Set up links with bandwidth, delay, and queue type
$ns duplex-link $n0 $n2 4Mb 1ms DropTail
$ns duplex-link $n1 $n2 4Mb 1ms DropTail
$ns duplex-link $n2 $n3 4Mb 1ms DropTail
$ns duplex-link $n3 $n4 4Mb 1ms DropTail
$ns duplex-link $n4 $n6 4Mb 1ms DropTail
$ns duplex-link $n3 $n5 4Mb 1ms DropTail
$ns duplex-link $n5 $n7 4Mb 1ms DropTail



# Create TCP agent and attach to node 0
set tcp [new Agent/TCP]
$tcp set packetSize_ 1460
$ns attach-agent $n0 $tcp
set sink_tcp [new Agent/TCPSink]
$ns attach-agent $n6 $sink_tcp


# Create UDP agent and attach to node 1
set udp [new Agent/UDP]
$udp set packetSize_ 1500
$ns attach-agent $n1 $udp
set sink_udp [new Agent/Null]
$ns attach-agent $n7 $sink_udp

$ns connect $tcp $sink_tcp
$ns connect $udp $sink_udp

# Create CBR traffic and attach to node 4
set cbr [new Application/Traffic/CBR]
$cbr set packetSize_ 1500
$cbr set rate_ 0.5Mb
$cbr attach-agent $tcp

set cbr2 [new Application/Traffic/CBR]
$cbr2 set packetSize_ 1500
$cbr2 set rate_ 0.5Mb
$cbr2 attach-agent $udp



# Schedule events
$ns at 0.1 "$cbr start"
$ns at 0.2 "$cbr2 start"


# Define finish procedure
proc finish {} {
    global ns nt na
    $ns flush-trace
    close $nt
    close $na
    exec nam act.nam &
    exit 0
}

# Run the simulation
$ns at 5.0 "finish"
$ns run

