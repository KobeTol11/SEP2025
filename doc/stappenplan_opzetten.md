# Draaiboek opzetten SEP demo

## Netwerkapparatuur aansluiten en configureren

Zet alle netwerkadapters van de VM's in de bridge mode. Dit zorgt ervoor dat de VM's een eigen IP-adres krijgen en dat ze vanaf de host en andere VM's bereikbaar zijn.

Verbind de routers en de switches met elkaar. En verbind de poorten op de switches met de VM's via het patchpanel. Voorzie ook twee consolekabels om de router en de switch te configureren.

Een overzicht van hoe alle apparaten met elkaar verbonden:

Router g0/0/1 -> Switch g0/0/1

Switch poort 24 -> 10.11

**Servers: Switch poorten 7 - 12**

Laptop Gilles (web) -> 10.7

Laptop mattias (Windows server) -> 10.10

**DMZ: Switch poorten 13 - 18**

Laptop Ruben (reverse proxy) -> 10.9

**Client: Switch poorten 1 - 6**

Laptop Kobe (Windows client) -> 10.8

**Console poorten**

TFTP Server  -> 10.6 

Consolepoort switch -> 10.12

Consolepoort router 1 -> 10.13

consolepoort router 2 -> 10.14


Overzicht van de IP's en VLAN's:

| Device        | VLAN | IP Address     | Gateway       | Subnet Mask     |
| ------------- | ---- | -------------- | ------------- | --------------- |
| DC            | 11   | 192.168.207.49 | 192.168.207.5 | 255.255.255.240 |
| Webserver     | 11   | 192.168.207.50 | 192.168.207.5 | 255.255.255.240 |
| Reverse proxy | 14   | 192.168.207.17 | 192.168.207.5 | 255.255.255.240 |
| TFTP server   | 11   | 192.168.207.51 | 192.168.207.5 | 255.255.255.240 |
| Databank      | 11   | 192.168.207.52 | 192.168.207.5 | 255.255.255.240 |

## Configuratie van de router en de switch

**Zet WiFi uit!!!**

Gilles check deze zaken:
VM in bridged mode
Internetadpater in de juiste range

Om de configuraties van de tftp server en de webserver te kunnen downloaden, moet de router en de switch een IP-adres krijgen. Dit kan door de volgende commando's uit te voeren:

Router:

```cisco
interface GigabitEthernet0/0/1
no shutdown
ip address 192.168.207.53 255.255.255.O
ip tftp source gigabitEthernet 0/0/1
```

Switch:

```cisco
interface Vlan1
no shutdown
ip address 192.168.207.34 255.255.255.0
int fa0/1
switchport mode access
switchport access vlan 1
```

Gebruik dan het volgende commando om de configuratie van de router te downloaden:

```cisco
copy tftp://192.168.207.35/R2_startup-config.txt running-config
reload
```

En het volgende commando om de configuratie van de switch te downloaden:

```cisco
copy tftp://192.168.207.35/Config-S1.txt running-config
reload
```

Volgende commando maakt een backup van de running config

```cisco
copy running-config tftp://192.168.207.35/router-backup-24-4.cfg
reload
```

## Configuratie van de servers

Start nu alle servers op en zorg dat ze de juiste IP-adressen hebben. Zet de vm's in de bridged mode.

## Opzetten van de raspberry pi

Het script kopieren naar de raspberry pi kan je doen met het volgende commando:

```bash
scp setup-tftp.sh pi@<raspberry-pi-ip>:/home/pi/
```

Checken of de tftp server draait kan je doen met het volgende commando:

```bash
sudo systemctl status tftpd-hpa
```

Het IP adres van de raspberry kan worden aangepast met het volgende commando:

```bash
pi@raspberrypi:/var/lib/tftpboot $ nmcli connection show
NAME                UUID                                  TYPE      DEVICE 
Wired connection 1  eee2851a-1b8f-3404-b93a-63b37971568c  ethernet  eth0
lo                  8f4908b1-ae9b-437a-9754-aa9f1f45bb41  loopback  lo
```

```bash	
sudo nmcli con modify "Wired connection 1" ipv4.addresses 192.168.207.35/29
sudo nmcli con modify "Wired connection 1" ipv4.gateway 192.168.207.33
sudo nmcli con modify "Wired connection 1" ipv4.dns "192.168.207.32 8.8.8.8"
sudo nmcli con modify "Wired connection 1" ipv4.method manual
```

```bash
sudo nmcli con down "Wired connection 1" && nmcli con up "Wired connection 1"
```

De volledige configuratie controleren:

```bash
ip a show eth0
ip route
```

Windows defender firewall uitschakelen op pc

tftp -i 192.168.207.35 PUT Config-R1.txt
