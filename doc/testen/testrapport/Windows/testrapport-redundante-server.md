# Testplan

- Uitvoerder(s) test: Gilles De Meerleer
- Uitgevoerd op: 14/05/2025 
- Github commit: <!-- Git commit hash. -->

## Test: Werkt de Redundante Server als backup wanneer de Primaire server offline gaat?

Testprocedure:

1. Sluit de primaire server
2. Open Server Management op de WINCLIENT
3. Controleer als de servers nog runnen

Verkregen resultaat:

- De servers dat runnen op windows staan steeds online (DNS, AD DC)
- De primaire server staat uit.
- We kunnen inloggen terwijl de primaire server offline is

Test geslaagd:

- [x] Ja
- [ ] Nee

Opmerkingen:

- niet geslaagd op WINCLIENT1 maar wel op WINCLIENT
