//%attributes = {}
ALL RECORDS:C47([IMPORT_CIS:20])
APPLY TO SELECTION:C70([IMPORT_CIS:20]; [IMPORT_CIS:20]toDelete:9:=True:C214)
ALL RECORDS:C47([IMPORT_GPT:22])
APPLY TO SELECTION:C70([IMPORT_GPT:22]; [IMPORT_GPT:22]toDelete:5:=True:C214)
ALL RECORDS:C47([IMPORT_COMPAGNIE:21])
APPLY TO SELECTION:C70([IMPORT_COMPAGNIE:21]; [IMPORT_COMPAGNIE:21]toDelete:6:=True:C214)
ALL RECORDS:C47([IMPORT_BUREAU:38])
APPLY TO SELECTION:C70([IMPORT_BUREAU:38]; [IMPORT_BUREAU:38]toDelete:8:=True:C214)
ALL RECORDS:C47([IMPORT_SERVICES:37])
APPLY TO SELECTION:C70([IMPORT_SERVICES:37]; [IMPORT_SERVICES:37]toDelete:9:=True:C214)
ALL RECORDS:C47([IMPORT_GPT_FONCT:36])
APPLY TO SELECTION:C70([IMPORT_GPT_FONCT:36]; [IMPORT_GPT_FONCT:36]toDelete:8:=True:C214)
ALL RECORDS:C47([IMPORT_POLE:34])
APPLY TO SELECTION:C70([IMPORT_POLE:34]; [IMPORT_POLE:34]toDelete:8:=True:C214)
ALL RECORDS:C47([IMPORT_DIRECTIONS:35])
APPLY TO SELECTION:C70([IMPORT_DIRECTIONS:35]; [IMPORT_DIRECTIONS:35]toDelete:4:=True:C214)

ALL RECORDS:C47([UF:5])
DELETE SELECTION:C66([UF:5])

$doc:=Create document:C266(Get 4D folder:C485(Dossier base:K5:14)+"Erreurs UF.txt"; ".txt")


$idUFSis:="SIS2A"
// Création du SIS2A
QUERY:C277([UF:5]; [UF:5]id_uf:5=$idUFSis)
If (Records in selection:C76([UF:5])=0)
	CREATE RECORD:C68([UF:5])
	[UF:5]id_uf:5:=$idUFSis
	[UF:5]id_uf_pere:6:=""
	[UF:5]libelle:2:="SIS 2A"
	[UF:5]type_dept:4:="SIS"
	[UF:5]type_reglementaire:3:="SDIS"
	[UF:5]type_UF:8:="O"  //affectations ops
	SAVE RECORD:C53([UF:5])
End if 

// on cree la base securité civile
QUERY:C277([UF:5]; [UF:5]id_uf:5="BASC")
If (Records in selection:C76([UF:5])=0)
	CREATE RECORD:C68([UF:5])
	[UF:5]code_Antibia:7:=""
	[UF:5]id_uf:5:="BASC"
	[UF:5]id_uf_pere:6:=$idUFSis
	[UF:5]libelle:2:="BASE SECURITE CIVILE"
	[UF:5]type_dept:4:="BASC"
	[UF:5]type_reglementaire:3:="BASC"
	[UF:5]type_UF:8:="O"  //affectations ops
	SAVE RECORD:C53([UF:5])
End if 

// on cree la base helico securité civile
QUERY:C277([UF:5]; [UF:5]id_uf:5="BHSC")
If (Records in selection:C76([UF:5])=0)
	CREATE RECORD:C68([UF:5])
	[UF:5]code_Antibia:7:=""
	[UF:5]id_uf:5:="BHSC"
	[UF:5]id_uf_pere:6:=$idUFSis
	[UF:5]libelle:2:="BASE HELICO SECURITE CIVILE"
	[UF:5]type_dept:4:="BHSCC"
	[UF:5]type_reglementaire:3:="BHSC"
	[UF:5]type_UF:8:="O"  //affectations ops
	SAVE RECORD:C53([UF:5])
End if 


// on cree la base helico gendarmerie
QUERY:C277([UF:5]; [UF:5]id_uf:5="BHGN")
If (Records in selection:C76([UF:5])=0)
	CREATE RECORD:C68([UF:5])
	[UF:5]code_Antibia:7:=""
	[UF:5]id_uf:5:="BHGN"
	[UF:5]id_uf_pere:6:=$idUFSis
	[UF:5]libelle:2:="BASE HELICO GENDARMERIE"
	[UF:5]type_dept:4:="BHGN"
	[UF:5]type_reglementaire:3:="INTERVENANT_EXTERIEUR"
	[UF:5]type_UF:8:="O"  //affectations ops
	SAVE RECORD:C53([UF:5])
End if 



// on va creer les CIS où sont affectés des gens
ALL RECORDS:C47([IMPORT_INDIVIDUS:17])
While (Not:C34(End selection:C36([IMPORT_INDIVIDUS:17])))
	//(On ne crée dans un premier temps comme UF territoriales que les CIS les zones et les Gpt)
	$cleComp:=""
	$cleGpt:=""
	// on regarde d'abord les affectations CIS 
	QUERY:C277([UF:5]; [UF:5]code_Antibia:7=[IMPORT_INDIVIDUS:17]Cle_Corps:13)
	If (Records in selection:C76([UF:5])=0)
		CREATE RECORD:C68([UF:5])
		[UF:5]code_Antibia:7:=[IMPORT_INDIVIDUS:17]Cle_Corps:13
		QUERY:C277([IMPORT_CIS:20]; [IMPORT_CIS:20]Cle_Corps:2=[IMPORT_INDIVIDUS:17]Cle_Corps:13)
		If (Records in selection:C76([IMPORT_CIS:20])=0)
			SEND PACKET:C103($doc; "IMPORT_CIS non existant - cle corps : "+[IMPORT_INDIVIDUS:17]Cle_Corps:13+"(individu : "+[IMPORT_INDIVIDUS:17]Matricule:2+")"+Char:C90(Retour à la ligne:K15:40))
		Else 
			$cleComp:=[IMPORT_CIS:20]Code_Compagnie:6
			$cleGpt:=[IMPORT_CIS:20]Code_Gpt:7
			[IMPORT_CIS:20]toDelete:9:=False:C215
			SAVE RECORD:C53([IMPORT_CIS:20])
			[UF:5]id_uf:5:=[IMPORT_CIS:20]Abrege:8
			If ($cleComp#"")
				[UF:5]id_uf_pere:6:=$cleComp
			Else 
				[UF:5]id_uf_pere:6:=$cleGpt
			End if 
			[UF:5]libelle:2:=[IMPORT_CIS:20]Non_Corps:3
			QUERY:C277([IMPORT_TYPE:23]; [IMPORT_TYPE:23]cle_type:2=[IMPORT_CIS:20]Type_Centre:5)
			[UF:5]type_dept:4:=[IMPORT_TYPE:23]type:3
			[UF:5]type_reglementaire:3:=[IMPORT_TYPE:23]code_Ref:4
			//Si ([IMPORT_TYPE]code_Ref="GRPT")
			//[UF]id_uf_pere:=$idUFSis
			//Fin de si 
			[UF:5]type_UF:8:="O"  //affectations ops
			SAVE RECORD:C53([UF:5])
		End if 
	End if 
	
	
	// on cree l'UF de la compagnie si elle existe
	If ($cleComp#"")
		QUERY:C277([UF:5]; [UF:5]code_Antibia:7=$cleComp)
		If (Records in selection:C76([UF:5])=0)
			CREATE RECORD:C68([UF:5])
			[UF:5]code_Antibia:7:=$cleComp
			QUERY:C277([IMPORT_COMPAGNIE:21]; [IMPORT_COMPAGNIE:21]Cle_Comp:2=$cleComp)
			If (Records in selection:C76([IMPORT_COMPAGNIE:21])=0)
				SEND PACKET:C103($doc; "IMPORT_COMPAGNIE non existant - cle compagnie : "+$cleComp+"(individu : "+[IMPORT_INDIVIDUS:17]Matricule:2+")"+Char:C90(Retour à la ligne:K15:40))
			Else 
				[IMPORT_COMPAGNIE:21]toDelete:6:=False:C215
				SAVE RECORD:C53([IMPORT_COMPAGNIE:21])
				[UF:5]id_uf:5:=[IMPORT_COMPAGNIE:21]code:4
				[UF:5]id_uf_pere:6:=[IMPORT_COMPAGNIE:21]cle_gpt:5
				[UF:5]libelle:2:=[IMPORT_COMPAGNIE:21]libelle:3
				[UF:5]type_dept:4:="Secteur"
				[UF:5]type_reglementaire:3:="GRPT"
				[UF:5]type_UF:8:="O"
				SAVE RECORD:C53([UF:5])
			End if 
		End if 
	End if 
	
	//on cree l'UF du groupement
	QUERY:C277([UF:5]; [UF:5]code_Antibia:7=$cleGpt)
	If (Records in selection:C76([UF:5])=0)
		CREATE RECORD:C68([UF:5])
		[UF:5]code_Antibia:7:=$cleGpt
		QUERY:C277([IMPORT_GPT:22]; [IMPORT_GPT:22]cle_gpt:2=$cleGpt)
		If (Records in selection:C76([IMPORT_GPT:22])=0)
			SEND PACKET:C103($doc; "IMPORT_GRPT non existant - cle compagnie : "+$cleGpt+"(individu : "+[IMPORT_INDIVIDUS:17]Matricule:2+")"+Char:C90(Retour à la ligne:K15:40))
		Else 
			[IMPORT_GPT:22]toDelete:5:=False:C215
			SAVE RECORD:C53([IMPORT_GPT:22])
			[UF:5]id_uf:5:=[IMPORT_GPT:22]code:4
			[UF:5]id_uf_pere:6:=$idUFSis
			[UF:5]libelle:2:=[IMPORT_GPT:22]libelle:3
			[UF:5]type_dept:4:="Groupement"
			[UF:5]type_reglementaire:3:="GRPT"
			[UF:5]type_UF:8:="O"
			SAVE RECORD:C53([UF:5])
		End if 
	End if 
	
	
	// on cree maintenant les affectations fonctionnelles
	If (False:C215)  // pour le moment on ne traite pas les bureaux
		If ([IMPORT_INDIVIDUS:17]Cle_Bureau:21#"")
			QUERY:C277([UF:5]; [UF:5]code_Antibia:7=[IMPORT_INDIVIDUS:17]Cle_Bureau:21)
			If (Records in selection:C76([UF:5])=0)
				CREATE RECORD:C68([UF:5])
				[UF:5]code_Antibia:7:=[IMPORT_INDIVIDUS:17]Cle_Bureau:21
				QUERY:C277([IMPORT_BUREAU:38]; [IMPORT_BUREAU:38]cleBur:2=[IMPORT_INDIVIDUS:17]Cle_Bureau:21)
				If (Records in selection:C76([IMPORT_BUREAU:38])=0)
					SEND PACKET:C103($doc; "IMPORT_BUREAU non existant - cle bureau : "+[IMPORT_INDIVIDUS:17]Cle_Bureau:21+"(individu : "+[IMPORT_INDIVIDUS:17]Matricule:2+")"+Char:C90(Retour à la ligne:K15:40))
				Else 
					[IMPORT_BUREAU:38]toDelete:8:=False:C215
					SAVE RECORD:C53([IMPORT_BUREAU:38])
					[UF:5]id_uf:5:=[IMPORT_BUREAU:38]cleBur:2
					[UF:5]id_uf_pere:6:=[IMPORT_BUREAU:38]cleServ:4
					[UF:5]libelle:2:=[IMPORT_BUREAU:38]libelle:3
					//CHERCHER([IMPORT_TYPE]; [IMPORT_TYPE]cle_type=[IMPORT_CIS]Type_Centre)
					[UF:5]type_dept:4:="BUREAU"
					[UF:5]type_reglementaire:3:=""
					[UF:5]type_UF:8:="F"  //affectations fonctionnelle
					SAVE RECORD:C53([UF:5])
				End if 
			End if 
		End if 
		
		If ([IMPORT_INDIVIDUS:17]Cle_Service:20#"")
			QUERY:C277([UF:5]; [UF:5]code_Antibia:7=[IMPORT_INDIVIDUS:17]Cle_Service:20)
			If (Records in selection:C76([UF:5])=0)
				CREATE RECORD:C68([UF:5])
				[UF:5]code_Antibia:7:=[IMPORT_INDIVIDUS:17]Cle_Service:20
				QUERY:C277([IMPORT_SERVICES:37]; [IMPORT_SERVICES:37]cle_ser:2=[IMPORT_INDIVIDUS:17]Cle_Service:20)
				If (Records in selection:C76([IMPORT_SERVICES:37])=0)
					SEND PACKET:C103($doc; "IMPORT_SERVICE non existant - cle service : "+[IMPORT_INDIVIDUS:17]Cle_Service:20+"(individu : "+[IMPORT_INDIVIDUS:17]Matricule:2+")"+Char:C90(Retour à la ligne:K15:40))
				Else 
					[IMPORT_SERVICES:37]toDelete:9:=False:C215
					SAVE RECORD:C53([IMPORT_SERVICES:37])
					[UF:5]id_uf:5:=[IMPORT_SERVICES:37]cle_ser:2
					[UF:5]id_uf_pere:6:=[IMPORT_SERVICES:37]cle_grp:4
					[UF:5]libelle:2:=[IMPORT_SERVICES:37]libelle:3
					//CHERCHER([IMPORT_TYPE]; [IMPORT_TYPE]cle_type=[IMPORT_CIS]Type_Centre)
					[UF:5]type_dept:4:="SERVICE"
					[UF:5]type_reglementaire:3:=""
					[UF:5]type_UF:8:="F"  //affectations fonctionnelle
					SAVE RECORD:C53([UF:5])
				End if 
			End if 
		End if 
	End if 
	
	If ([IMPORT_INDIVIDUS:17]Cle_GptFct:22#"")
		QUERY:C277([UF:5]; [UF:5]code_Antibia:7=[IMPORT_INDIVIDUS:17]Cle_GptFct:22)
		If (Records in selection:C76([UF:5])=0)
			CREATE RECORD:C68([UF:5])
			[UF:5]code_Antibia:7:=[IMPORT_INDIVIDUS:17]Cle_GptFct:22
			QUERY:C277([IMPORT_GPT_FONCT:36]; [IMPORT_GPT_FONCT:36]cle_grpfonc:2=[IMPORT_INDIVIDUS:17]Cle_GptFct:22)
			If (Records in selection:C76([IMPORT_GPT_FONCT:36])=0)
				SEND PACKET:C103($doc; "IMPORT_GPTFONCT non existant - cle gptfonc : "+[IMPORT_INDIVIDUS:17]Cle_GptFct:22+"(individu : "+[IMPORT_INDIVIDUS:17]Matricule:2+")"+Char:C90(Retour à la ligne:K15:40))
				[IMPORT_INDIVIDUS:17]Cle_GptFct:22:=""
				SAVE RECORD:C53([IMPORT_INDIVIDUS:17])
			Else 
				[IMPORT_GPT_FONCT:36]toDelete:8:=False:C215
				SAVE RECORD:C53([IMPORT_GPT_FONCT:36])
				[UF:5]id_uf:5:=[IMPORT_GPT_FONCT:36]cle_grpfonc:2
				[UF:5]id_uf_pere:6:=[IMPORT_GPT_FONCT:36]cle_pole:5
				[UF:5]libelle:2:=[IMPORT_GPT_FONCT:36]libelle:3
				//CHERCHER([IMPORT_TYPE]; [IMPORT_TYPE]cle_type=[IMPORT_CIS]Type_Centre)
				[UF:5]type_dept:4:="GPT FONCT"
				[UF:5]type_reglementaire:3:=""
				[UF:5]type_UF:8:="F"  //affectations fonctionnelle
				SAVE RECORD:C53([UF:5])
			End if 
		End if 
	End if 
	
	If ([IMPORT_INDIVIDUS:17]Cle_Pole:23#"")
		QUERY:C277([UF:5]; [UF:5]code_Antibia:7=[IMPORT_INDIVIDUS:17]Cle_Pole:23)
		If (Records in selection:C76([UF:5])=0)
			CREATE RECORD:C68([UF:5])
			[UF:5]code_Antibia:7:=[IMPORT_INDIVIDUS:17]Cle_Pole:23
			QUERY:C277([IMPORT_POLE:34]; [IMPORT_POLE:34]cle_Pole:2=[IMPORT_INDIVIDUS:17]Cle_Pole:23)
			If (Records in selection:C76([IMPORT_POLE:34])=0)
				SEND PACKET:C103($doc; "IMPORT_POLE non existant - cle pole : "+[IMPORT_INDIVIDUS:17]Cle_Pole:23+"(individu : "+[IMPORT_INDIVIDUS:17]Matricule:2+")"+Char:C90(Retour à la ligne:K15:40))
			Else 
				[IMPORT_POLE:34]toDelete:8:=False:C215
				SAVE RECORD:C53([IMPORT_POLE:34])
				[UF:5]id_uf:5:=[IMPORT_POLE:34]cle_Pole:2
				[UF:5]id_uf_pere:6:=[IMPORT_POLE:34]cle_Direction:6
				[UF:5]libelle:2:=[IMPORT_POLE:34]libelle:3
				//CHERCHER([IMPORT_TYPE]; [IMPORT_TYPE]cle_type=[IMPORT_CIS]Type_Centre)
				[UF:5]type_dept:4:="POLE"
				[UF:5]type_reglementaire:3:=""
				[UF:5]type_UF:8:="F"  //affectations fonctionnelle
				SAVE RECORD:C53([UF:5])
			End if 
		End if 
	End if 
	
	If ([IMPORT_INDIVIDUS:17]Cle_Direction:24#"")
		QUERY:C277([UF:5]; [UF:5]code_Antibia:7=[IMPORT_INDIVIDUS:17]Cle_Direction:24)
		If (Records in selection:C76([UF:5])=0)
			CREATE RECORD:C68([UF:5])
			[UF:5]code_Antibia:7:=[IMPORT_INDIVIDUS:17]Cle_Direction:24
			QUERY:C277([IMPORT_DIRECTIONS:35]; [IMPORT_DIRECTIONS:35]cle_Direction:2=[IMPORT_INDIVIDUS:17]Cle_Direction:24)
			If (Records in selection:C76([IMPORT_DIRECTIONS:35])=0)
				SEND PACKET:C103($doc; "IMPORT_DIRECTION non existant - cle direction : "+[IMPORT_INDIVIDUS:17]Cle_Direction:24+"(individu : "+[IMPORT_INDIVIDUS:17]Matricule:2+")"+Char:C90(Retour à la ligne:K15:40))
			Else 
				[IMPORT_DIRECTIONS:35]toDelete:4:=False:C215
				SAVE RECORD:C53([IMPORT_DIRECTIONS:35])
				[UF:5]id_uf:5:=[IMPORT_DIRECTIONS:35]cle_Direction:2
				[UF:5]id_uf_pere:6:=$idUFSis
				[UF:5]libelle:2:=[IMPORT_DIRECTIONS:35]libelle:3
				//CHERCHER([IMPORT_TYPE]; [IMPORT_TYPE]cle_type=[IMPORT_CIS]Type_Centre)
				[UF:5]type_dept:4:="DIRECTION"
				[UF:5]type_reglementaire:3:=""
				[UF:5]type_UF:8:="F"  //affectations fonctionnelle
				SAVE RECORD:C53([UF:5])
			End if 
		End if 
	End if 
	
	NEXT RECORD:C51([IMPORT_INDIVIDUS:17])
End while 

CLOSE DOCUMENT:C267($doc)



QUERY:C277([IMPORT_CIS:20]; [IMPORT_CIS:20]toDelete:9=True:C214)
DELETE SELECTION:C66([IMPORT_CIS:20])

QUERY:C277([IMPORT_COMPAGNIE:21]; [IMPORT_COMPAGNIE:21]toDelete:6=True:C214)
DELETE SELECTION:C66([IMPORT_COMPAGNIE:21])

QUERY:C277([IMPORT_GPT:22]; [IMPORT_GPT:22]toDelete:5=True:C214)
DELETE SELECTION:C66([IMPORT_GPT:22])

QUERY:C277([IMPORT_BUREAU:38]; [IMPORT_BUREAU:38]toDelete:8=True:C214)
DELETE SELECTION:C66([IMPORT_BUREAU:38])

QUERY:C277([IMPORT_SERVICES:37]; [IMPORT_SERVICES:37]toDelete:9=True:C214)
DELETE SELECTION:C66([IMPORT_SERVICES:37])

QUERY:C277([IMPORT_GPT_FONCT:36]; [IMPORT_GPT_FONCT:36]toDelete:8=True:C214)
DELETE SELECTION:C66([IMPORT_GPT_FONCT:36])

QUERY:C277([IMPORT_POLE:34]; [IMPORT_POLE:34]toDelete:8=True:C214)
DELETE SELECTION:C66([IMPORT_POLE:34])


QUERY:C277([IMPORT_DIRECTIONS:35]; [IMPORT_DIRECTIONS:35]toDelete:4=True:C214)
DELETE SELECTION:C66([IMPORT_DIRECTIONS:35])






