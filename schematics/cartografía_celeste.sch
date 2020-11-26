EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title "Cartografía celeste"
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L MCU_Microchip_ATtiny:ATtiny25V-10PU U1
U 1 1 5F8C6697
P 2500 6000
F 0 "U1" H 1970 6046 50  0000 R CNN
F 1 "ATtiny25V-10PU" H 1970 5955 50  0000 R CNN
F 2 "Package_DIP:DIP-8_W7.62mm" H 2500 6000 50  0001 C CIN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/atmel-2586-avr-8-bit-microcontroller-attiny25-attiny45-attiny85_datasheet.pdf" H 2500 6000 50  0001 C CNN
	1    2500 6000
	1    0    0    -1  
$EndComp
NoConn ~ 3100 6100
NoConn ~ 3100 6200
$Comp
L power:GND #PWR07
U 1 1 5F8E5993
P 2500 6800
F 0 "#PWR07" H 2500 6550 50  0001 C CNN
F 1 "GND" H 2505 6627 50  0000 C CNN
F 2 "" H 2500 6800 50  0001 C CNN
F 3 "" H 2500 6800 50  0001 C CNN
	1    2500 6800
	1    0    0    -1  
$EndComp
Wire Wire Line
	5100 4350 5250 4350
Wire Wire Line
	5700 4350 5850 4350
Connection ~ 5700 4350
Connection ~ 5100 4350
Wire Wire Line
	6150 4350 6300 4350
Wire Wire Line
	5550 4350 5700 4350
Wire Wire Line
	5000 4350 5100 4350
Wire Wire Line
	4700 4350 4500 4350
$Comp
L Device:LED D3
U 1 1 5F8F28DB
P 6000 4350
F 0 "D3" H 5993 4567 50  0000 C CNN
F 1 "LED" H 5993 4476 50  0000 C CNN
F 2 "" H 6000 4350 50  0001 C CNN
F 3 "~" H 6000 4350 50  0001 C CNN
	1    6000 4350
	1    0    0    -1  
$EndComp
$Comp
L Device:LED D2
U 1 1 5F8F2052
P 5400 4350
F 0 "D2" H 5393 4567 50  0000 C CNN
F 1 "LED" H 5393 4476 50  0000 C CNN
F 2 "" H 5400 4350 50  0001 C CNN
F 3 "~" H 5400 4350 50  0001 C CNN
	1    5400 4350
	1    0    0    -1  
$EndComp
$Comp
L Device:LED D1
U 1 1 5F8F18E6
P 4850 4350
F 0 "D1" H 4843 4567 50  0000 C CNN
F 1 "LED" H 4843 4476 50  0000 C CNN
F 2 "" H 4850 4350 50  0001 C CNN
F 3 "~" H 4850 4350 50  0001 C CNN
	1    4850 4350
	1    0    0    -1  
$EndComp
$Comp
L Device:LED D6
U 1 1 5F8FB85B
P 6000 4000
F 0 "D6" H 5993 3745 50  0000 C CNN
F 1 "LED" H 5993 3836 50  0000 C CNN
F 2 "" H 6000 4000 50  0001 C CNN
F 3 "~" H 6000 4000 50  0001 C CNN
	1    6000 4000
	-1   0    0    1   
$EndComp
$Comp
L Device:LED D5
U 1 1 5F8FDE66
P 5400 4000
F 0 "D5" H 5393 3745 50  0000 C CNN
F 1 "LED" H 5393 3836 50  0000 C CNN
F 2 "" H 5400 4000 50  0001 C CNN
F 3 "~" H 5400 4000 50  0001 C CNN
	1    5400 4000
	-1   0    0    1   
$EndComp
$Comp
L Device:LED D4
U 1 1 5F8FE5B2
P 4800 4000
F 0 "D4" H 4793 3745 50  0000 C CNN
F 1 "LED" H 4793 3836 50  0000 C CNN
F 2 "" H 4800 4000 50  0001 C CNN
F 3 "~" H 4800 4000 50  0001 C CNN
	1    4800 4000
	-1   0    0    1   
$EndComp
Wire Wire Line
	4500 4350 4500 4000
Wire Wire Line
	4500 4000 4650 4000
Connection ~ 4500 4350
Wire Wire Line
	4950 4000 5100 4000
Wire Wire Line
	5550 4000 5700 4000
Wire Wire Line
	6150 4000 6300 4000
Wire Wire Line
	6300 4000 6300 4350
Connection ~ 6300 4350
Wire Wire Line
	5100 4350 5100 4000
Connection ~ 5100 4000
Wire Wire Line
	5100 4000 5250 4000
Wire Wire Line
	5700 4000 5700 4350
Connection ~ 5700 4000
Wire Wire Line
	5700 4000 5850 4000
$Comp
L Device:LED D8
U 1 1 5F907917
P 4800 3600
F 0 "D8" H 4793 3817 50  0000 C CNN
F 1 "LED" H 4793 3726 50  0000 C CNN
F 2 "" H 4800 3600 50  0001 C CNN
F 3 "~" H 4800 3600 50  0001 C CNN
	1    4800 3600
	1    0    0    -1  
$EndComp
$Comp
L Device:LED D7
U 1 1 5F909830
P 4800 3250
F 0 "D7" H 4793 2995 50  0000 C CNN
F 1 "LED" H 4793 3086 50  0000 C CNN
F 2 "" H 4800 3250 50  0001 C CNN
F 3 "~" H 4800 3250 50  0001 C CNN
	1    4800 3250
	-1   0    0    1   
$EndComp
$Comp
L Device:LED D12
U 1 1 5F90A064
P 6000 2900
F 0 "D12" H 5993 3117 50  0000 C CNN
F 1 "LED" H 5993 3026 50  0000 C CNN
F 2 "" H 6000 2900 50  0001 C CNN
F 3 "~" H 6000 2900 50  0001 C CNN
	1    6000 2900
	1    0    0    -1  
$EndComp
$Comp
L Device:LED D11
U 1 1 5F90D2DB
P 6000 2550
F 0 "D11" H 5993 2295 50  0000 C CNN
F 1 "LED" H 5993 2386 50  0000 C CNN
F 2 "" H 6000 2550 50  0001 C CNN
F 3 "~" H 6000 2550 50  0001 C CNN
	1    6000 2550
	-1   0    0    1   
$EndComp
$Comp
L Device:LED D9
U 1 1 5F916E5B
P 5400 1800
F 0 "D9" H 5393 1545 50  0000 C CNN
F 1 "LED" H 5393 1636 50  0000 C CNN
F 2 "" H 5400 1800 50  0001 C CNN
F 3 "~" H 5400 1800 50  0001 C CNN
	1    5400 1800
	-1   0    0    1   
$EndComp
$Comp
L Device:LED D10
U 1 1 5F917C73
P 5400 2150
F 0 "D10" H 5393 2367 50  0000 C CNN
F 1 "LED" H 5393 2276 50  0000 C CNN
F 2 "" H 5400 2150 50  0001 C CNN
F 3 "~" H 5400 2150 50  0001 C CNN
	1    5400 2150
	1    0    0    -1  
$EndComp
Wire Wire Line
	4500 4000 4500 3600
Wire Wire Line
	4500 3600 4650 3600
Connection ~ 4500 4000
Wire Wire Line
	4950 3600 5700 3600
Wire Wire Line
	5700 3600 5700 4000
Wire Wire Line
	4500 3600 4500 3250
Wire Wire Line
	4500 3250 4650 3250
Connection ~ 4500 3600
Wire Wire Line
	4950 3250 5700 3250
Wire Wire Line
	5700 3250 5700 3600
Connection ~ 5700 3600
Wire Wire Line
	5100 4000 5100 2900
Wire Wire Line
	5100 2900 5850 2900
Wire Wire Line
	6150 2900 6300 2900
Wire Wire Line
	6300 2900 6300 4000
Connection ~ 6300 4000
Wire Wire Line
	5100 2900 5100 2550
Wire Wire Line
	5100 2550 5850 2550
Connection ~ 5100 2900
Wire Wire Line
	6150 2550 6300 2550
Wire Wire Line
	6300 2550 6300 2900
Connection ~ 6300 2900
Connection ~ 4500 3250
Connection ~ 6300 2550
Wire Wire Line
	6300 1800 5550 1800
Wire Wire Line
	5250 1800 4500 1800
Wire Wire Line
	4500 1800 4500 2150
Wire Wire Line
	6300 1800 6300 2150
Wire Wire Line
	5250 2150 4500 2150
Connection ~ 4500 2150
Wire Wire Line
	4500 2150 4500 3250
Wire Wire Line
	5550 2150 6300 2150
Connection ~ 6300 2150
Wire Wire Line
	6300 2150 6300 2550
$Comp
L power:+3V0 #PWR0103
U 1 1 5F9453F1
P 2500 5250
F 0 "#PWR0103" H 2500 5100 50  0001 C CNN
F 1 "+3V0" H 2515 5423 50  0000 C CNN
F 2 "" H 2500 5250 50  0001 C CNN
F 3 "" H 2500 5250 50  0001 C CNN
	1    2500 5250
	1    0    0    -1  
$EndComp
Wire Wire Line
	2500 5400 2500 5250
Wire Wire Line
	2500 6800 2500 6600
Wire Wire Line
	5100 4350 5100 5800
Wire Wire Line
	6300 4350 6300 6000
Wire Wire Line
	5700 4350 5700 5900
Wire Wire Line
	4500 4350 4500 5700
Wire Wire Line
	3100 5700 4500 5700
Wire Wire Line
	3100 5800 5100 5800
Wire Wire Line
	3100 5900 5700 5900
Wire Wire Line
	3100 6000 6300 6000
$EndSCHEMATC
