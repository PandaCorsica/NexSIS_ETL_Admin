//%attributes = {}
C_DATE:C307($1; $2; $dateDeb; $dateFin)
C_TEXT:C284($3; vcommentaire)

$dateDebut:=$1
$dateFin:=$2
vcommentaire:=$3


//$dateDebut:=!21/06/2024!
//$dateFin:=!22/06/2024!
vTitre:="Bulletin de renseignements quotidien"+Char:C90(Retour à la ligne:K15:40)
vTitre:=vTitre+"du "+String:C10($dateFin; Interne date court:K1:7)+Char:C90(Retour à la ligne:K15:40)
vTitre2:="(Interventions du "+String:C10($dateDebut; Interne date court:K1:7)+" à 6h30 au "+String:C10($dateFin; Interne date court:K1:7)+" à 6h30)"
//vcommentaire:="Essai de commentaire"+Caractère(Retour à la ligne)
//vcommentaire:=vcommentaire+"Essai de commentaire2"+Caractère(Retour à la ligne)
//vcommentaire:=vcommentaire+"Essai de commentaire3"+Caractère(Retour à la ligne)
//vcommentaire:=vcommentaire+"Essai de commentaire4"+Caractère(Retour à la ligne)
//vcommentaire:=vcommentaire+"Essai de commentaire5"+Caractère(Retour à la ligne)


//FIXER APERÇU IMPRESSION(Vrai)
vCumuls:=New object:C1471
C_TIME:C306($heureDebut; $heureFin)
$heureDebut:=?06:30:00?
$heureFin:=?06:30:00?

// on recherche les cumuls annuels
$TSDebut:=4DStmp_Write(Date:C102("01/01/"+String:C10(Year of:C25($dateDebut))); ?06:30:00?)
$TSFin:=4DStmp_Write($dateFin; $heureFin)
QUERY:C277([DONNEES_BRQ:182]; [DONNEES_BRQ:182]TSDebut:13>=$TSDebut; *)
QUERY:C277([DONNEES_BRQ:182]; [DONNEES_BRQ:182]TSDebut:13<$TSFin; *)
QUERY:C277([DONNEES_BRQ:182]; [DONNEES_BRQ:182]codeNF:9#"OPHS@")
CREATE SET:C116([DONNEES_BRQ:182]; "selection")
vCumuls.totalan:=String:C10(Records in selection:C76([DONNEES_BRQ:182]))
QUERY SELECTION:C341([DONNEES_BRQ:182]; [DONNEES_BRQ:182]codeNF:9="C02@")
vCumuls.sapan:=String:C10(Records in selection:C76([DONNEES_BRQ:182]))
USE SET:C118("selection")
QUERY SELECTION:C341([DONNEES_BRQ:182]; [DONNEES_BRQ:182]codeNF:9="C01@")
vCumuls.avpan:=String:C10(Records in selection:C76([DONNEES_BRQ:182]))
USE SET:C118("selection")
QUERY SELECTION:C341([DONNEES_BRQ:182]; [DONNEES_BRQ:182]codeNF:9="C04@")
vCumuls.incan:=String:C10(Records in selection:C76([DONNEES_BRQ:182]))
QUERY SELECTION:C341([DONNEES_BRQ:182]; [DONNEES_BRQ:182]codeNF:9="C04.05@")
vCumuls.incffan:=String:C10(Records in selection:C76([DONNEES_BRQ:182]))
USE SET:C118("selection")
QUERY SELECTION:C341([DONNEES_BRQ:182]; [DONNEES_BRQ:182]codeNF:9="C05@")
vCumuls.exploan:=String:C10(Records in selection:C76([DONNEES_BRQ:182]))
USE SET:C118("selection")
QUERY SELECTION:C341([DONNEES_BRQ:182]; [DONNEES_BRQ:182]codeNF:9="C09@")
vCumuls.rtan:=String:C10(Records in selection:C76([DONNEES_BRQ:182]))
USE SET:C118("selection")
QUERY SELECTION:C341([DONNEES_BRQ:182]; [DONNEES_BRQ:182]codeNF:9="C08@")
vCumuls.rnan:=String:C10(Records in selection:C76([DONNEES_BRQ:182]))
USE SET:C118("selection")
QUERY SELECTION:C341([DONNEES_BRQ:182]; [DONNEES_BRQ:182]codeNF:9="C03@")
vCumuls.biensan:=String:C10(Records in selection:C76([DONNEES_BRQ:182]))
USE SET:C118("selection")
QUERY SELECTION:C341([DONNEES_BRQ:182]; [DONNEES_BRQ:182]codeNF:9="C07@"; *)
QUERY SELECTION:C341([DONNEES_BRQ:182];  | ; [DONNEES_BRQ:182]codeNF:9="C06@")
vCumuls.policean:=String:C10(Records in selection:C76([DONNEES_BRQ:182]))
USE SET:C118("selection")
QUERY SELECTION:C341([DONNEES_BRQ:182]; [DONNEES_BRQ:182]codeNF:9="C10@")
vCumuls.rechan:=String:C10(Records in selection:C76([DONNEES_BRQ:182]))
USE SET:C118("selection")
QUERY SELECTION:C341([DONNEES_BRQ:182]; [DONNEES_BRQ:182]codeNF:9="C11@")
vCumuls.divan:=String:C10(Records in selection:C76([DONNEES_BRQ:182]))
CLEAR SET:C117("selection")
// on recherche les cmuls journaliers
$TSDebut:=4DStmp_Write($dateDebut; $heureDebut)
$TSFin:=4DStmp_Write($dateFin; $heureFin)
QUERY:C277([DONNEES_BRQ:182]; [DONNEES_BRQ:182]TSDebut:13>=$TSDebut; *)
QUERY:C277([DONNEES_BRQ:182]; [DONNEES_BRQ:182]TSDebut:13<$TSFin; *)
QUERY:C277([DONNEES_BRQ:182]; [DONNEES_BRQ:182]codeNF:9#"OPHS@")

CREATE SET:C116([DONNEES_BRQ:182]; "selection")
vCumuls.totaljour:=String:C10(Records in selection:C76([DONNEES_BRQ:182]))
QUERY SELECTION:C341([DONNEES_BRQ:182]; [DONNEES_BRQ:182]codeNF:9="C02@")
vCumuls.sapjour:=String:C10(Records in selection:C76([DONNEES_BRQ:182]))
USE SET:C118("selection")
QUERY SELECTION:C341([DONNEES_BRQ:182]; [DONNEES_BRQ:182]codeNF:9="C01@")
vCumuls.avpjour:=String:C10(Records in selection:C76([DONNEES_BRQ:182]))
USE SET:C118("selection")
QUERY SELECTION:C341([DONNEES_BRQ:182]; [DONNEES_BRQ:182]codeNF:9="C04@")
vCumuls.incjour:=String:C10(Records in selection:C76([DONNEES_BRQ:182]))
QUERY SELECTION:C341([DONNEES_BRQ:182]; [DONNEES_BRQ:182]codeNF:9="C04.05@")
vCumuls.incffjour:=String:C10(Records in selection:C76([DONNEES_BRQ:182]))
USE SET:C118("selection")
QUERY SELECTION:C341([DONNEES_BRQ:182]; [DONNEES_BRQ:182]codeNF:9="C05@")
vCumuls.explojour:=String:C10(Records in selection:C76([DONNEES_BRQ:182]))
USE SET:C118("selection")
QUERY SELECTION:C341([DONNEES_BRQ:182]; [DONNEES_BRQ:182]codeNF:9="C09@")
vCumuls.rtjour:=String:C10(Records in selection:C76([DONNEES_BRQ:182]))
USE SET:C118("selection")
QUERY SELECTION:C341([DONNEES_BRQ:182]; [DONNEES_BRQ:182]codeNF:9="C08@")
vCumuls.rnjour:=String:C10(Records in selection:C76([DONNEES_BRQ:182]))
USE SET:C118("selection")
QUERY SELECTION:C341([DONNEES_BRQ:182]; [DONNEES_BRQ:182]codeNF:9="C03@")
vCumuls.biensjour:=String:C10(Records in selection:C76([DONNEES_BRQ:182]))
USE SET:C118("selection")
QUERY SELECTION:C341([DONNEES_BRQ:182]; [DONNEES_BRQ:182]codeNF:9="C07@"; *)
QUERY SELECTION:C341([DONNEES_BRQ:182];  | ; [DONNEES_BRQ:182]codeNF:9="C06@")
vCumuls.policejour:=String:C10(Records in selection:C76([DONNEES_BRQ:182]))
USE SET:C118("selection")
QUERY SELECTION:C341([DONNEES_BRQ:182]; [DONNEES_BRQ:182]codeNF:9="C10@")
vCumuls.rechjour:=String:C10(Records in selection:C76([DONNEES_BRQ:182]))
USE SET:C118("selection")
QUERY SELECTION:C341([DONNEES_BRQ:182]; [DONNEES_BRQ:182]codeNF:9="C11@")
vCumuls.divjour:=String:C10(Records in selection:C76([DONNEES_BRQ:182]))
CLEAR SET:C117("selection")


// on va effacer un éventuel BRQ qui avait déjà été enregistré
$chaineDate:=String:C10(Year of:C25($dateFin); "0000")+String:C10(Month of:C24($dateFin); "00")+String:C10(Day of:C23($dateFin); "00")
$chemin:="C:\\BRQ\\BRQ_"+$chaineDate+".pdf"
If (Test path name:C476($chemin)=Est un document:K24:1)
	DELETE DOCUMENT:C159($chemin)
End if 
SET PRINT OPTION:C733(Option orientation:K47:2; 1)  // impression en mode portrait
SET CURRENT PRINTER:C787(Driver PDF générique:K47:15)
SET PRINT OPTION:C733(Option destination:K47:7; 3; "C:\\BRQ\\BRQ_"+$chaineDate+".pdf")  // on imprime en PDF
$h:=Print form:C5([DONNEES_BRQ:182]; "BRQ"; Entête formulaire:K43:3)

QUERY:C277([DONNEES_BRQ:182]; [DONNEES_BRQ:182]TSDebut:13>=$TSDebut; *)
QUERY:C277([DONNEES_BRQ:182]; [DONNEES_BRQ:182]TSDebut:13<=$TSFin; *)
QUERY:C277([DONNEES_BRQ:182]; [DONNEES_BRQ:182]commentaire:3#""; *)
QUERY:C277([DONNEES_BRQ:182]; [DONNEES_BRQ:182]codeNF:9#"OPHS@")
ORDER BY:C49([DONNEES_BRQ:182]; [DONNEES_BRQ:182]TSDebut:13; >)
While (Not:C34(End selection:C36([DONNEES_BRQ:182])))
	vtype:=""
	Case of 
		: ([DONNEES_BRQ:182]codeNF:9="C02@")
			vtype:="Secours à personnes"
		: ([DONNEES_BRQ:182]codeNF:9="C01@")
			vtype:="Accidents de circulation"
		: ([DONNEES_BRQ:182]codeNF:9="C04@")
			vtype:="Incendies"
		: ([DONNEES_BRQ:182]codeNF:9="C05@")
			vtype:="Explosions"
		: ([DONNEES_BRQ:182]codeNF:9="C09@")
			vtype:="Risques technologiques"
		: ([DONNEES_BRQ:182]codeNF:9="C08@")
			vtype:="Risques naturels"
		: ([DONNEES_BRQ:182]codeNF:9="C03@")
			vtype:="Atteintes aux biens et aux animaux"
		: ([DONNEES_BRQ:182]codeNF:9="C07@") | ([DONNEES_BRQ:182]codeNF:9="C06@")
			vtype:="Missions Police"
		: ([DONNEES_BRQ:182]codeNF:9="C10@")
			vtype:="Recherches"
		: ([DONNEES_BRQ:182]codeNF:9="C11@")
			vtype:="Opérations diverses"
		Else 
			vtype:=""
	End case 
	$h:=Print form:C5([DONNEES_BRQ:182]; "BRQ"; Corps formulaire:K43:1)
	NEXT RECORD:C51([DONNEES_BRQ:182])
End while 
$h:=Print form:C5([DONNEES_BRQ:182]; "BRQ"; Pied de page formulaire:K43:2)
PAGE BREAK:C6
$fini:=False:C215
$chemin:="C:\\BRQ\\BRQ_"+$chaineDate+".pdf"
Repeat   // on va attendre que le document soit généré
	If (Test path name:C476($chemin)=Est un document:K24:1)
		// si c'est fini
		$fini:=True:C214
	Else 
		DELAY PROCESS:C323(Current process:C322; 120)  // on attend 2s avant de retester
	End if 
Until ($fini)
// on peut maintenant faire l'envoi par mail
// on crée le transporteur
$smtp:=New object:C1471
$smtp.host:="smtp.office365.com"
$smtp.port:=587
$smtp.user:="alertes@sis2a.corsica"
$smtp.password:="smtpNOTIFY*"
$smtpTransporter:=SMTP New transporter:C1608($smtp)

// on cree le mail
$email:=New object:C1471
$email.subject:="BRQ du "+String:C10($dateFin; Interne date court:K1:7)
$email.from:="alertes@sis2a.corsica"
//Originating addresses
$email.to:="codis@sis2a.corsica,jean-jacques.casalot@sis2a.corsica"  //$destinataire  //,jjcasalot@panda-is.com"
$email.textBody:="Bonjour"+Char:C90(Retour à la ligne:K15:40)+"Veuillez trouver ci-joint le BRQ du "+String:C10($dateFin; Interne date court:K1:7)+" relatif aux interventions du "+String:C10($dateDebut; Interne date court:K1:7)+" à 6h30 au "+String:C10($dateFin; Interne date court:K1:7)+" à 6h30."+Char:C90(Retour à la ligne:K15:40)
$email.textBody:=$email.textBody+"Cordialement."+Char:C90(Retour à la ligne:K15:40)
$email.attachments:=New collection:C1472(MAIL New attachment:C1644($chemin))

// on envoie le mail
C_OBJECT:C1216($status)
$status:=$smtpTransporter.send($email)
