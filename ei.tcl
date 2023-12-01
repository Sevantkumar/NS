set ns [new Simulator]

set tracefile [open 81.tr w]
$ns trace-all $tracefile

set namfile [open 8.nam w]
$ns namtrace-all $namfile

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]
$n0 color "red"
$n1 color "red"
$n2 color "red"
$n3 color "red"
$n4 color "magenta"
$n5 color "magenta"
$n6 color "magenta"
$n7 color "magenta"
$ns make-lan "$n0 $n1 $n2 $n3" 100Mb 300ms LL Queue/DropTail Mac/802_3
$ns make-lan "$n4 $n5 $n6 $n7" 100Mb 300ms LL Queue/DropTail Mac/802_3
$ns duplex-link $n3 $n4 100.0Mb 10ms DropTail
$ns duplex-link-op $n3 $n4 color "green"
$ns queue-limit $n3 $n4 50
set err [new ErrorModel]
$ns lossmodel $err $n3 $n4$err set rate_ 0.1
#$ns duplex-link-op $n3 $n4 orient left-down
set udp0 [new Agent/UDP]
$ns attach-agent $n1 $udp0
set null1 [new Agent/Null]
$ns attach-agent $n7 $null1
$ns connect $udp0 $null1
$udp0 set packetSize_ 1500
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0
$cbr0 set packetSize_ 1000
$cbr0 set rate_ 1.0Mb
$cbr0 set random_ null
proc finish {} {
global ns tracefile namfile
$ns flush-trace
close $tracefile
close $namfile
exec nam 8.nam &
exit 0
}$ns at 1.0 "$cbr0 start"
$ns at 3.0 "finish"
$ns run





AWK file:
BEGIN{
pkt=0;
time=0;
}
{
if($1=="r" && $3=="9" && $4=="7"){
pkt+=$6;
time=$2;
}
}
END{
printf("Throughput = %fMbps\n",((pkt/time)*(8/1000000)));
}
