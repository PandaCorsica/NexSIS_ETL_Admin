//%attributes = {}
$destinataire:=$1
$chemin:=$2

// on crée le transporteur
$smtp:=New object:C1471
$smtp.host:="smtp.office365.com"
$smtp.port:=587
$smtp.user:="alertes@sis2a.corsica"
$smtp.password:="smtpNOTIFY*"
$smtpTransporter:=SMTP New transporter:C1608($smtp)



// on cree le mail
$email:=New object:C1471
$email.from:="alertes@sis2a.corsica"
//Originating addresses
$email.to:=$destinataire  //,jjcasalot@panda-is.com"
// Carbon Copy
//$email.cc:=Créer objet("nom"; "Stephen"; "email"; "address3@mail.com")
// Blind Carbon Copy
//$email.bcc:="address4@mail.com,address5@mail.com"
$email.subject:="Rapport NexSIS (arrêt temporaire)"
$email.textBody:="Bonjour"+Char:C90(Retour à la ligne:K15:40)+"Suite à des modifications dans les données transmises par NexSIS, les rapports transmis tous les jours ne sont plus fiables."+Char:C90(Retour à la ligne:K15:40)
$email.textBody:=$email.textBody+"En conséquence, ce rapport ne vous sera plus transmis tant qu'il n'est pas fiabilisé."+Char:C90(Retour à la ligne:K15:40)

// suppression temporaire
//$email.textBody:="Bonjour"+Caractère(Retour à la ligne)+"Veuillez trouver ci-joint le rapport automatique de synthèse des CRSS et plannings NexSIS"+Caractère(Retour à la ligne)
//$email.textBody:=$email.textBody+"Sauf demande contraire, ce fichier vous sera envoyé tous les matins."+Caractère(Retour à la ligne)
//$email.textBody:=$email.textBody+"RAPPEL : seuls les rapports et les plannings validés seront pris en compte pour l'indemnisation."+Caractère(Retour à la ligne)+"Cordialement"+Caractère(Retour à la ligne)
//$email.attachments:=Créer collection(MAIL Créer pièce jointe($chemin))

// on envoie le mail
C_OBJECT:C1216($status)
$status:=$smtpTransporter.send($email)
$0:=$status.success