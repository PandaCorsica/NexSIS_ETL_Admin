//%attributes = {}
C_BOOLEAN:C305($erreur)
$docLog:=Create document:C266(Get 4D folder:C485(Dossier base:K5:14)+"Log Erreurs.txt"; ".txt")

Recuperations_Antibia

Traite_Fichier_UF

//_--------------------------------------
// affecter les GeoUF aux UF
//_--------------------------------------

$erreur:=Traite_Fichier_GeoUF
If ($erreur)
	SEND PACKET:C103($docLog; "Erreur dans le fichier GeoUF"+Char:C90(Retour à la ligne:K15:40))
End if 

$erreur:=genere_donnees_individu
If ($erreur)
	SEND PACKET:C103($docLog; "Erreur dans le fichier erreursRH sur les individus (fichier erreursRHIndividus.txt)"+Char:C90(Retour à la ligne:K15:40))
End if 

$erreur:=Verifie_donnees_Individus
If ($erreur)
	SEND PACKET:C103($docLog; "Certains individus ont des informations manquantes (fichier erreursIndividus.txt)"+Char:C90(Retour à la ligne:K15:40))
End if 

$erreur:=Traite_Fichier_Individus
If ($erreur)
	SEND PACKET:C103($docLog; "Erreur dans la creation du fichier Individus"+Char:C90(Retour à la ligne:K15:40))
End if 

//_--------------------------------------
// faire la correspondance Competence Antibia-Competence Nexsis
//_--------------------------------------


$erreur:=genere_donnees_agent
If ($erreur)
	SEND PACKET:C103($docLog; "Erreur dans le fichier ErreursAgents (Agents,affectations ou competences)"+Char:C90(Retour à la ligne:K15:40))
End if 

$erreur:=Verifie_donnnees_Agent
If ($erreur)
	SEND PACKET:C103($docLog; "Certains agents ont des informations manquantes ou en doublon (Agents,affectations ou competences)"+Char:C90(Retour à la ligne:K15:40))
End if 

$erreur:=Traite_Fichier_Agent
If ($erreur)
	SEND PACKET:C103($docLog; "Erreur dans la creation du fichier Agents ou affectations ou competences"+Char:C90(Retour à la ligne:K15:40))
End if 

//Traite_Fichier_CODES_ANTARES

Cree_Etats_Disponibilite

Traite_Fichier_Etats_Dispo

Traite_Fichiers_Vierges

//Traite_Fichier_RSR

Traite_Fichier_Moyens

Traite_Fichier_Piquets

//_--------------------------------------
// Faire les habilitations
//_--------------------------------------



CLOSE DOCUMENT:C267($docLog)
