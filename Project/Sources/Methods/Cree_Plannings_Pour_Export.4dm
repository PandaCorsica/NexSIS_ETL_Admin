//%attributes = {}
$annee:=$1
$mois:=$2
QUERY:C277([PLANNINGS:156]; [PLANNINGS:156]Mois:14=$mois; *)
QUERY:C277([PLANNINGS:156]; [PLANNINGS:156]Annee:13=$annee)
DELETE SELECTION:C66([PLANNINGS:156])

QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]mois:43=$mois; *)
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]annee:42=$annee; *)
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]a_Filtrer:45=False:C215; *)
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]code_position_administrative:36#""; *)
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]traite:44=False:C215)

//non prise en compte des plannings des pelicandromes, commandos et HBE
QUERY SELECTION:C341([fdg_service_fait:124]; [fdg_service_fait:124]code_unite_fonctionnelle:10#"02a-CDO"; *)
QUERY SELECTION:C341([fdg_service_fait:124]; [fdg_service_fait:124]code_unite_fonctionnelle:10#"02a-HBE"; *)
QUERY SELECTION:C341([fdg_service_fait:124]; [fdg_service_fait:124]code_unite_fonctionnelle:10#"02a-PAJA"; *)
QUERY SELECTION:C341([fdg_service_fait:124]; [fdg_service_fait:124]code_unite_fonctionnelle:10#"02a-PFIG")


While (Not:C34(End selection:C36([fdg_service_fait:124])))
	CREATE RECORD:C68([PLANNINGS:156])
	If ([fdg_service_fait:124]code_statut_rh:9="SPV")
		[PLANNINGS:156]Categorie:2:="V"
		$typeActivite:=[fdg_service_fait:124]code_position_administrative:36
		//Si ($typeActivite="") & ([fdg_service_fait]disponibilite_temporelle="DISPONIBLE_0")
		//$typeActivite:="G"
		//Fin de si 
	Else 
		[PLANNINGS:156]Categorie:2:="P"
		$typeActivite:="SPP"
	End if 
	$pos:=Position:C15("-"; [fdg_service_fait:124]code_unite_fonctionnelle:10)
	$codeCentre:=Substring:C12([fdg_service_fait:124]code_unite_fonctionnelle:10; $pos+1)
	QUERY:C277([CODES_UF:157]; [CODES_UF:157]idUF:2=$codeCentre)
	[PLANNINGS:156]Code_Centre:3:=[CODES_UF:157]code:3
	If ($codeCentre="CCS") & (([fdg_service_fait:124]code_position_administrative:36="G") | ([fdg_service_fait:124]code_position_administrative:36="GCO") | ([fdg_service_fait:124]code_position_administrative:36="GR"))
		[PLANNINGS:156]Type_Activite:11:="GCO"
	Else 
		[PLANNINGS:156]Type_Activite:11:=$typeActivite  //[fdg_service_fait]code_position_administrative
	End if 
	If ([PLANNINGS:156]Categorie:2="P")
		[PLANNINGS:156]Type_Activite:11:="SPP"
	End if 
	[PLANNINGS:156]Traite:4:=False:C215
	[PLANNINGS:156]Matricule:5:=[fdg_service_fait:124]matricule_agent:5
	[PLANNINGS:156]Remarques:7:=""
	[PLANNINGS:156]Repas:8:=False:C215
	[PLANNINGS:156]Jour_Debut:9:=Date:C102([fdg_service_fait:124]date_debut:12)
	//[PLANNINGS]Heure_Debut:=Heure([fdg_service_fait]date_debut)
	[PLANNINGS:156]Heure_Debut:10:=OB Get:C1224(Correctif_changement_heure([fdg_service_fait:124]date_debut:12); "heure")
	[PLANNINGS:156]Jour_Fin:15:=Date:C102([fdg_service_fait:124]date_fin:13)
	//[PLANNINGS]Heure_Fin:=Heure([fdg_service_fait]date_fin)
	[PLANNINGS:156]Heure_Fin:16:=OB Get:C1224(Correctif_changement_heure([fdg_service_fait:124]date_fin:13); "heure")
	[PLANNINGS:156]Duree:12:=(4DStmp_Write([PLANNINGS:156]Jour_Fin:15; [PLANNINGS:156]Heure_Fin:16)-4DStmp_Write([PLANNINGS:156]Jour_Debut:9; [PLANNINGS:156]Heure_Debut:10))/3600
	[PLANNINGS:156]Nb_Repas:6:=Calcule_Nb_Repas($typeActivite; [CODES_UF:157]idUF:2; 4DStmp_Write([PLANNINGS:156]Jour_Debut:9; [PLANNINGS:156]Heure_Debut:10); 4DStmp_Write([PLANNINGS:156]Jour_Fin:15; [PLANNINGS:156]Heure_Fin:16))
	[PLANNINGS:156]Annee:13:=$annee
	[PLANNINGS:156]Mois:14:=$mois
	[PLANNINGS:156]TSDebut:17:=4DStmp_Write([PLANNINGS:156]Jour_Debut:9; [PLANNINGS:156]Heure_Debut:10)
	[PLANNINGS:156]TSFin:18:=4DStmp_Write([PLANNINGS:156]Jour_Fin:15; [PLANNINGS:156]Heure_Fin:16)
	SAVE RECORD:C53([PLANNINGS:156])
	NEXT RECORD:C51([fdg_service_fait:124])
End while 

Genere_Repas($annee; $mois)
// il faut vérifier si les types de garde rentrées sont cohérents : pas de GR aux endroits où il ne doit y avoir que du G, pas de RG de 12h
// pour les endroits ou il ne dois pas avoir de GR, c'est un controle manuel
// pour les renforts garde :
QUERY:C277([PLANNINGS:156]; [PLANNINGS:156]Duree:12=12; *)
QUERY:C277([PLANNINGS:156]; [PLANNINGS:156]Type_Activite:11="RG")
APPLY TO SELECTION:C70([PLANNINGS:156]; [PLANNINGS:156]Type_Activite:11:="GR")  // ce n'ets pas un renfort garde mais une garde réduite
Cree_Fichier_ANO($annee; $mois)


