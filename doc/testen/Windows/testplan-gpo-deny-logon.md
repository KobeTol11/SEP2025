# Testplan

- Auteurs testplan: Matthias Schoubben

## Test: Is de Group Policy juist ingesteld waardoor een bepaalde gebruiker niet kan inloggen?

Testprocedure:

1. Open Group Policy Managment
2. Controleer als de GPO "Deny Logon - He Du" juist ingesteld is
3. Log uit als administrator
4. Maak poging om in te loggen als He_Du

Verwacht resultaat:

- Er wordt een foutmelding getoond dat zegt dat er niet mag ingelogd worden als He_Du.
- De GPO is gefiltert op de toestel WINCLIENT, en de User Right is gefiltert op He_Du.
- Alle andere gebruikers kunnen inloggen op de WINCLIENT toestel.