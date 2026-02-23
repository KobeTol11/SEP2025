
# Testplan: Basisnetwerk – Iteratie 1

- Auteur testplan: Tollenaere Kobe

## Netwerkconfiguratie

- Groepsnummer: 7
- IP-range: `192.168.207.0/24`
- Uplink naar ISP:
  - ISP Gateway: `192.168.207.1/30`
  - Uplink Interface (eigen router): `192.168.207.2/30`

---

## Test: VLAN-configuratie & Inter-VLAN Routing

### Testprocedure:

1. Verbind drie verschillende pc’s/VM’s aan poorten in respectievelijk VLAN 11, 12 en 14.
2. Stel voor VLAN 11 en VLAN 14 manueel een vast IP-adres in:
   - VLAN 11: `192.168.207.50` (gateway `192.168.207.49`)
   - VLAN 14: `192.168.207.18` (gateway `192.168.207.17`)
3. Laat VLAN 12 een IP verkrijgen via DHCP.
4. Voer `ping` uit tussen apparaten over verschillende VLANs.

### Verwacht resultaat:

- Elke pc krijgt correct IP-adres toegewezen.
- `ping` naar eigen gateway slaagt.
- `ping` tussen VLANs slaagt: toont werkende **router-on-a-stick**.

---

## Test: DHCP-functionaliteit in VLAN 12

### Testprocedure:

1. Verbind een pc aan een poort in VLAN 12.
2. Stel de IP-configuratie in op **DHCP**.
3. Controleer het verkregen IP-adres (`ipconfig` of `ifconfig`).
4. Voer `ping` uit naar:
   - Default gateway (`192.168.207.1`)
   - Interne server in VLAN 11
   - Webserver in VLAN 14

### Verwacht resultaat:

- Het apparaat krijgt een IP-adres binnen bereik (bijv. `192.168.207.130`).
- `ping`-testen zijn succesvol.

---

## Test: Verbinding met ISP-router

### Testprocedure:

1. Zorg dat jouw routerinterface geconfigureerd is met IP `192.168.207.2/30`.
2. Voer een `ping` uit naar `192.168.207.1` (ISP-router).
3. Zorg dat de ISP een statische route heeft naar jouw subnetten.
4. Test `ping` naar een extern IP via de default route.

### Verwacht resultaat:

- `ping` naar de ISP-router werkt.
- Verkeer uit je netwerk kan de default gateway gebruiken.
- Internettoegang is (optioneel in simulatie) mogelijk via simulatie met Packet Tracer Cloud-ISP.
