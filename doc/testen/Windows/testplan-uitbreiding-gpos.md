# Testplan

- Auteurs testplan: Matthias Schoubben

## Test: Is de Group Policy ingesteld?

Testprocedure

1. Log in als een van de gebruikers in de groep waaraan de GPO toegekent is
2. Open Group Policy Managment
3. Controleer als de GPO "UitbreidingGPO" juist ingesteld is

Verwacht resultaat:

- De GPO verschijnt als het commando "gpresult /r" uitgevoerd wordt
- De GPO is gefiltert op de juiste gebruikers

## Test: Is de Group Policy juist ingesteld waardoor een group gebruikers een andere achtergrond krijgen en dat het niet gewijzigt kan worden?

Testprocedure:

1. Log in als een van de gebruikers in de groep waaraan de GPO toegekent is
2. Controleer dat de achtergrond een effe kleur is
3. Maak een poging om de achtergrond te wijzigen

Verwacht resultaat:

- De achtergrond is een effen kleur, namelijk licht blauw.
- De achtergrond kan niet gewijzigt worden.
- Alle andere gebruikers hebben nog de default achtergrond.

## Test: Is de Group Policy juist ingesteld waardoor een group gebruikers niet gebruik mogen maken van USBs of andere externe osplag?

Testprocedure:

1. Log in als een van de gebruikers in de groep waaraan de GPO toegekent is
2. Maak een poging om in een externe schrijf te geraken

Verwacht resultaat:

- Het systeem toont een melding dat de gebruik geen toegang heeft tot deze schijf
- Alle andere gebruikers mogen wel in de externe schijven

## Test: Is de Group Policy juist ingesteld waardoor een group gebruikers het taakbalk niet mogen veranderen?

Testprocedure:

1. Log in als een van de gebruikers in de groep waaraan de GPO toegekent is
2. Maak een poging om iets aan de taakbalk te veranderen

Verwacht resultaat:

- De taakbalk mag niet veranderd worden
- Alle andere gebruikers mogen het wel veranderen

## Test: Is de Group Policy juist ingesteld waardoor een group gebruikers niet gebruik mogen maken van powershell, command prompt, of regedit?

Testprocedure:

1. Log in als een van de gebruikers in de groep waaraan de GPO toegekent is
2. Maak een poging om powershell, command prompt en regedit te openen

Verwacht resultaat:

- Het systeem toont een melding dat de gebruik geen toegang heeft tot deze applicaties
- Alle andere gebruikers mogen ze wel gebruiken

## Test: Is de Group Policy juist ingesteld waardoor een group gebruikers hen downloads folder gewist wordt na dat ze uitloggen?

Testprocedure:

1. Log in als een van de gebruikers in de groep waaraan de GPO toegekent is
2. Download een bestand van google bvb
3. Zorg dat het in de downloads map opgeslaan is
4. Log uit
5. Log terug in en controleer de downloads map

Verwacht resultaat:

- Er zijn geen bestanden meer in de downloads map na dat de gebruiker terug in logd
- Dit gebeurt niet met gebruikers buiten de groep

## Test: Is de Group Policy juist ingesteld waardoor een group gebruikers maar in bepaalde mappen bestanden mogen opslaan?

Testprocedure:

1. Log in als een van de gebruikers in de groep waaraan de GPO toegekent is
2. Maak een tekst bestand
3. Maak een poging om de bestand op te slaan in een van de mappen waar dat niet zou mogen

Verwacht resultaat:

- De bestanden verschijnen in de home share van de gebruiker of in de Documents map.
