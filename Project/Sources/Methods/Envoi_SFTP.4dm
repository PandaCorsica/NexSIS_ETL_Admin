//%attributes = {}
$cheminDossier:=$1  // le dossier dans lequel sont les fichiers
$nomDossier:=$2  // le nom du dossier à créer
//$cheminTemp:=Dossier 4D(Dossier racine HTML)+"Envoi_temp"

//$CURLSSH_AUTH_PUBLICKEY:=(1 << 0)
//$CURLSSH_AUTH_PASSWORD:=(1 << 1)

$options:=New object:C1471
//sftp:  //sis2a@sftp.nexsis18-112.fr:20022/share
$options.URL:="sftp://sftp.nexsis18-112.fr/share/AUTO_JR/"+$nomDossier
$options.USERNAME:="sis2a"
$options.USE_SSL:=1
$options.PORT:=20022
$options.SSH_AUTH_TYPES:=1  //$CURLSSH_AUTH_PUBLICKEY
$options.SSH_PRIVATE_KEYFILE:=Folder:C1567(fk dossier bureau:K87:19).file("id_rsa").platformPath

// on commence par créer le dossier
$status:=cURL_FTP_MakeDir($options)
// on va ensuite transférer les fichiers attendus
// pour cela, o,n va d'abord faire une liste des fichiers à transfer
ARRAY TEXT:C222($TFichiers; 0)
APPEND TO ARRAY:C911($TFichiers; "AFFECTATIONS.CSV")
APPEND TO ARRAY:C911($TFichiers; "COMPETENCES.CSV")
APPEND TO ARRAY:C911($TFichiers; "DEPENDANCES_EMETTEURS.CSV")
//AJOUTER À TABLEAU($TFichiers; "DEPENDANCES_PAGERS_EMETTEURS.CSV")
APPEND TO ARRAY:C911($TFichiers; "EMETTEURS.CSV")
APPEND TO ARRAY:C911($TFichiers; "ETATS_DISPO.CSV")
APPEND TO ARRAY:C911($TFichiers; "HABILITATIONS.CSV")
APPEND TO ARRAY:C911($TFichiers; "INDIVIDUS.CSV")
APPEND TO ARRAY:C911($TFichiers; "LISTE_GARDE.CSV")
APPEND TO ARRAY:C911($TFichiers; "MOYENS.CSV")
APPEND TO ARRAY:C911($TFichiers; "PAGERS.CSV")
APPEND TO ARRAY:C911($TFichiers; "PIQUETS.CSV")
APPEND TO ARRAY:C911($TFichiers; "RADIOS.CSV")
APPEND TO ARRAY:C911($TFichiers; "UF.CSV")
APPEND TO ARRAY:C911($TFichiers; "AGENTS.CSV")
For ($i; 1; Size of array:C274($TFichiers))
	C_TEXT:C284($cheminFichier)
	$options.URL:="sftp://sftp.nexsis18-112.fr/share/AUTO_JR/"+$nomDossier+"/"+$TFichiers{$i}
	//$cheminFichier:=$cheminDossier+$TFichiers{$i}
	$file:=Folder:C1567($cheminDossier; fk chemin plateforme:K87:2).file($TFichiers{$i})
	$options.BUFFERSIZE:=2000000
	$options.READDATA:=$file.platformPath
	C_BLOB:C604($request; $response)
	
	$vt_callback:=""
	$ob_status:=cURL_FTP_Send($options; $request; $vt_callback)
	//$status:=cURL_FTP_Send($options; $cheminFichier)
End for 
