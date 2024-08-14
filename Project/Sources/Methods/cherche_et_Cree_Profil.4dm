//%attributes = {}
$nomProfil:=$1
$codeHabilitation:=$2

CREATE RECORD:C68([PROFILS:122])
[PROFILS:122]Nom_Profil:3:=$nomProfil
[PROFILS:122]Code_Habilitation:2:=$THabilitations{$i}
SAVE RECORD:C53([PROFILS:122])
