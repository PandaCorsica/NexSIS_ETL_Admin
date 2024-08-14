//%attributes = {}
$destinataire:=$1
$brq:=$2

// on crée le transporteur
$smtp:=New object:C1471
$smtp.host:="smtp.office365.com"
$smtp.port:=587
$smtp.user:="alertes@sis2a.corsica"
$smtp.password:="smtpNOTIFY*"
$smtpTransporter:=SMTP New transporter:C1608($smtp)

$today:=String:C10(Current date:C33; Interne date court:K1:7)

// on cree le mail
$email:=New object:C1471
$email.from:="alertes@sis2a.corsica"
//Originating addresses
$email.to:=$destinataire  //,jjcasalot@panda-is.com"
// Carbon Copy
//$email.cc:=Créer objet("nom"; "Christian Morelli"; "email"; "christian.morelli@sis2a.corsica")
// Blind Carbon Copy
$email.bcc:="jean-jacques.casalot@sis2a.corsica"
$email.subject:="Bilan de la journée du "+$today
$email.textBody:="Bonjour"+Char:C90(Retour à la ligne:K15:40)+"Veuillez trouver ci-joint le récapitulatif des opérations du "+$today+" entre 6h30 et 17h30."+Char:C90(Retour à la ligne:K15:40)
$email.textBody:=$email.textBody+"Ce document est rédigé automatiquement à partir des données de NexSIS. Il vous sera envoyé tous les soirs à 17h35."+Char:C90(Retour à la ligne:K15:40)
$email.textBody:=$email.textBody+"Il est pour le moment destiné à vous éviter un comptage fastidieux. D'ici peu, un travail sera fait sur la mise en page afin que vous puissiez directement le transmettre"+Char:C90(Retour à la ligne:K15:40)
$email.textBody:=$email.textBody+"N'hésitez pas à me transmettre vos remarques sur l'intérêt de ces envois et leur contenu."+Char:C90(Retour à la ligne:K15:40)
$email.textBody:=$email.textBody+"JJ Casalot"+Char:C90(Retour à la ligne:K15:40)
$email.textBody:=$email.textBody+Char:C90(Retour à la ligne:K15:40)
$email.textBody:=$email.textBody+"Total des interventions :"+String:C10(OB Get:C1224($brq; "Total"))+Char:C90(Retour à la ligne:K15:40)
$email.textBody:=$email.textBody+"Secours à personnes :"+String:C10(OB Get:C1224($brq; "SSUAP"))+Char:C90(Retour à la ligne:K15:40)
$email.textBody:=$email.textBody+"Accidents de circulation :"+String:C10(OB Get:C1224($brq; "AVP"))+Char:C90(Retour à la ligne:K15:40)
$email.textBody:=$email.textBody+"Incendies :"+String:C10(OB Get:C1224($brq; "INC"))+Char:C90(Retour à la ligne:K15:40)
$email.textBody:=$email.textBody+"Explosions :"+String:C10(OB Get:C1224($brq; "Explo"))+Char:C90(Retour à la ligne:K15:40)
$email.textBody:=$email.textBody+"Risques technologiques :"+String:C10(OB Get:C1224($brq; "RT"))+Char:C90(Retour à la ligne:K15:40)
$email.textBody:=$email.textBody+"Risques naturels :"+String:C10(OB Get:C1224($brq; "RN"))+Char:C90(Retour à la ligne:K15:40)
$email.textBody:=$email.textBody+"Atteintes aux biens et aux animaux :"+String:C10(OB Get:C1224($brq; "BiensAnimaux"))+Char:C90(Retour à la ligne:K15:40)
$email.textBody:=$email.textBody+"Missions Police :"+String:C10(OB Get:C1224($brq; "Police"))+Char:C90(Retour à la ligne:K15:40)
$email.textBody:=$email.textBody+"Recherches :"+String:C10(OB Get:C1224($brq; "Recherches"))+Char:C90(Retour à la ligne:K15:40)
$email.textBody:=$email.textBody+"Operations diverses :"+String:C10(OB Get:C1224($brq; "DIV"))+Char:C90(Retour à la ligne:K15:40)
$email.textBody:=$email.textBody+Char:C90(Retour à la ligne:K15:40)
$temp:=String:C10(OB Get:C1224($brq; "HorsSSUAP"))
If ($temp#"")
	$email.textBody:=$email.textBody+"-------------------------------------------------------------"+Char:C90(Retour à la ligne:K15:40)
	$email.textBody:=$email.textBody+"Interventions autres que du SSUAP :"+Char:C90(Retour à la ligne:K15:40)
	$email.textBody:=$email.textBody+"-------------------------------------------------------------"+Char:C90(Retour à la ligne:K15:40)
	$email.textBody:=$email.textBody+$temp+Char:C90(Retour à la ligne:K15:40)
End if 
//$email.attachments:=Créer collection(MAIL Créer pièce jointe($chemin))
// on envoie le mail
C_OBJECT:C1216($status)
$status:=$smtpTransporter.send($email)
$0:=$status.success