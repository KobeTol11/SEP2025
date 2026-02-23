# Hoe van Packet Tracer naar fysieke toestellen

Ik heb even uitgeschreven hoe we het netwerk dat we in packet tracer gaan uitwerken kunnen overzetten naar fysieke toestellen.

Stap 1: Ontwerp en configureer het netwerk in Packet Tracer

## Stap 2: Exporteer de configuraties

- Open de CLI van elk apparaat en gebruik het commando:

  ```bash
  show running-config
  ```

Plak de configuratie in een tekstbestand en sla het op.

## Stap 3: Overzetten naar fysieke apparaten

- Zet het configuratiebestand over naar een TFTP- of SCP-server die toegankelijk is voor de fysieke apparaten.

- Verbind met elk fysiek toestel via een consolekabel of SSH.

- Gebruik het commando copy tftp running-config (of copy scp running-config) om de configuratie te laden.

- Controleer en pas de instellingen aan indien nodig (zoals poorten of seriële interfaces).

- Sla de configuratie permanent op met copy running-config startup-config.

## Stap 4: test of alles werkt