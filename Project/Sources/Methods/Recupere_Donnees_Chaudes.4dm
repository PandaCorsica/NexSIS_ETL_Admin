//%attributes = {}
If (Count parameters:C259=1)
	$date:=$1
Else 
	$date:=Current date:C33(*)
End if 
$jour:=Day of:C23($date)
$mois:=Month of:C24($date)
$annee:=Year of:C25($date)
$nomFichier:="Inters_"+String:C10($annee; "0000")+"_"+String:C10($mois; "00")+"_"+String:C10($jour; "00")+".txt"

$chemin:="C:\\SFTP\\OPS2ADM\\Inters_Jour\\"+$nomFichier
$heureActuelle:=Current time:C178(*)
If (Test path name:C476($chemin)=Est un document:K24:1) & ($heureActuelle>=?00:02:00?)  // on attend 1 mn pour être sur que le 1er fichier du jour a été créé
	vErr:=False:C215
	ON ERR CALL:C155("erreur_fichier_ouvert")
	$texte:=Document to text:C1236($chemin)
	If (vErr=False:C215)
		ARRAY OBJECT:C1221($TabInters; 0)
		JSON PARSE ARRAY:C1219($texte; $TabInters)
		
		For ($i; 1; Size of array:C274($TabInters))
			QUERY:C277([DONNEES_BRQ:182]; [DONNEES_BRQ:182]numinter:2=$TabInters{$i}.numinter)
			If (Records in selection:C76([DONNEES_BRQ:182])=0)
				CREATE RECORD:C68([DONNEES_BRQ:182])
				[DONNEES_BRQ:182]numinter:2:=$TabInters{$i}.numinter
				[DONNEES_BRQ:182]commentaire:3:=""
			End if 
			[DONNEES_BRQ:182]adresse:7:=$TabInters{$i}.adresse
			[DONNEES_BRQ:182]centres:12:=$TabInters{$i}.centres
			[DONNEES_BRQ:182]codeNF:9:=$TabInters{$i}.codeNF
			[DONNEES_BRQ:182]commune:6:=$TabInters{$i}.commune
			[DONNEES_BRQ:182]dateInter:4:=Date:C102($TabInters{$i}.date_inter)
			[DONNEES_BRQ:182]heureInter:5:=Time:C179($TabInters{$i}.heure_inter)
			[DONNEES_BRQ:182]idOperation:10:=$TabInters{$i}.idOperation
			[DONNEES_BRQ:182]motif:8:=$TabInters{$i}.motif
			[DONNEES_BRQ:182]moyens:11:=$TabInters{$i}.moyens
			[DONNEES_BRQ:182]TSDebut:13:=4DStmp_Write([DONNEES_BRQ:182]dateInter:4; [DONNEES_BRQ:182]heureInter:5)
			SAVE RECORD:C53([DONNEES_BRQ:182])
		End for 
	Else 
		vErr:=False:C215
	End if 
	ON ERR CALL:C155("")
End if 