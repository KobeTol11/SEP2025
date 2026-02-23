# Testplan

- Auteurs testplan: Matthias Schoubben

## Test: Werkt de Redundante Server als backup wanneer de Primaire server offline gaat?

Testprocedure:

1. Sluit de primaire server af
2. Open Server Management op de WINCLIENT
3. Controleer als de servers nog runnen
4. Maak een poging om een gpo aan te maken
5. Start de primaire server terug op

Verwacht resultaat:

- De servers dat runnen op windows staan steeds online (DNS, AD DC)
- De primaire server staat uit.
- We kunnen inloggen terwijl de primaire server offline is
- De gpo wordt opgeslaan en bestaat steeds als de primaire server terug online komt