# Opvolgingsrapport 8

<!--
  Pas eenmalig dit sjabloon aan met de info van je groep. Daarna kan je wekelijks een kopie maken.

  Indien bepaalde info ook al in JIRA zit, kan je links toevoegen naar de relevante JIRA items ipv hier een copy/paste of screenshot in te voegen.
-->

## Algemeen

- Groep: G07
- Periode: 3 april 2025 tot 24 april 2025
- Datum voortgangsgesprek: 24 april 2025
- JIRA: [Open het bord](https://sep-g07.atlassian.net/jira/software/c/projects/SEP2425G07/boards/2?useStoredSettings=true)

| Student            | Aanw. | Opmerking |
| :----------------- | :---: | :-------- |
| Gilles De Meerleer |       |           |
| Ruben Van Bruyssel |       |           |
| Matthias Schoubben |       |           |
| Kobe Tollenaere    |       |           |

## Wat heb je deze periode gerealiseerd?

### Algemeen

- Jellyfin werkt
- Nextcloud werkt
- Netwerk iteratie 2 is klaar voor test op fysieke machines
- Probleem met Windows GPOs is opgelost
- Uitbreidningen voor windows begonnen
- Reverse proxy aangepast
- Opvolging
- Overzicht netwerk gemaakt

### Gilles De Meerleer

<!-- Voeg hier een overzicht toe van gerealiseerde taken inclusief links naar relevante commits/documenten. -->

- Jellyfin
- Opvolging

### Ruben Van Bruyssel

<!-- Voeg hier een overzicht toe van gerealiseerde taken inclusief links naar relevante commits/documenten. -->

- Nextcloud
- Troubleshooting Linux

### Matthias Schoubben

<!-- Voeg hier een overzicht toe van gerealiseerde taken inclusief links naar relevante commits/documenten. -->

- Probleem met Windows GPOs is opgelost
- Uitbreidningen voor windows begonnen

### Kobe Tollenaere

<!-- Voeg hier een overzicht toe van gerealiseerde taken inclusief links naar relevante commits/documenten. -->

- Netwerk iteratie 2 afgewerkt
- Overzicht netwerk gemaakt

## Overzicht JIRA

Tijdstabel:
![week 9](img/week9.png)

Totaal aantal uren:

![Totaal aantal uren](img/totgroep9.png)

Cummulatieve flow:
![Cummulatieve flow](img/flow9.png)

## Wat plan je volgende periode te doen?

### Algemeen

<!-- Voeg hier de doelstellingen toe voor volgende periode. -->

- Nog wat extra uitbreidingen toevoegen
- Probleem met reverse proxy oplossen
- Testplannen afwerken

## Retrospectieve

### Wat doen jullie goed?

<!-- Voeg hier zaken toe die jullie goed doen naar het proces toe. -->
Al enkele uitbreidingen af.

### Waar hebben jullie nog problemen mee?

<!-- Voeg hier zaken toe die volgens jullie beter kunnen naar het proces toe. -->

We zitten nog met een probleem in onze reverse proxy. We hebben een paar dingen geprobeerd, maar we krijgen https nog steeds niet werkend. We zullen hiervoor hulp vragen aan meneer Van Vreckem.

### Feedback

Opvolging door : BertVV

#### Groep


Algemeen:

- **Gebruik Kanbanbord is absoluut onvoldoende**! Wordt niet zinvol gebruikt, geen zicht op toestand vh project. Jammer dat we dat op dit punt van het project nog moeten vaststellen!
    - Discord is blijkbaar de project mgmt-tool
    - Jullie moeten ook met ons communiceren over de toestand van het project en dat gebeurt via JIRA!
- Tijdregistratie afgelopen periode lijkt dan wel ok.

Progress:

- Netwerk
    - Iteratie 2 implementeren
- Linux-uitbreidingen
    - Jellyfin
    - Nextcloud
    - Reverse proxy update voor Jellyfin en Nextcloud
        - Openresty
        - Via reverse proxy naar webserver ging enkel nog via http, niet https
        - <https://proxy_ip> redirect naar <http://webserver_ip>
        - Ligt mss aan de webserver?
- Windows
    - GPO uitbreidingen

Vragen:

- We hebben een laptop te kort voor alle VLANs. Oplossing?
    - Jullie mogen een van de pc's gebruiken die in het lokaal staan
        - Tip: je kan een OS installeren op een USB-stick en zo booten. Dan kan je alles vooraf voorbereiden en hoef je op de pc zelf niets te installeren.
    - Een Raspberry Pi is ook een mogelijkheid (en telt als uitbreiding)



#### Gilles De Meerleer

#### Ruben Van Bruyssel

#### Matthias Schoubben

#### Kobe Tollenaere
