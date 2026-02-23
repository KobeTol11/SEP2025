# Testplan

- Auteurs testplan: Matthias Schoubben

## Test: Kan men inloggen als gewone gebruiker zo wel als domain administrator op de WINCLIENT?

Testprocedure:

1. Controleer via Settings > System > About als de client in de g07-syndus.internal domain zit.
2. Log uit als admin van WINCLIENT
3. Log in als Administrator@g07-syndus.internal
4. Switch User naar een normaal gebruiker (bvb Ma_Sc)

Verwacht resultaat:

- Er wordt zonder probleem ingelogd als admin van de g07 domain (domain controller)
- Er wordt zonder probleem ingelogd als Ma_Sc binnen de g07 domain (gewone gebruiker)