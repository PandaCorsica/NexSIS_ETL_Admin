//%attributes = {}
$jour:=Day of:C23(Current date:C33)
$mois:=Month of:C24(Current date:C33)
$annee:=Year of:C25(Current date:C33)
$nomFichier:="BilanJour_"+String:C10($annee; "0000")+"_"+String:C10($mois; "00")+"_"+String:C10($jour; "00")+".txt"

$chemin:="C:\\SFTP\\OPS2ADM\\BRQ\\"+$nomFichier
C_OBJECT:C1216($brq)
If (Test path name:C476($chemin)=Est un document:K24:1)
	$texte:=Document to text:C1236($chemin)
	
	$brq:=JSON Parse:C1218($texte)
	
Else 
End if 
$0:=$brq