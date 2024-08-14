//%attributes = {}
// méthode qui intervient après l'import des moyens et centres de Systel

// on note qu'on débute le traitement donc aucun moyen n'est traité
ALL RECORDS:C47([IMPORT_MOYENS:43])
APPLY TO SELECTION:C70([IMPORT_MOYENS:43]; [IMPORT_MOYENS:43]traite:18:=False:C215)
APPLY TO SELECTION:C70([IMPORT_MOYENS:43]; [IMPORT_MOYENS:43]aSupprimer:19:=False:C215)

// 1) on filtre les centres qui ne servent à rien
ALL RECORDS:C47([CENTRES_SYSTEL:42])
While (Not:C34(End selection:C36([CENTRES_SYSTEL:42])))
	QUERY:C277([IMPORT_MOYENS:43]; [IMPORT_MOYENS:43]id_uf_ope:8=[CENTRES_SYSTEL:42]Nom:3)
	If (Records in selection:C76([IMPORT_MOYENS:43])=0)
		[CENTRES_SYSTEL:42]aSupprimer:4:=True:C214
	Else 
		[CENTRES_SYSTEL:42]aSupprimer:4:=False:C215
	End if 
	SAVE RECORD:C53([CENTRES_SYSTEL:42])
	NEXT RECORD:C51([CENTRES_SYSTEL:42])
End while 

QUERY:C277([CENTRES_SYSTEL:42]; [CENTRES_SYSTEL:42]aSupprimer:4=True:C214)
DELETE SELECTION:C66([CENTRES_SYSTEL:42])

//2) on repere les engins qui ne sont affectés à aucun centre et pour les autres on change leur code
ALL RECORDS:C47([IMPORT_MOYENS:43])
While (Not:C34(End selection:C36([IMPORT_MOYENS:43])))
	QUERY:C277([CENTRES_SYSTEL:42]; [CENTRES_SYSTEL:42]Nom:3=[IMPORT_MOYENS:43]id_uf_ope:8)
	If (Records in selection:C76([CENTRES_SYSTEL:42])=0)
		[IMPORT_MOYENS:43]aSupprimer:19:=True:C214
	Else 
		If (Num:C11([CENTRES_SYSTEL:42]Code:2)=0)
			[CENTRES_SYSTEL:42]aSupprimer:4:=True:C214
			[IMPORT_MOYENS:43]aSupprimer:19:=True:C214
		Else 
			[IMPORT_MOYENS:43]id_uf_ope:8:=[CENTRES_SYSTEL:42]Code:2
		End if 
	End if 
	SAVE RECORD:C53([IMPORT_MOYENS:43])
	NEXT RECORD:C51([IMPORT_MOYENS:43])
End while 


//3) on supprime les centres et les moyens marqués à supprimer
QUERY:C277([CENTRES_SYSTEL:42]; [CENTRES_SYSTEL:42]aSupprimer:4=True:C214)
DELETE SELECTION:C66([CENTRES_SYSTEL:42])

QUERY:C277([IMPORT_MOYENS:43]; [IMPORT_MOYENS:43]aSupprimer:19=True:C214)
DELETE SELECTION:C66([IMPORT_MOYENS:43])

//4) on va maintenant mettre les codes réels des moyens
ALL RECORDS:C47([IMPORT_MOYENS:43])
While (Not:C34(End selection:C36([IMPORT_MOYENS:43])))
	QUERY:C277([IMPORT_CIS:20]; [IMPORT_CIS:20]Code_Corps:4=[IMPORT_MOYENS:43]id_uf_ope:8)
	If (Records in selection:C76([IMPORT_CIS:20])=0)
		//TRACE
	Else 
		[IMPORT_MOYENS:43]id_uf_ope:8:=[IMPORT_CIS:20]Abrege:8
	End if 
	
	SAVE RECORD:C53([IMPORT_MOYENS:43])
	NEXT RECORD:C51([IMPORT_MOYENS:43])
End while 

//5° on supprime ceux qui n'ont pas de type
QUERY:C277([IMPORT_MOYENS:43]; [IMPORT_MOYENS:43]vecteur:3="")
DELETE SELECTION:C66([IMPORT_MOYENS:43])

//6) on affecte les autres au site mezzavia
QUERY:C277([IMPORT_MOYENS:43]; [IMPORT_MOYENS:43]id_uf_ope:8="707"; *)
QUERY:C277([IMPORT_MOYENS:43];  | ; [IMPORT_MOYENS:43]id_uf_ope:8="133"; *)
QUERY:C277([IMPORT_MOYENS:43];  | ; [IMPORT_MOYENS:43]id_uf_ope:8="138")
APPLY TO SELECTION:C70([IMPORT_MOYENS:43]; [IMPORT_MOYENS:43]id_uf_ope:8:="SMZ")

//7) eventuellement pour les autres on les affecte au SIS
QUERY BY FORMULA:C48([IMPORT_MOYENS:43]; Num:C11([IMPORT_MOYENS:43]id_uf_ope:8)#0)
APPLY TO SELECTION:C70([IMPORT_MOYENS:43]; [IMPORT_MOYENS:43]id_uf_ope:8:="SIS2A")

//8) Pour les engins qui n'ont pas de code unique, on le crée
QUERY:C277([IMPORT_MOYENS:43]; [IMPORT_MOYENS:43]id_Moyen:2="")
APPLY TO SELECTION:C70([IMPORT_MOYENS:43]; [IMPORT_MOYENS:43]id_Moyen:2:=[IMPORT_MOYENS:43]vecteur:3+"-"+String:C10([IMPORT_MOYENS:43]num_ordre_dept:5))

//9) on corrige l'i_uf_dep
ALL RECORDS:C47([IMPORT_MOYENS:43])
APPLY TO SELECTION:C70([IMPORT_MOYENS:43]; [IMPORT_MOYENS:43]id_uf_admin:7:="sis")

//10) on corrige le type remorque
ALL RECORDS:C47([IMPORT_MOYENS:43])
APPLY TO SELECTION:C70([IMPORT_MOYENS:43]; [IMPORT_MOYENS:43]type_vesteur:14:="vecteur")
QUERY:C277([IMPORT_MOYENS:43]; [IMPORT_MOYENS:43]vecteur:3="REM")
APPLY TO SELECTION:C70([IMPORT_MOYENS:43]; [IMPORT_MOYENS:43]type_vesteur:14:="remorque")


