# Testplan

- Auteur testplan: Gilles De Meerleer

## Test: Router-on-a-Stick

Testprocedure:

1. Verbind een PC met een poort in **VLAN 11** (Interne Servers).
2. Wijs handmatig een IP-adres toe binnen het bereik van VLAN 11 (bijv. `192.168.207.51/29`) en stel de gateway in op `192.168.207.1`.
3. Voer een `ping`-test uit naar de gateway (`192.168.207.1`).
4. Voer een `ping`-test uit naar een apparaat in een ander VLAN (bijv. de reverse proxy in VLAN 14 op `192.168.207.17`).
5. Herhaal de stappen voor apparaten in **VLAN 12** en **VLAN 14**.

Verwacht resultaat:

- De `ping`-test naar de gateway moet succesvol zijn.
- De `ping`-test naar apparaten in andere VLANs moet succesvol zijn, wat aantoont dat Inter-VLAN routing werkt.

## Test: DHCP functionaliteit in VLAN 12

Testprocedure:

1. Verbind een PC met een poort in **VLAN 12** (Werkstations).
2. Kies voor DHCP in de ip configuratie.
3. Controleer of het apparaat een IP-adres krijgt toegewezen binnen het bereik van VLAN 12.
4. Voer een `ping`-test uit naar de gateway (`192.168.207.1`).
5. Voer een `ping`-test uit naar een apparaat in een ander VLAN.

Verwacht resultaat:

- Het apparaat moet een geldig IP-adres, subnetmasker en gateway ontvangen via DHCP.
- De `ping`-test naar de gateway en apparaten in andere VLANs moet succesvol zijn.
