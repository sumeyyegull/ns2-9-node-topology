set ns [new Simulator]

#İzleme dosyaları
set tracefile [open trace.tr w]
$ns trace-all $tracefile

set namfile [open out.nam w]
$ns namtrace-all $namfile

#Topoloji
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]
set n8 [$ns node]

#Düğümleri bağla
$ns duplex-link $n0 $n1 1Mb 10ms DropTail
$ns duplex-link $n1 $n2 1Mb 10ms DropTail
$ns duplex-link $n2 $n3 1Mb 10ms DropTail
$ns duplex-link $n3 $n4 1Mb 10ms DropTail
$ns duplex-link $n4 $n5 1Mb 10ms DropTail
$ns duplex-link $n5 $n6 1Mb 10ms DropTail
$ns duplex-link $n6 $n7 1Mb 10ms DropTail
$ns duplex-link $n7 $n8 1Mb 10ms DropTail

#UDP/CBR Trafiği
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0
$udp0 set class_ 1
set null0 [new Agent/Null]
$ns attach-agent $n8 $null0
$ns connect $udp0 $null0
$ns color 1 Blue

set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 512
$cbr0 set interval_ 0.2
$cbr0 attach-agent $udp0

#TCP/FTP Trafiği
set tcp0 [new Agent/TCP]
$ns attach-agent $n1 $tcp0
$tcp0 set class_ 2
set sink0 [new Agent/TCPSink]
$ns attach-agent $n7 $sink0
$ns connect $tcp0 $sink0
$ns color 2 Yellow

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

#başlatma zamanları
$ns at 1.0 "$cbr0 start"
$ns at 1.5 "$ftp0 start"
$ns at 9.0 "$cbr0 stop"
$ns at 9.5 "$ftp0 stop"

#simülasyon sonu
$ns at 10.0 "finish"
proc finish {} {
   global ns tracefile namfile
   $ns flush-trace
   close $tracefile
   close $namfile
   puts "simülasyon tamamlandı."
   exec nam out.nam &
   exit
}

#simülasyonu başlat
$ns run
