set ns [new Simulator]
set nt [open 6.tr w]
$ns trace-all $nt
set na [open 6.nam w]
$ns namtrace-all $na
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
$ns duplex-link $n0 $n2 10Mb 1ms DropTail
$ns duplex-link $n2 $n3 10Mb 1ms DropTail
$ns duplex-link $n2 $n1 10Mb 1ms DropTail
$ns queue-limit $n0 $n2 10
$ns queue-limit $n1 $n2 10
set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n3 $sink
set ftp [new Application/FTP]
$ftp attach-agent $tcp
set udp [new Agent/UDP]
$ns attach-agent $n1 $udp
set null [new Agent/Null]
$ns attach-agent $n3 $null
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$ns connect $tcp $sink
$ns connect $udp $null
proc finish {} {
global ns nt na$ns flush-trace
close $nt
close $na
exec nam 6.nam &
exit 0
}
$ns at 0.0 "$ftp start"
$ns at 0.2 "$cbr start"
$ns at 0.8 "finish"
$ns run



AWK file:
BEGIN{
d=0;
tcp=0;
udp=0;
pkt_t=0;
time_t=0;
pkt_u=0;
time_u=0;
}
{
if(($1=="r" && $3=="0" && $4=="2" && $5=="tcp")||($1=="r" && $3=="2" && $4=="3" &&
$5=="tcp")){
pkt_t=pkt_t+$6;
time_t=$2;
#printf("%f\t%f\n",pkt_t,time_t);
}
if(($1=="r" && $3=="1" && $4=="2" && $5=="cbr")||($1=="r" && $3=="2" && $4=="3" &&
$5=="cbr")){pkt_u=pkt_u+$6;
time_u=$2;
#printf("%f\t%f\n",pkt_u,time_u);
}
}
END{
printf("Throughput of TCP: %f Mbps\n",((pkt_t/time_t)*(8/1000000)));
printf("Throughput of UDP: %f Mbps\n",((pkt_u/time_u)*(8/1000000)));
}


