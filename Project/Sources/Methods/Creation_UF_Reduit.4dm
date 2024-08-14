//%attributes = {}
ALL RECORDS:C47([IMPORT_CIS:20])
APPLY TO SELECTION:C70([IMPORT_CIS:20]; [IMPORT_CIS:20]toDelete:9:=True:C214)
ALL RECORDS:C47([IMPORT_GPT:22])
APPLY TO SELECTION:C70([IMPORT_GPT:22]; [IMPORT_GPT:22]toDelete:5:=True:C214)

ALL RECORDS:C47([UF:5])
DELETE SELECTION:C66([UF:5])

$doc:=Create document:C266(Get 4D folder:C485(Dossier base:K5:14)+"Erreurs UF.txt"; ".txt")


$idUFSis:="sis"
// Création du SIS2A
QUERY:C277([UF:5]; [UF:5]id_uf:5=$idUFSis)
If (Records in selection:C76([UF:5])=0)
	CREATE RECORD:C68([UF:5])
	[UF:5]id_uf:5:=$idUFSis
	[UF:5]id_uf_pere:6:=""
	[UF:5]libelle:2:="SIS 2A"
	[UF:5]type_dept:4:="SIS"
	[UF:5]type_reglementaire:3:="SIS"
	[UF:5]type_UF:8:="O"  //affectations ops
	[UF:5]Mobilisable:11:="FALSE"
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
	[UF:5]Mobilisable:11:="TRUE"
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
	[UF:5]type_dept:4:="BHSC"
	[UF:5]type_reglementaire:3:="BHSC"
	[UF:5]type_UF:8:="O"  //affectations ops
	[UF:5]Mobilisable:11:="TRUE"
	SAVE RECORD:C53([UF:5])
End if 


//// on cree la gendarmerie pour le traçage de leurs engins (Helico et PGHM)
QUERY:C277([UF:5]; [UF:5]id_uf:5="Gendarmerie")
If (Records in selection:C76([UF:5])=0)
	CREATE RECORD:C68([UF:5])
	[UF:5]code_Antibia:7:=""
	[UF:5]id_uf:5:="GIE"
	[UF:5]id_uf_pere:6:=$idUFSis
	[UF:5]libelle:2:="GENDARMERIE"
	[UF:5]type_dept:4:="GIE"
	[UF:5]type_reglementaire:3:="INTERVENANT_EXTERNE"
	[UF:5]type_UF:8:="O"  //affectations ops
	[UF:5]Mobilisable:11:="TRUE"
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
			//Si ($cleComp#"")
			//[UF]id_uf_pere:=$cleComp
			//Sinon 
			//[UF]id_uf_pere:=$cleGpt
			//Fin de si 
			[UF:5]id_uf_pere:6:=$cleGpt
			[UF:5]libelle:2:=[IMPORT_CIS:20]Non_Corps:3
			QUERY:C277([IMPORT_TYPE:23]; [IMPORT_TYPE:23]cle_type:2=[IMPORT_CIS:20]Type_Centre:5)
			[UF:5]type_dept:4:=[IMPORT_TYPE:23]type:3
			[UF:5]type_reglementaire:3:=[IMPORT_TYPE:23]code_Ref:4
			//Si ([IMPORT_TYPE]code_Ref="GRPT")
			//[UF]id_uf_pere:=$idUFSis
			//Fin de si 
			[UF:5]type_UF:8:="O"  //affectations ops
			[UF:5]Mobilisable:11:="TRUE"
			SAVE RECORD:C53([UF:5])
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
			[UF:5]type_reglementaire:3:="G"
			[UF:5]type_UF:8:="O"
			[UF:5]Mobilisable:11:="TRUE"
			SAVE RECORD:C53([UF:5])
		End if 
	End if 
	
	
	
	NEXT RECORD:C51([IMPORT_INDIVIDUS:17])
End while 

CLOSE DOCUMENT:C267($doc)



QUERY:C277([IMPORT_CIS:20]; [IMPORT_CIS:20]toDelete:9=True:C214)
DELETE SELECTION:C66([IMPORT_CIS:20])

QUERY:C277([IMPORT_GPT:22]; [IMPORT_GPT:22]toDelete:5=True:C214)
DELETE SELECTION:C66([IMPORT_GPT:22])

//correction des id_uf_pere
QUERY BY FORMULA:C48([UF:5]; Length:C16([UF:5]id_uf_pere:6)>5)  // a priori seuls les id antibia sont plus longs que 5
SELECTION TO ARRAY:C260([UF:5]id_uf:5; $Tiduf; [UF:5]id_uf_pere:6; $TIDPere)
ARRAY TEXT:C222($TNewIDPere; Size of array:C274($TIDPere))
For ($i; 1; Size of array:C274($TIDPere))
	QUERY:C277([UF:5]; [UF:5]code_Antibia:7=$TIDPere{$i})
	$TNewIDPere{$i}:=[UF:5]id_uf:5
End for 
For ($i; 1; Size of array:C274($Tiduf))
	QUERY:C277([UF:5]; [UF:5]id_uf:5=$Tiduf{$i})
	[UF:5]id_uf_pere:6:=$TNewIDPere{$i}
	SAVE RECORD:C53([UF:5])
End for 



