//%attributes = {}
ALL RECORDS:C47([PIQUETS:9])
DELETE SELECTION:C66([PIQUETS:9])

ALL RECORDS:C47([IMPORT_MOYENS:43])
DISTINCT VALUES:C339([IMPORT_MOYENS:43]vecteur:3; $TTypes)
$idSis:="sis"

For ($i; 1; Size of array:C274($TTypes))
	If ($TTypes{$i}#"REM@")
		CREATE RECORD:C68([PIQUETS:9])
		[PIQUETS:9]code_poste:5:="CA"
		[PIQUETS:9]id_sis:2:=$idSis
		[PIQUETS:9]ordre_affichage:4:="1"
		[PIQUETS:9]type_moyen_dept:3:=$TTypes{$i}
		SAVE RECORD:C53([PIQUETS:9])
		CREATE RECORD:C68([PIQUETS:9])
		[PIQUETS:9]code_poste:5:="CO"
		[PIQUETS:9]id_sis:2:=$idSis
		[PIQUETS:9]ordre_affichage:4:="2"
		[PIQUETS:9]type_moyen_dept:3:=$TTypes{$i}
		SAVE RECORD:C53([PIQUETS:9])
	End if 
End for 




ARRAY TEXT:C222($Tengin4; 0)
APPEND TO ARRAY:C911($Tengin4; "CCFAD")
//AJOUTER À TABLEAU($Tengin4; "CCFM 2000")
//AJOUTER À TABLEAU($Tengin4; "CCFM 4000")
APPEND TO ARRAY:C911($Tengin4; "CCFM")
APPEND TO ARRAY:C911($Tengin4; "CCFS")
APPEND TO ARRAY:C911($Tengin4; "CCR")
APPEND TO ARRAY:C911($Tengin4; "FPTL")
APPEND TO ARRAY:C911($Tengin4; "FPTLSR")
APPEND TO ARRAY:C911($Tengin4; "VPI")
//AJOUTER À TABLEAU($Tengin4; "FSR")
APPEND TO ARRAY:C911($Tengin4; "VIRT")
APPEND TO ARRAY:C911($Tengin4; "VSRM")
APPEND TO ARRAY:C911($Tengin4; "VSD")
For ($i; 1; Size of array:C274($Tengin4))
	CREATE RECORD:C68([PIQUETS:9])
	[PIQUETS:9]code_poste:5:="CE"
	[PIQUETS:9]id_sis:2:=$idSis
	[PIQUETS:9]ordre_affichage:4:="3"
	[PIQUETS:9]type_moyen_dept:3:=$Tengin4{$i}
	SAVE RECORD:C53([PIQUETS:9])
	CREATE RECORD:C68([PIQUETS:9])
	[PIQUETS:9]code_poste:5:="EQ"
	[PIQUETS:9]id_sis:2:=$idSis
	[PIQUETS:9]ordre_affichage:4:="4"
	[PIQUETS:9]type_moyen_dept:3:=$Tengin4{$i}
	SAVE RECORD:C53([PIQUETS:9])
End for 


ARRAY TEXT:C222($Tengin6; 0)
APPEND TO ARRAY:C911($Tengin6; "FPT")
APPEND TO ARRAY:C911($Tengin6; "FPTSR")
For ($i; 1; Size of array:C274($Tengin6))
	CREATE RECORD:C68([PIQUETS:9])
	[PIQUETS:9]code_poste:5:="CE"
	[PIQUETS:9]id_sis:2:=$idSis
	[PIQUETS:9]ordre_affichage:4:="3"
	[PIQUETS:9]type_moyen_dept:3:=$Tengin6{$i}
	SAVE RECORD:C53([PIQUETS:9])
	CREATE RECORD:C68([PIQUETS:9])
	[PIQUETS:9]code_poste:5:="CE"
	[PIQUETS:9]id_sis:2:=$idSis
	[PIQUETS:9]ordre_affichage:4:="4"
	[PIQUETS:9]type_moyen_dept:3:=$Tengin6{$i}
	SAVE RECORD:C53([PIQUETS:9])
	CREATE RECORD:C68([PIQUETS:9])
	[PIQUETS:9]code_poste:5:="EQ"
	[PIQUETS:9]id_sis:2:=$idSis
	[PIQUETS:9]ordre_affichage:4:="5"
	[PIQUETS:9]type_moyen_dept:3:=$Tengin6{$i}
	SAVE RECORD:C53([PIQUETS:9])
	CREATE RECORD:C68([PIQUETS:9])
	[PIQUETS:9]code_poste:5:="EQ"
	[PIQUETS:9]id_sis:2:=$idSis
	[PIQUETS:9]ordre_affichage:4:="6"
	[PIQUETS:9]type_moyen_dept:3:=$Tengin6{$i}
	SAVE RECORD:C53([PIQUETS:9])
End for 

ARRAY TEXT:C222($Tengin3; 0)
APPEND TO ARRAY:C911($Tengin3; "VSAV")
APPEND TO ARRAY:C911($Tengin3; "PEVE")
APPEND TO ARRAY:C911($Tengin3; "PCC")
APPEND TO ARRAY:C911($Tengin3; "PCS")
APPEND TO ARRAY:C911($Tengin3; "CCFL")
APPEND TO ARRAY:C911($Tengin3; "VID")
For ($i; 1; Size of array:C274($Tengin3))
	CREATE RECORD:C68([PIQUETS:9])
	[PIQUETS:9]code_poste:5:="EQ"
	[PIQUETS:9]id_sis:2:=$idSis
	[PIQUETS:9]ordre_affichage:4:="3"
	[PIQUETS:9]type_moyen_dept:3:=$Tengin3{$i}
	SAVE RECORD:C53([PIQUETS:9])
End for 




