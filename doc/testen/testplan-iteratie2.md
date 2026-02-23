
# Testplan: Basisnetwerk – Iteratie 2

- **Auteur(s) testplan**: Tollenaere Kobe

## Netwerkconfiguratie (Iteratie 2)

- Groepsnummer: **X**
- NAT IP (statisch): `172.22.200.7/16`
  - Default Gateway: `172.22.255.254`
  - DNS Server: `172.22.128.1`
- Het `.252/30` subnet tussen jouw router en de ISP-router uit iteratie 1 verdwijnt in deze set-up.

---

## Test: NAT-configuratie op Cisco-router

### Testprocedure:

1. Verbind je routerinterface met het klasnetwerk (bijv. via `GigabitEthernet0/1`).
2. Stel deze interface in als **DHCP-client** of gebruik een **statisch IP** (`172.22.200.7`).
3. Configureer NAT:
   - Stel het interne LAN in als `ip nat inside`
   - Stel de uplink-interface in als `ip nat outside`
   - Voeg NAT-regels toe (vb. `ip nat inside source list 1 interface G0/1 overload`)
   - Stel een access-list op die interne IP-ranges toelaat (vb. `access-list 1 permit 192.168.207.0 0.0.0.255`)
4. Test NAT:
   - `ping` van een host in VLAN 12 naar een extern adres (bijv. `8.8.8.8`)

### Verwacht resultaat:

- De NAT-configuratie werkt.
- Hosts krijgen internettoegang via het publieke adres.
- `ping`-testen naar externe adressen slagen.

---

## Test: Access Control Lists (ACLs) op de router

### Testprocedure:

1. Definieer toegestane communicatie (bijv. VLAN 12 mag webserver in VLAN 14 bereiken, enz.).
2. Maak extended ACL’s aan (vb. `ip access-list extended FROM_EMPLOYEES`).
3. Pas ACL’s toe op inkomend verkeer op subinterfaces (bijv. `interface G0/1.12`).
4. Voer `ping` en `telnet`-testen uit tussen hosts om regels te valideren.

### Verwacht resultaat:

- Enkel gedefinieerde communicatie werkt.
- Alle andere niet-geautoriseerde verbindingen worden geweigerd (default deny).
- `ping` of `telnet` naar geblokkeerde poorten/IP’s faalt.

---

## Test: Externe communicatie vanuit VLAN 12

### Testprocedure:

1. Verbind een client in VLAN 12 (met DHCP).
2. Test `ping` naar internet-DNS (`8.8.8.8`) of via `nslookup`.
3. Open een browser naar een externe site indien beschikbaar in simulatie.

### Verwacht resultaat:

- Client krijgt correct IP via DHCP.
- Client heeft werkende internetverbinding via NAT.