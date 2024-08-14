//%attributes = {}
// temporaire pour le rattrapage des crss déjà payé en janvier février
//CHERCHER([crss_validation]; [crss_validation]etat_validation="PAYE")
//Si (Enregistrements trouvés([crss_validation])#0)
//Envoi_statuts_paie("VALIDE"; "PAYE")
//Fin de si 

// on va d'abord indiquer à NexSIS les crss qui sont passés en paiement
QUERY:C277([crss_validation:154]; [crss_validation:154]etat_validation:4="A PAYER")
// partie envoi par tranche de 100
If (Records in selection:C76([crss_validation:154])#0)
	Envoi_statuts_paie("VALIDE"; "PAYE")
End if 



// puis on va indiquer les CRSS refusés
QUERY:C277([crss_validation:154]; [crss_validation:154]etat_validation:4="A REFUSER")
// partie envoi
If (Records in selection:C76([crss_validation:154])#0)
	Envoi_statuts_paie("INVALIDE"; "REFUSE")
End if 
