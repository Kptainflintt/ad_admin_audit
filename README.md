# ad_admin_audit
Powershell script for auditing admins connexions

## English
Just provide name of DC in order to parse events from Security logs (ID 4624).
For english users : you MUST change the nam eof AD group "Administrateurs de l'entrerpise" to "Enterprise Admins"
This script provides the list of the connections of the members of the group "Enterpirse Admin" (or wathever you want, you can change it) by specifying the date, the hour, the machine of origin and the type of connection (on only two types : 2 and 10).

## Utilisation
Pour l'utiliser, simplement fournir le nom du contrôleur de domaine qu'on souhaite interroger.
Ce script fourni la liste des connexions des membres du groupe "Administrateurs de l'entreprise" (ou celui que vou souhaitez, il suffir de le changer) en précisant la date, l'heure, la machine d'origine et le type de connexion (seulement sur deux types : 2 et 10).

## Types de connexions :
Interactive = connexion par saisie du login / mot de passe  
RemoteInteractive = connexion en TSE ou RDS
