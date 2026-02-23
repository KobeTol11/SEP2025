
# Testplan: Redundante Routerconfiguratie (Iteratie 3)

- Uitvoerder(s) test: 
- Uitgevoerd op: 14/05/2025 


## Doelstelling

De netwerkinfrastructuur wordt redundant gemaakt door een tweede (passieve) router toe te voegen. Dit verhoogt de beschikbaarheid bij falen van de actieve router of bij kabelbreuken.

## Netwerkconfiguratie

- Groepsnummer: **X**
- Router 1 (Actief): `172.22.200.7/16`
- Router 2 (Redundant): `172.22.200.107/16`
- Default gateway (FHRP virtual IP): `172.22.200.254`
- FHRP gebruikt: HSRP of VRRP
- NAT wordt enkel op de actieve router uitgevoerd
- FHRP alleen binnen het eigen netwerk

---

## Test: FHRP werking (basis)

### Testprocedure:

1. Controleer HSRP- of VRRP-status op beide routers (`show standby` of `show vrrp`)
2. Controleer of virtuele IP (`172.22.200.254`) actief is en verkeer doorstuurt via Router 1

### Verwacht resultaat:

- Router 1 is actief, Router 2 is standby
- De virtuele IP is bereikbaar en functioneert als default gateway
- NAT werkt via Router 1

---

## Testscenario 3: Volledig falen van Router 1

### Testprocedure:

1. Zet Router 1 volledig uit of reboot
2. Controleer failover naar Router 2 via `show standby`
3. Test interne communicatie én internettoegang

### Verwacht resultaat:

- Router 2 neemt rol van actieve router volledig over
- Geen verlies van connectiviteit of DNS-resolutie
- NAT blijft actief (indien nodig overnemen via script of fallback)

---

## Test: Herstel na falen

### Testprocedure:

1. Herstart Router 1 en sluit alles opnieuw aan
2. Controleer of Router 1 terug in standby modus komt
3. Test redundantie opnieuw (failover terug naar Router 1)

### Verwacht resultaat:

- Router 1 komt terug online als standby
- Netwerk blijft stabiel
- FHRP werkt opnieuw correct


