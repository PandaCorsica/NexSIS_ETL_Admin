//%attributes = {}
ALL RECORDS:C47([IMPORT_CATEGORIE:24])
ORDER BY:C49([IMPORT_CATEGORIE:24]; [IMPORT_CATEGORIE:24]Cle:2; >)
ALL RECORDS:C47([REFERENTIEL_STATUTS:32])
ORDER BY:C49([REFERENTIEL_STATUTS:32]; [REFERENTIEL_STATUTS:32]Libelle:3; >)

$fen:=Open form window:C675("Correspondance_Statuts"; Form dialogue modal:K39:7; Centrée horizontalement:K39:1; Centrée verticalement:K39:4)
DIALOG:C40("Correspondance_Statuts")
CLOSE WINDOW:C154($fen)