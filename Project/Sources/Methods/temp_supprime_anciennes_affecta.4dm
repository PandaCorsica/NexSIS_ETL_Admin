//%attributes = {}
$doc:=$1
$erreur:=False:C215
// pour éviter le bug d'archivage de SP qui sont dans d'autres départements, on va supprimer les carrières qui sont finies depuis longtemps
// cette fermeture a déjà été effectuée par les traitements effectués depuis le début 2024
QUERY:C277([AFFECTATIONS:3]; [AFFECTATIONS:3]date_fin:7#"")
QUERY SELECTION BY FORMULA:C207([AFFECTATIONS:3]; Num:C11(Substring:C12([AFFECTATIONS:3]date_fin:7; 1; 4))<2024)
If (Records in selection:C76([AFFECTATIONS:3])#0)
	SEND PACKET:C103($doc; "Affectations supprimées :"+Char:C90(Retour à la ligne:K15:40))
	While (Not:C34(End selection:C36([AFFECTATIONS:3])))
		SEND PACKET:C103($doc; [AFFECTATIONS:3]id_affectation:2+Char:C90(Retour à la ligne:K15:40))
		NEXT RECORD:C51([AFFECTATIONS:3])
	End while 
	$erreur:=True:C214
End if 
DELETE SELECTION:C66([AFFECTATIONS:3])
$0:=$erreur
