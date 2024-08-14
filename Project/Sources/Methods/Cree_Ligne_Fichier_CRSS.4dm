//%attributes = {}
// on récupère des infos générales
QUERY:C277([sgo_operation:110]; [sgo_operation:110]id_operation:2=[crss_validation:154]id_operation:2)
QUERY:C277([sgo_localisation:95]; [sgo_localisation:95]id_operation:10=[sgo_operation:110]id_operation:2)
QUERY:C277([sga_create_affaire:134]; [sga_create_affaire:134]numero_affaire:2=[sgo_operation:110]id_affaire:10)
QUERY:C277([sga_traitement:120]; [sga_traitement:120]numero_alerte:11=[sga_create_affaire:134]id_alerte_initiale:9)
If ([sga_traitement:120]nature_de_fait_0_code:13="")
	
End if 
QUERY:C277([sgo_localisation:95]; [sgo_localisation:95]id_operation:10=[sgo_operation:110]id_operation:2)
QUERY:C277([CENTRES_SYSTEL:42]; [CENTRES_SYSTEL:42]CodeAlpha:5=Substring:C12([crss_validation:154]unite_fonctionnelle:8; 5))
QUERY:C277([UF:5]; [UF:5]id_uf:5=[CENTRES_SYSTEL:42]CodeAlpha:5)
//CHERCHER([sga_localisation]; [sga_localisation]numero_alerte=[sga_traitement]numero_alerte)
$ligneEngin:=$1
$lignePersonnel:=$2
$numeroRapport:=$3
$ligneDonnees:=""

$erreur:=Teste_Validite_Donnees_CRSS($numeroRapport)

If ($erreur="")  // s'il n'y a pas d'erreurs
	If (Substring:C12([sgo_operation:110]numero:3; 1; 5)="SIS2A")
		$numeroRef:=Substring:C12([sgo_operation:110]numero:3; 7)
	Else 
		$numeroRef:=[sgo_operation:110]numero:3
	End if 
	$ligneDonnees:=Substring:C12($numeroRef; 3; 2)+"|"  // L'année sur 2 chiffres
	
	$ligneDonnees:=$ligneDonnees+String:C10(Numero_Jour_Annee(Date:C102([sgo_operation:110]date_reception:15)); "000")+Substring:C12($numeroRef; 10; 5)+"|"  // le numero de rapport 3 chiffres = jour annee + 5 chiffres rapport
	$ligneDonnees:=$ligneDonnees+String:C10([crss_validation:154]num_renfort:22; "00")+"|"
	$ligneDonnees:=$ligneDonnees+"0|"  // 0 pour tester
	$ligneDonnees:=$ligneDonnees+"0|"  // "0"
	$ligneDonnees:=$ligneDonnees+"0|"  // 0
	$codeCentre:=[CENTRES_SYSTEL:42]Code:2+"|"  // numero du centre Systel
	$ligneDonnees:=$ligneDonnees+[CENTRES_SYSTEL:42]Code:2+"|"
	$ligneDonnees:=$ligneDonnees+[UF:5]libelle:2+"|"  // nom de l'UF
	$ligneDonnees:=$ligneDonnees+"0|"  // 0 pour tester
	$ligneDonnees:=$ligneDonnees+"20"+Substring:C12([sgo_localisation:95]code_insee:8; 3; 3)+"|"  // code INSEE de la commune
	$ligneDonnees:=$ligneDonnees+[sgo_localisation:95]commune:7+"|"  // nom de la commune
	$ligneDonnees:=$ligneDonnees+"|"
	$ligneDonnees:=$ligneDonnees+"|"
	$ligneDonnees:=$ligneDonnees+"|"
	$ligneDonnees:=$ligneDonnees+"|"
	$ligneDonnees:=$ligneDonnees+"0|"
	$ligneDonnees:=$ligneDonnees+"000|"
	$ligneDonnees:=$ligneDonnees+"1|"  // on traite les CISsortis 1 par 1
	$ligneDonnees:=$ligneDonnees+$codeCentre
	
	$dataToSend:=Convertit_DateHeure_ISO_vers_DD([sgo_operation:110]date_reception:15)+"|"
	$ligneDonnees:=$ligneDonnees+$dataToSend
	$dataToSend:="00/00/0000 00:00:00"+"|"
	$ligneDonnees:=$ligneDonnees+$dataToSend
	$ligneDonnees:=$ligneDonnees+$dataToSend
	$ligneDonnees:=$ligneDonnees+$dataToSend
	$ligneDonnees:=$ligneDonnees+$dataToSend
	$dataToSend:=Convertit_DateHeure_ISO_vers_DD([sgo_operation:110]date_fin:5)+"|"
	$ligneDonnees:=$ligneDonnees+$dataToSend
	
	
	$ligneDonnees:=$ligneDonnees+Code_intervention_Antibia([sga_traitement:120]nature_de_fait_0_code:13)+"|"
	$ligneDonnees:=$ligneDonnees+Convertit_Label_NF0([sga_traitement:120]nature_de_fait_0_code:13)+"|"
	$ligneDonnees:=$ligneDonnees+"|"
	$ligneDonnees:=$ligneDonnees+"|"
	$ligneDonnees:=$ligneDonnees+"|"
	$ligneDonnees:=$ligneDonnees+"|"
	$ligneDonnees:=$ligneDonnees+"|"
	$ligneDonnees:=$ligneDonnees+"|"
	$ligneDonnees:=$ligneDonnees+"0|"
	$ligneDonnees:=$ligneDonnees+"0|"
	
	$ligneDonnees:=$ligneDonnees+"|"
	$ligneDonnees:=$ligneDonnees+"|"
	$ligneDonnees:=$ligneDonnees+"|"
	$ligneDonnees:=$ligneDonnees+"|"
	$ligneDonnees:=$ligneDonnees+"|"
	$ligneDonnees:=$ligneDonnees+"0|"
	
	$ligneDonnees:=$ligneDonnees+"|"
	$ligneDonnees:=$ligneDonnees+"|"
	$ligneDonnees:=$ligneDonnees+"00/00/0000|"
	$ligneDonnees:=$ligneDonnees+"|"
	$ligneDonnees:=$ligneDonnees+"|"
	$ligneDonnees:=$ligneDonnees+"|"
	$ligneDonnees:=$ligneDonnees+"|"
	$ligneDonnees:=$ligneDonnees+"|"
	$ligneDonnees:=$ligneDonnees+"|"
	$ligneDonnees:=$ligneDonnees+"0|"
	$ligneDonnees:=$ligneDonnees+"|"
	
	
	$ligneDonnees:=$ligneDonnees+$ligneEngin
	$ligneDonnees:=$ligneDonnees+$lignePersonnel
	
	
	$ligneDonnees:=$ligneDonnees+"0|"  // releves
	
	$ligneDonnees:=$ligneDonnees+"00/00/0000 00:00:00|"
	$ligneDonnees:=$ligneDonnees+"00/00/0000 00:00:00|"
	$ligneDonnees:=$ligneDonnees+"00/00/0000 00:00:00|"
	$ligneDonnees:=$ligneDonnees+"00/00/0000 00:00:00|"
	
	$ligneDonnees:=$ligneDonnees+"0|"  // sinistres
	
	$ligneDonnees:=$ligneDonnees+"|"
	$ligneDonnees:=$ligneDonnees+"|"
	$ligneDonnees:=$ligneDonnees+"|"
	$ligneDonnees:=$ligneDonnees+"|"
	$ligneDonnees:=$ligneDonnees+"|"
	$ligneDonnees:=$ligneDonnees+"|"
	$ligneDonnees:=$ligneDonnees+"|"
	
	$ligneDonnees:=$ligneDonnees+"0|"  //personnalites
	
	$ligneDonnees:=$ligneDonnees+"0|"  //lignes Compte rendu
	
	$ligneDonnees:=$ligneDonnees+"|"
	$ligneDonnees:=$ligneDonnees+[crss_validation:154]nom_autorite_signataire:5+"|"
	$ligneDonnees:=$ligneDonnees+[crss_validation:154]prenom_autorite_signataire:6
	
	CREATE RECORD:C68([DONNEES_INTERS:158])
	[DONNEES_INTERS:158]codeUF:3:=[crss_validation:154]unite_fonctionnelle:8
	[DONNEES_INTERS:158]ligne:2:=$ligneDonnees
	[DONNEES_INTERS:158]numInter:4:=[crss_validation:154]numero_operation:21
	[DONNEES_INTERS:158]traite:5:=False:C215
	[DONNEES_INTERS:158]date_CRSS:6:=Date:C102([sgo_operation:110]date_creation:4)
	SAVE RECORD:C53([DONNEES_INTERS:158])
	
End if 