//%attributes = {}
// on récupère des infos générales
QUERY:C277([sgo_operation:110]; [sgo_operation:110]id_operation:2=[crss_validation:154]id_operation:2)
QUERY:C277([sgo_localisation:95]; [sgo_localisation:95]id_operation:10=[sgo_operation:110]id_operation:2)
QUERY:C277([sga_create_affaire:134]; [sga_create_affaire:134]numero_affaire:2=[sgo_operation:110]id_affaire:10)
QUERY:C277([sga_traitement:120]; [sga_traitement:120]numero_alerte:11=[sga_create_affaire:134]id_alerte_initiale:9)
//bug NexSIS qui ne renvoie pas les données de certaines interventions dont le 3/1/2024
$differe:=False:C215
If (Records in selection:C76([sgo_operation:110])=0)
	If (Substring:C12([crss_validation:154]numero_operation:21; 1; 5)="SIS2A")
		$refDate:=Substring:C12([crss_validation:154]numero_operation:21; 7)
	Else 
		$refDate:=[crss_validation:154]numero_operation:21
	End if 
	//précédement on mettait une date mais il faut maintenant que la correction soit faite pour avoir les bonnes informations
	$dateCRSS:=Date:C102(Substring:C12($refDate; 7; 2)+"/"+Substring:C12($refDate; 5; 2)+"/"+Substring:C12($refDate; 1; 4))
	//$dateCRSS:=!00/00/0000!
	//$differe:=Vrai
Else 
	$dateCRSS:=Date:C102([sgo_operation:110]date_creation:4)
End if 
If (Not:C34($differe))
	QUERY:C277([CENTRES_SYSTEL:42]; [CENTRES_SYSTEL:42]CodeAlpha:5=Substring:C12([crss_validation:154]unite_fonctionnelle:8; 5))
	QUERY:C277([UF:5]; [UF:5]id_uf:5=[CENTRES_SYSTEL:42]CodeAlpha:5)
	
	QUERY:C277([DONNEES_INTERS:158]; [DONNEES_INTERS:158]codeUF:3=[crss_validation:154]unite_fonctionnelle:8; *)
	QUERY:C277([DONNEES_INTERS:158]; [DONNEES_INTERS:158]numInter:4=[crss_validation:154]numero_operation:21)
	If (Records in selection:C76([DONNEES_INTERS:158])=0)  // si cette inter a déjà été traitée, on va l'archiver ainsi que ses engins et personnels associés
		[DONNEES_INTERS:158]Archivage:19:=True:C214
		SAVE RECORD:C53([DONNEES_INTERS:158])
		QUERY:C277([PARTICIPATION_AGENT:163]; [PARTICIPATION_AGENT:163]ID_Donnees_Inter:17=[DONNEES_INTERS:158]ID:1)
		APPLY TO SELECTION:C70([PARTICIPATION_AGENT:163]; [PARTICIPATION_AGENT:163]Archivage:20:=True:C214)
		QUERY:C277([PARTICIPATION_ENGIN:164]; [PARTICIPATION_ENGIN:164]ID_Donnees_Inter:13=[DONNEES_INTERS:158]ID:1)
		APPLY TO SELECTION:C70([PARTICIPATION_ENGIN:164]; [PARTICIPATION_ENGIN:164]Archivage:15:=True:C214)
	End if 
	CREATE RECORD:C68([DONNEES_INTERS:158])
	[DONNEES_INTERS:158]codeUF:3:=[crss_validation:154]unite_fonctionnelle:8
	[DONNEES_INTERS:158]ligne:2:=""
	[DONNEES_INTERS:158]numInter:4:=[crss_validation:154]numero_operation:21
	[DONNEES_INTERS:158]traite:5:=False:C215
	[DONNEES_INTERS:158]date_CRSS:6:=$dateCRSS
	[DONNEES_INTERS:158]adresse:10:=[sgo_localisation:95]denomination_voie:9
	[DONNEES_INTERS:158]Code_centre_Systel:8:=[CENTRES_SYSTEL:42]Code:2
	[DONNEES_INTERS:158]code_NF:15:=[sga_traitement:120]nature_de_fait_0_code:13
	[DONNEES_INTERS:158]codePostal:11:=[sgo_localisation:95]code_insee:8
	[DONNEES_INTERS:158]commune:12:=[sgo_localisation:95]commune:7
	[DONNEES_INTERS:158]date_Debut:13:=[sgo_operation:110]date_reception:15
	[DONNEES_INTERS:158]date_Fin:14:=[sgo_operation:110]date_fin:5
	[DONNEES_INTERS:158]Libelle_UF:9:=[UF:5]libelle:2
	[DONNEES_INTERS:158]nom_signataire:16:=[crss_validation:154]nom_autorite_signataire:5
	[DONNEES_INTERS:158]numeroRenfort:7:=1
	[DONNEES_INTERS:158]prenom_signataire:17:=[crss_validation:154]prenom_autorite_signataire:6
	[DONNEES_INTERS:158]ID_CRSS_Validation:18:=[crss_validation:154]id:1
	SAVE RECORD:C53([DONNEES_INTERS:158])
End if 
//$0:=Chaîne(Année de($dateCRSS); "0000")+Chaîne(Mois de($dateCRSS); "00")+Chaîne(Jour de($dateCRSS); "00")
$0:=Date:C102(String:C10(Day of:C23($dateCRSS); "00")+"/"+String:C10(Month of:C24($dateCRSS); "00")+"/"+String:C10(Year of:C25($dateCRSS); "0000"))