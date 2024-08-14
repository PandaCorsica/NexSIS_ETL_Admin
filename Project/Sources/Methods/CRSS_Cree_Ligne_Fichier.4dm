//%attributes = {}
$ligneEngin:=$1
$lignePersonnel:=$2
$ligneDonnees:=""

If (Substring:C12([DONNEES_INTERS:158]numInter:4; 1; 5)="SIS2A")
	$numeroRef:=Substring:C12([DONNEES_INTERS:158]numInter:4; 7)
Else 
	$numeroRef:=[DONNEES_INTERS:158]numInter:4
End if 
$ligneDonnees:=Substring:C12($numeroRef; 3; 2)+"|"  // L'année sur 2 chiffres

$ligneDonnees:=$ligneDonnees+String:C10(Numero_Jour_Annee(Date:C102([DONNEES_INTERS:158]date_Debut:13)); "000")+Substring:C12($numeroRef; 10; 5)+"|"  // le numero de rapport 3 chiffres = jour annee + 5 chiffres rapport
$ligneDonnees:=$ligneDonnees+String:C10([DONNEES_INTERS:158]numeroRenfort:7; "00")+"|"
$ligneDonnees:=$ligneDonnees+"0|"  // 0 pour tester
$ligneDonnees:=$ligneDonnees+"0|"  // "0"
$ligneDonnees:=$ligneDonnees+"0|"  // 0
$ligneDonnees:=$ligneDonnees+[DONNEES_INTERS:158]Code_centre_Systel:8+"|"  // numero du centre Systel
$ligneDonnees:=$ligneDonnees+[DONNEES_INTERS:158]Libelle_UF:9+"|"  // nom de l'UF
$ligneDonnees:=$ligneDonnees+"0|"  // 0 pour tester
If (([DONNEES_INTERS:158]codePostal:11="") | ([DONNEES_INTERS:158]commune:12=""))
	$ligneDonnees:=$ligneDonnees+"20004"+"|"  // code INSEE de la commune défaut
	$ligneDonnees:=$ligneDonnees+"Ajaccio"+"|"  // nom de la commune défaut
Else 
	$ligneDonnees:=$ligneDonnees+"20"+Substring:C12([DONNEES_INTERS:158]codePostal:11; 3; 3)+"|"  // code INSEE de la commune
	$ligneDonnees:=$ligneDonnees+[DONNEES_INTERS:158]commune:12+"|"  // nom de la commune
End if 
$ligneDonnees:=$ligneDonnees+"|"
$ligneDonnees:=$ligneDonnees+"|"
$ligneDonnees:=$ligneDonnees+Substring:C12([DONNEES_INTERS:158]adresse:10; 1; 60)+"|"
$ligneDonnees:=$ligneDonnees+"|"
$ligneDonnees:=$ligneDonnees+"0|"
$ligneDonnees:=$ligneDonnees+"000|"
$ligneDonnees:=$ligneDonnees+"1|"  // on traite les CISsortis 1 par 1
$ligneDonnees:=$ligneDonnees+[DONNEES_INTERS:158]Code_centre_Systel:8+"|"

$dataToSend:=Convertit_DateHeure_ISO_vers_DD([DONNEES_INTERS:158]date_Debut:13)+"|"
$ligneDonnees:=$ligneDonnees+$dataToSend
$ligneDonnees:=$ligneDonnees+$dataToSend
$dataToSend:="00/00/0000 00:00:00"+"|"
$ligneDonnees:=$ligneDonnees+$dataToSend
$ligneDonnees:=$ligneDonnees+$dataToSend
$ligneDonnees:=$ligneDonnees+$dataToSend
$dataToSend:=Convertit_DateHeure_ISO_vers_DD([DONNEES_INTERS:158]date_Fin:14)+"|"
$ligneDonnees:=$ligneDonnees+$dataToSend


$ligneDonnees:=$ligneDonnees+Code_intervention_Antibia([DONNEES_INTERS:158]code_NF:15)+"|"
$ligneDonnees:=$ligneDonnees+Convertit_Label_NF0([DONNEES_INTERS:158]code_NF:15)+"|"
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
$ligneDonnees:=$ligneDonnees+[DONNEES_INTERS:158]nom_signataire:16+"|"
$ligneDonnees:=$ligneDonnees+[DONNEES_INTERS:158]prenom_signataire:17

$0:=$ligneDonnees

