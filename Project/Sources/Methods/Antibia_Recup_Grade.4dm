//%attributes = {}
//CONFIRMER("Voulez-vous importer les grades d'Antibia ? Toutes les correspondances existantes seront effacées."; "Oui"; "Non")
//Si (OK=1)
ARRAY TEXT:C222($GRADECle; 0)
ARRAY TEXT:C222($GRADEGrade; 0)
ARRAY TEXT:C222($GRADEAbrev; 0)

//TOUT SÉLECTIONNER([IMPORT_GRADE])
//SUPPRIMER SÉLECTION([IMPORT_GRADE])
$doc:=Create document:C266(Get 4D folder:C485(Dossier base:K5:14)+"Log recup grades.txt"; "txt")

ConnexionSQL

If (OK=1)
	SQL EXECUTE:C820("SELECT CLE, GRADE, ABREV FROM Sp_grade"; $GRADECle; $GRADEGrade; $GRADEAbrev)
	SQL LOAD RECORD:C822(SQL tous les enregistrements:K49:10)
	For ($i; 1; Size of array:C274($GRADECle))
		QUERY:C277([IMPORT_GRADE:25]; [IMPORT_GRADE:25]cle:2=$GRADECle{$i})
		If (Records in selection:C76([IMPORT_GRADE:25])=0)
			SEND PACKET:C103($doc; "Nouveau grade : "+$GRADEAbrev{$i}+Char:C90(Retour à la ligne:K15:40))
			CREATE RECORD:C68([IMPORT_GRADE:25])
			[IMPORT_GRADE:25]cle:2:=$GRADECle{$i}
			[IMPORT_GRADE:25]libelle:3:=$GRADEGrade{$i}
			[IMPORT_GRADE:25]abrege:4:=$GRADEAbrev{$i}
			[IMPORT_GRADE:25]code_Ref:5:=""
			SAVE RECORD:C53([IMPORT_GRADE:25])
		End if 
	End for 
	SQL LOGOUT:C872
	
	
End if 
CLOSE DOCUMENT:C267($doc)
//Fin de si 