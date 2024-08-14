//%attributes = {}
$date:=String:C10(Current date:C33; Interne date court:K1:7)
$heure:=String:C10(Current time:C178; h mn s:K7:1)
$YYMMDD:=Substring:C12($date; 9)+Substring:C12($date; 4; 2)+Substring:C12($date; 1; 2)
$HHMMSS:=Replace string:C233($heure; ":"; "")

$nomDossier:="SIS2A_"+$YYMMDD+"-"+$HHMMSS
$cheminDossier:=Get 4D folder:C485(Dossier Resources courant:K5:16)+$nomDossier+Séparateur dossier:K24:12
//$cheminDossier:=Dossier 4D(Dossier données)+$nomDossier
//CRÉER DOSSIER($cheminDossier; *)
$result:=Folder:C1567("/RESOURCES/"+$nomDossier).create()

C_BOOLEAN:C305($erreur)
$docLog:=Create document:C266($cheminDossier+"Log Erreurs.txt"; ".txt")

// récupération des individus
Antibia_Recup_Individus
// on récupère aussi les non actifs
Antibia_recupere_non_Actifs
//recupération des compétences
Import_Antibia_Pers_Compet
// traitement des individus
$erreur:=genere_donnees_individu($docLog)
$erreur:=Verifie_donnees_Individus($docLog)

//traitement des agents
$erreur:=genere_donnees_agent($docLog)
$erreur:=Verifie_donnnees_Agent($docLog)
//generation des centres comme agents
genere_Donnees_Generiques_Centr
//generation fichier individus
$erreur:=Traite_Fichier_Individus($cheminDossier)
If ($erreur)
	SEND PACKET:C103($docLog; "Erreur dans la generation fichier des individus")
End if 
//generation fichier agents
$erreur:=Traite_Fichier_Agent($cheminDossier)
If ($erreur)
	SEND PACKET:C103($docLog; "Erreur dans la generation fichier des agents")
End if 

// import LDG Panda
Recuperation_LDG_Panda
ALL RECORDS:C47([LISTE_GARDE:44])
If (Records in selection:C76([LISTE_GARDE:44])=0)  // si les plannings n'ont pas été importés
	$stop:=True:C214
Else 
	$stop:=False:C215
End if 
If ($stop=False:C215)
	Verifie_Nouvelle_Affectation
	supprime_carrieres_fermees
	$erreur:=temp_supprime_anciennes_affecta($docLog)
	If ($erreur)
		SEND PACKET:C103($docLog; "Des affectations ont été supprimées pour des anciens agents")
	End if 
	$erreur:=verifie_existence_agents($docLog)
	If ($erreur)
		SEND PACKET:C103($docLog; "Il y avait des affectations pour des idagents non existants")
	End if 
	Regenere_Liste_Garde($cheminDossier)
	// generation fichier competences
	Ajoute_Competence_COND_VL
	$augmentation:=Recopie_Competences
	SEND PACKET:C103($docLog; $augmentation+" competences rajoutées")
	$erreur:=Traite_Fichier_Competences($cheminDossier)
	If ($erreur)
		SEND PACKET:C103($docLog; "Erreur dans la generation fichier des agents")
	End if 
	//affectation agent à profil
	Affectation_Profil
	//generation fichier habilitations
	Cree_Habilitations_New
	Force_Habilitations_NexSIS
	Traite_Fichier_Habilitations($cheminDossier)
	// generation fichier affectations
	$erreur:=Traite_Fichier_Affectations($cheminDossier)
	If ($erreur)
		SEND PACKET:C103($docLog; "Erreur dans la generation fichier des affectations")
	End if 
	Traite_Fichier_UF($cheminDossier)
	$erreur:=Traite_Fichier_GeoUF($cheminDossier)
	If ($erreur)
		SEND PACKET:C103($docLog; "Erreur dans le fichier GeoUF"+Char:C90(Retour à la ligne:K15:40))
	End if 
	Traite_Fichier_Etats_Dispo($cheminDossier)
	Traite_Fichier_Moyens($cheminDossier)
	Traite_Fichier_Piquets($cheminDossier)
	Traite_Fichiers_Emetteurs($cheminDossier)
	Traite_Fichier_radios($cheminDossier)
Else 
	SEND PACKET:C103($docLog; "Erreur dans la recuperation des plannings Panda")
End if 
CLOSE DOCUMENT:C267($docLog)

Envoi_SFTP($cheminDossier; $nomDossier)


