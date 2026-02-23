# Testplan

- Auteurs testplan: Gilles De Meerleer

## Test: Is het DNS-installatiescript succesvol uitgevoerd?

Testprocedure:

1. Open een nieuw PowerShell-venster
2. Verander de working directory in PowerShell naar de gedeelde map (de project repo)
3. Voer `.\DNS_Config.ps1` uit in het PowerShell venster.

Verwacht resultaat:

- Script voltooid zonder foutmeldingen en de laatste lijn geeft weer dat de dnsServer werkt.
- Er is geen interactie van de gebruiker nodig en dient alles automatisch te verlopen.
- Tijdens of na de uitvoering van het script moet de DNS-service automatisch één keer opnieuw opstarten.

