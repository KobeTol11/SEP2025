# Testplan

- Uitvoerder(s) test: Gilles De Meerleer
- Uitgevoerd op: 14/05/2025 
- Github commit: <!-- Git commit hash. -->

## Test: Is de Group Policy ingesteld?

Testprocedure

1. Log in als een van de gebruikers in de groep waaraan de GPO toegekent is
2. Open Group Policy Managment
3. Controleer als de GPO "UitbreidingGPO" juist ingesteld is

Verkregen resultaat:

- De GPO verschijnt als het commando "gpresult /r" uitgevoerd wordt
- De GPO wordt niet toegepast met foutmelding "Unknown Reason"

Test geslaagd:

- [ ] Ja
- [x] Nee

Opmerkingen:

- Alles is normaal juist ingesteld maar wilt niet toepassen op gebruikers. Computer Configurations werken wel maar User Configurations niet

## Test: Is de Group Policy juist ingesteld waardoor een group gebruikers een andere achtergrond krijgen en dat het niet gewijzigt kan worden?

Testprocedure:

1. Log in als een van de gebruikers in de groep waaraan de GPO toegekent is
2. Controleer dat de achtergrond een effe kleur is
3. Maak een poging om de achtergrond te wijzigen

Verkregen resultaat:

- Er is geen verandering aan de achtergrond
- De achtergrond kan gewijzigt worden

Test geslaagd:

- [ ] Ja
- [x] Nee

Opmerkingen:

- zie test "Is de Group Policy ingesteld?"

## Test: Is de Group Policy juist ingesteld waardoor een group gebruikers niet gebruik mogen maken van USBs of andere externe osplag?

Testprocedure:

1. Log in als een van de gebruikers in de groep waaraan de GPO toegekent is
2. Maak een poging om in een externe schrijf te geraken

Verkregen resultaat:

- De gebruikers mogen wel aan de externe opslag en USBs
- Geen foutmelding

Test geslaagd:

- [ ] Ja
- [x] Nee

Opmerkingen:

- zie test "Is de Group Policy ingesteld?"

## Test: Is de Group Policy juist ingesteld waardoor een group gebruikers het taakbalk niet mogen veranderen?

Testprocedure:

1. Log in als een van de gebruikers in de groep waaraan de GPO toegekent is
2. Maak een poging om iets aan de taakbalk te veranderen

Verkregen resultaat:

- De gebruikers mogen de taakbalk wel veranderen

Test geslaagd:

- [ ] Ja
- [x] Nee

Opmerkingen:

- zie test "Is de Group Policy ingesteld?"

## Test: Is de Group Policy juist ingesteld waardoor een group gebruikers niet gebruik mogen maken van powershell, command prompt, of regedit?

Testprocedure:

1. Log in als een van de gebruikers in de groep waaraan de GPO toegekent is
2. Maak een poging om powershell, command prompt en regedit te openen

Verkregen resultaat:

- De gebruikers mogen toch gebruik maken van powershell, command prompt en regedit

Test geslaagd:

- [ ] Ja
- [x] Nee

Opmerkingen:

- zie test "Is de Group Policy ingesteld?"

## Test: Is de Group Policy juist ingesteld waardoor een group gebruikers hen downloads folder gewist wordt na dat ze uitloggen?

Testprocedure:

1. Log in als een van de gebruikers in de groep waaraan de GPO toegekent is
2. Download een bestand van google bvb
3. Zorg dat het in de downloads map opgeslaan is
4. Log uit
5. Log terug in en controleer de downloads map

Verkregen resultaat:

- De downloads folder wordt niet gewist na dat de gebruiker uitlogt

Test geslaagd:

- [ ] Ja
- [x] Nee

Opmerkingen:

- zie test "Is de Group Policy ingesteld?"

## Test: Is de Group Policy juist ingesteld waardoor een group gebruikers maar in bepaalde mappen bestanden mogen opslaan?

Testprocedure:

1. Log in als een van de gebruikers in de groep waaraan de GPO toegekent is
2. Maak een tekst bestand
3. Maak een poging om de bestand op te slaan in een van de mappen waar dat niet zou mogen

Verkregen resultaat:

- De gebruikers mogen in gelijk welke locatie bestanden opslaan

Test geslaagd:

- [ ] Ja
- [x] Nee

Opmerkingen:

- zie test "Is de Group Policy ingesteld?"
