//%attributes = {}
$annee:=2024
$mois:=1

DDF_Recupere_crss_validation($annee; $mois)

DDF_Recupere_crss_operation($annee; $mois)

DDF_Recupere_affaires($annee; $mois)

DDF_Recupere_crss_alerte($annee; $mois)

DDF_Recupere_crss_echelon($annee; $mois)

DDF_Recupere_crss_engin($annee; $mois)

DDF_Recupere_crss_agent($annee; $mois)

DDF_Marque_CRRS_Compta



//On note ces validations de CRSS comme traitées et prises en compte
ALL RECORDS:C47([crss_validation:154])
APPLY TO SELECTION:C70([crss_validation:154]; [crss_validation:154]Traite:19:=True:C214)

// il faut maintenant recréer les lignes de CRSS compréhensibles par Antibia

