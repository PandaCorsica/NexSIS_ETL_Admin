//%attributes = {}
ALL RECORDS:C47([RESULT:50])
DELETE SELECTION:C66([RESULT:50])

ALL RECORDS:C47([TEMPO:49])
While (Not:C34(End selection:C36([TEMPO:49])))
	CREATE RECORD:C68([RESULT:50])
	[RESULT:50]mailSIS:2:=[TEMPO:49]mail:2
	[RESULT:50]displayName:8:=[TEMPO:49]displayName:3
	[RESULT:50]hasLicenceExchange:9:=[TEMPO:49]hasLicenceExchange:4
	[RESULT:50]hasLicenceDrive:10:=[TEMPO:49]hasLicenceDrive:5
	[RESULT:50]hasTeamsLicence:11:=[TEMPO:49]hasTeamsLicence:6
	[RESULT:50]exchangeLasActivity:12:=[TEMPO:49]exchangeLasActivity:7
	[RESULT:50]OneDriveLastActivity:13:=[TEMPO:49]OneDriveLastActivity:8
	[RESULT:50]teamsLastActivity:14:=[TEMPO:49]teamsLastActivity:9
	[RESULT:50]typeLicence:15:=[TEMPO:49]typeLicence:10
	QUERY:C277([AGENTS:2]; [AGENTS:2]id_connexion:4=[TEMPO:49]mail:2)
	If (Records in selection:C76([AGENTS:2])#0)
		ORDER BY:C49([AGENTS:2]; [AGENTS:2]matricule:5; >; [AGENTS:2]statut:6; >)
		[RESULT:50]mailGenere:3:=[AGENTS:2]id_connexion:4
		QUERY:C277([INDIVIDUS:1]; [INDIVIDUS:1]id_individu:2=[AGENTS:2]id_individu:2)
		[RESULT:50]Nom:4:=[INDIVIDUS:1]nom_usuel:3
		[RESULT:50]Prenom:5:=[INDIVIDUS:1]prenom:5
		[RESULT:50]Statut:6:=[AGENTS:2]statut:6
		QUERY:C277([AFFECTATIONS:3]; [AFFECTATIONS:3]id_agent:3=[AGENTS:2]id_agent:3)
		QUERY:C277([UF:5]; [UF:5]id_uf:5=[AFFECTATIONS:3]id_uf:4)
		[RESULT:50]Centre:7:=[UF:5]libelle:2
	End if 
	SAVE RECORD:C53([RESULT:50])
	NEXT RECORD:C51([TEMPO:49])
End while 

QUERY:C277([AGENTS:2]; [AGENTS:2]statut:6#"SPV")
ORDER BY:C49([AGENTS:2]; [AGENTS:2]matricule:5; >; [AGENTS:2]statut:6; >)
While (Not:C34(End selection:C36([AGENTS:2])))
	QUERY:C277([TEMPO:49]; [TEMPO:49]mail:2=[AGENTS:2]id_connexion:4)
	If (Records in selection:C76([TEMPO:49])=0)
		CREATE RECORD:C68([RESULT:50])
		[RESULT:50]mailSIS:2:=""
		[RESULT:50]displayName:8:=""
		[RESULT:50]hasLicenceExchange:9:="FAUX"
		[RESULT:50]hasLicenceDrive:10:="FAUX"
		[RESULT:50]hasTeamsLicence:11:="FAUX"
		[RESULT:50]exchangeLasActivity:12:=""
		[RESULT:50]OneDriveLastActivity:13:=""
		[RESULT:50]teamsLastActivity:14:=""
		[RESULT:50]typeLicence:15:=""
		[RESULT:50]mailGenere:3:=[AGENTS:2]id_connexion:4
		QUERY:C277([INDIVIDUS:1]; [INDIVIDUS:1]id_individu:2=[AGENTS:2]id_individu:2)
		[RESULT:50]Nom:4:=[INDIVIDUS:1]nom_usuel:3
		[RESULT:50]Prenom:5:=[INDIVIDUS:1]prenom:5
		[RESULT:50]Statut:6:=[AGENTS:2]statut:6
		QUERY:C277([AFFECTATIONS:3]; [AFFECTATIONS:3]id_agent:3=[AGENTS:2]id_agent:3)
		QUERY:C277([UF:5]; [UF:5]id_uf:5=[AFFECTATIONS:3]id_uf:4)
		[RESULT:50]Centre:7:=[UF:5]libelle:2
		SAVE RECORD:C53([RESULT:50])
	End if 
	NEXT RECORD:C51([AGENTS:2])
End while 

