//%attributes = {}
$annee:=$1
$mois:=$2
QUERY:C277([PLANNINGS:156]; [PLANNINGS:156]Mois:14=$mois; *)
QUERY:C277([PLANNINGS:156]; [PLANNINGS:156]Annee:13=$annee; *)
//CHERCHER([PLANNINGS]; [PLANNINGS]Code_Centre#6; *)  // non prise en compte du centre d'Ajaccio pour le mois de janvier et fevrier
QUERY:C277([PLANNINGS:156]; [PLANNINGS:156]Categorie:2#"P")

$debut:=Date:C102("01/"+String:C10($mois; "00")+"/"+String:C10($annee; "0000"))

$nomDossier:=String:C10($annee)+"_"+String:C10($mois)
$dossier_ANO:="ANO"
If (Not:C34(Test path name:C476(Get 4D folder:C485(Dossier Resources courant:K5:16)+"ANO")=Est un dossier:K24:2))
	$result:=Folder:C1567("/RESOURCES/"+$dossier_ANO).create()
End if 
If (Not:C34(Test path name:C476(Get 4D folder:C485(Dossier Resources courant:K5:16)+"ANO"+Séparateur dossier:K24:12+$nomDossier)=Est un dossier:K24:2))
	$result:=Folder:C1567("/RESOURCES/"+$dossier_ANO+"/"+$nomDossier).create()
End if 
// creation du fichier ANO Antibia
$nomANO_Generique:=Substring:C12(String:C10(Year of:C25(Current date:C33); "0000"); 3; 2)+String:C10(Month of:C24(Current date:C33); "00")+String:C10(Day of:C23(Current date:C33); "00")
$ordre:=0
Repeat 
	$ordre:=$ordre+1
	$nomANO_Antibia:=$nomANO_Generique+String:C10($ordre; "00")+".act"
Until (Not:C34(Test path name:C476(Get 4D folder:C485(Dossier Resources courant:K5:16)+$dossier_ANO+Séparateur dossier:K24:12+$nomDossier+Séparateur dossier:K24:12+$nomANO_Antibia)=Est un document:K24:1))
$docANO_Antibia:=Create document:C266(Get 4D folder:C485(Dossier Resources courant:K5:16)+$dossier_ANO+Séparateur dossier:K24:12+$nomDossier+Séparateur dossier:K24:12+$nomANO_Antibia)

ORDER BY:C49([PLANNINGS:156]; [PLANNINGS:156]Matricule:5; >; [PLANNINGS:156]Jour_Debut:9; >; [PLANNINGS:156]Heure_Debut:10; >)
While (Not:C34(End selection:C36([PLANNINGS:156])))
	SEND PACKET:C103($docANO_Antibia; [PLANNINGS:156]Matricule:5+"|")
	SEND PACKET:C103($docANO_Antibia; "V"+"|")  // on force le statut à volontaire
	SEND PACKET:C103($docANO_Antibia; "1"+"|")
	SEND PACKET:C103($docANO_Antibia; "|")
	QUERY:C277([CODES_UF:157]; [CODES_UF:157]code:3=[PLANNINGS:156]Code_Centre:3)
	SEND PACKET:C103($docANO_Antibia; String:C10([CODES_UF:157]Systel:4)+"|")
	$typeActivite:=""
	Case of 
		: ([PLANNINGS:156]Type_Activite:11="G")
			$typeActivite:="G24"
		: ([PLANNINGS:156]Type_Activite:11="SMO")
			$typeActivite:="G24"
		: ([PLANNINGS:156]Type_Activite:11="PLG")
			$typeActivite:="G12"
		: ([PLANNINGS:156]Type_Activite:11="STAT")
			$typeActivite:="STD"
		: ([PLANNINGS:156]Type_Activite:11="GR")
			$typeActivite:="G12"
		: ([PLANNINGS:156]Type_Activite:11="RG")
			$typeActivite:="R"
		: ([PLANNINGS:156]Type_Activite:11="GIFF")
			$typeActivite:="RT1"
		: ([PLANNINGS:156]Type_Activite:11="FDF")
			If ([PLANNINGS:156]Heure_Fin:16>?19:00:00?)
				$typeActivite:="FF2"
			Else 
				$typeActivite:="FF1"
			End if 
		: ([PLANNINGS:156]Type_Activite:11="A")
			$typeActivite:="A"
		: ([PLANNINGS:156]Type_Activite:11="GCO")
			$typeActivite:="CC"
		: ([PLANNINGS:156]Type_Activite:11="REPAS")
			$typeActivite:="REPAS"
			
	End case 
	SEND PACKET:C103($docANO_Antibia; $typeActivite+"|")
	If ([PLANNINGS:156]Repas:8=False:C215)
		$jourdebut:=String:C10([PLANNINGS:156]Jour_Debut:9; Interne date court:K1:7)
		$heuredebut:=String:C10([PLANNINGS:156]Heure_Debut:10; h mn:K7:2)+":00"
		$jourfin:=String:C10([PLANNINGS:156]Jour_Fin:15; Interne date court:K1:7)
		$heurefin:=String:C10([PLANNINGS:156]Heure_Fin:16; h mn:K7:2)+":00"
		SEND PACKET:C103($docANO_Antibia; $jourdebut+" "+$heuredebut+"|")
		SEND PACKET:C103($docANO_Antibia; $jourfin+" "+$heurefin+"|")
	Else 
		SEND PACKET:C103($docANO_Antibia; String:C10($debut; Interne date court:K1:7)+" 00:00:"+String:C10([PLANNINGS:156]Code_Centre:3; "00")+"|")
		SEND PACKET:C103($docANO_Antibia; String:C10($debut; Interne date court:K1:7)+" 00:00:"+String:C10([PLANNINGS:156]Code_Centre:3+1; "00")+"|")
	End if 
	SEND PACKET:C103($docANO_Antibia; "N"+"|")
	SEND PACKET:C103($docANO_Antibia; "|")
	If ([PLANNINGS:156]Repas:8=False:C215)
		SEND PACKET:C103($docANO_Antibia; "|")
		$remarque:=[PLANNINGS:156]Remarques:7
	Else 
		$totalRepas:=[PLANNINGS:156]Nb_Repas:6*6.05
		SEND PACKET:C103($docANO_Antibia; String:C10($totalRepas)+"|")
		$remarque:=String:C10([PLANNINGS:156]Nb_Repas:6)+" repas indemnises"
	End if 
	SEND PACKET:C103($docANO_Antibia; $remarque+Char:C90(Retour chariot:K15:38)+Char:C90(Retour à la ligne:K15:40))
	
	NEXT RECORD:C51([PLANNINGS:156])
End while 

CLOSE DOCUMENT:C267($docANO_Antibia)

