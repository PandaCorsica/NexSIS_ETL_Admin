//%attributes = {}
// Cette méthode est exécutée toutes les nuits pour récupérer les données froides mises à jour
// pour chaque donnée récupérée :
// - si elle n'existe pas, on la crée
// - si elle existe, on la met à jour

// A NOTER : Il faut créer une table qui tient à jour la date de dernière récupération de chaque table récupérée
// pour chaque table, on va récupérer les datas à partir de la date de dernière récupération
// une fois les données récupérées, on met à jour la table centralisatrice des dates
// RECUPERATION DES PLANNINGS DONNEES TIEDES
DDF_Recupere_Tous_POJ

// RECUPERATION TABLES SGO
//1) on récupère les interventions dans sgo_operation en filtrant sur date_creation
DDF_Recupere_Donnees_Generique("sgo_operation"; "date_reception"; "02a-sis"; "id_operation")
DDF_Recupere_Donnees_Generique("sgo_affaire"; "date_reception"; "02a-sis"; "id_affaire")
DDF_Recupere_Donnees_Generique("sgo_circonstance"; "date_reception"; "02a-sis"; "id_operation")
DDF_Recupere_Donnees_Generique("sgo_delegation"; "date_reception"; "02a-sis"; "id_operation")
DDF_Recupere_Donnees_Generique("sgo_icm"; "date_reception"; "02a-sis"; "id_operation"; "numero_groupe")
DDF_Recupere_Donnees_Generique("sgo_localisation"; "date_reception"; "02a-sis"; "id_operation")
DDF_Recupere_Donnees_Generique("sgo_operation"; "date_reception"; "02a-sis"; "id_operation")
DDF_Recupere_Donnees_Generique("sgo_reponse"; "date_reception"; "02a-sis"; "id_reponse"; "id_operation")
DDF_Recupere_Donnees_Generique("sgo_reponse_theorique"; "date_reception"; "02a-sis"; "id_operation"; "id_echelon")
DDF_Recupere_Donnees_Generique("sgo_partenaire"; "date_modification"; "02a-sis"; "id_affaire"; "code_intervenant")


// RECUPERATION TABLES SGA
//1bis) on récupère les infos sur l'alerte dans sga_alerte
DDF_Recupere_Donnees_Generique("sga_alerte"; "date_creation"; "02a-cga"; "numero_alerte")
DDF_Recupere_Donnees_Generique("sga_traitement"; "date_creation"; "*"; "numero_alerte")
//DDF_Recupere_Donnees_Generique("sga_traitement"; "date_creation"; "02a-cga"; "numero_alerte")
DDF_Recupere_Donnees_Generique("sga_abandon"; "date_creation"; "02a-cga"; "numero_alerte")
DDF_Recupere_Donnees_Generique("sga_abandon_affaire"; "date_creation"; "02a-cga"; "numero_alerte")
DDF_Recupere_Donnees_Generique("sga_abus"; "date_creation"; "02a-cga"; "numero_alerte")
DDF_Recupere_Donnees_Generique("sga_aide"; "date_creation"; "02a-cga"; "numero_alerte")
DDF_Recupere_Donnees_Generique("sga_create_affaire"; "date_creation_affaire"; "*"; "numero_affaire")
//DDF_Recupere_Donnees_Generique("sga_create_affaire"; "date_creation_affaire"; "02a-cga"; "numero_affaire")
DDF_Recupere_Donnees_Generique("sga_intervenant"; "date_creation"; "02a-cga"; "numero_affaire")
DDF_Recupere_Donnees_Generique("sga_origine_appel"; "date_creation"; "02a-cga"; "numero_alerte")
DDF_Recupere_Donnees_Generique("sga_priorisation_orientation_de"; "date_creation"; "02a-cga"; "numero_alerte")
DDF_Recupere_Donnees_Generique("sga_tech"; "date_creation"; "02a-cga"; "numero_alerte")
DDF_Recupere_Donnees_Generique("sga_traitement_delai"; "date_creation"; "02a-cga"; "numero_alerte")
DDF_Recupere_Donnees_Generique("sga_localisation_appel"; "date_creation"; "02a-cga"; "numero_alerte")
DDF_Recupere_Donnees_Generique("sga_operateur_priorisation_orie"; "date_creation"; "02a-cga"; "numero_alerte")
DDF_Recupere_Donnees_Generique("sga_operateur_traitement"; "date_creation"; "02a-cga"; "numero_alerte")
DDF_Recupere_Donnees_Generique("sga_priorisation_orientation"; "date_creation"; "02a-cga"; "numero_alerte")
DDF_Recupere_Donnees_Generique("sga_risques_menaces"; "date_creation"; "02a-cga"; "numero_alerte")
DDF_Recupere_Donnees_Generique("sga_traitement_localisation"; "date_creation"; "02a-cga"; "numero_alerte")


// RECUPERATION TABLES CRSS
DDF_Recupere_Donnees_Generique("crss_operation"; "date_modification"; "02a-sis"; "id_operation")
DDF_Recupere_Donnees_Generique("crss_intervenant"; "date_modification"; "02a-sis"; "id_intervenant")
DDF_Recupere_Donnees_Generique("crss_victime"; "date_modification"; "02a-sis"; "id_victime")
//modif temporaire
//DDF_Recupere_Donnees_Generique("crss_sinistre"; "createdAt"; "02a-sis"; "id_")
//DDF_Recupere_Donnees_Generique("crss_engin"; "createdAt"; "02a-sis"; "id_engin")
//DDF_Recupere_Donnees_Generique("crss_agent"; "createdAt"; "02a-sis"; "id_")
//
DDF_Recupere_Donnees_Generique("crss_sinistre"; "date_modification"; "02a-sis"; "id_")
DDF_Recupere_Donnees_Generique("crss_engin"; "date_modification"; "02a-sis"; "id_engin")
DDF_Recupere_Donnees_Generique("crss_agent"; "date_modification"; "02a-sis"; "id_")
DDF_Recupere_Donnees_Generique("crss_thematique"; "date_modification"; "02a-sis"; "id_operation"; "id_thematique")
DDF_Recupere_Donnees_Generique("crss_questionnaire_cos"; "date_modification"; "02a-sis"; "id_operation")
DDF_Recupere_Donnees_Generique("crss_questionnaire_ca"; "date_modification"; "02a-sis"; "id_operation")
//DDF_Recupere_Donnees_Generique("crss_validation"; "created_at"; "02a-sis"; "id_operation"; "unite_fonctionnelle")
DDF_Recupere_Donnees_Generique("crss_validation"; "date_modification"; "02a-sis"; "id_operation"; "unite_fonctionnelle")
DDF_Recupere_Donnees_Generique("crss_redaction_cos"; "date_modification"; "02a-sis"; "id_cr_operation")
DDF_Recupere_Donnees_Generique("crss_redaction_moyen"; "date_modification"; "02a-sis"; "id_cr_operation")
DDF_Recupere_Donnees_Generique("crss_traitement"; "date_modification"; "02a-sis"; "id_cr_moyen")
DDF_Recupere_Donnees_Generique("crss_traitement"; "date_plus_recente"; "02a-sis"; "id_cr_moyen")
//DDF_Recupere_Donnees_Generique("crss_paie"; "date_modification"; "02a-sis"; "id_operation")



// RECUPERATION TABLES ENVIRONNEMENT
// ces tables sont à récupérer une seule fois dans la globalité chaque jour après effacement des anciennes valeurs
DDF_Efface_et_Charge("nexsis_bippeur"; "prod")
DDF_Efface_et_Charge("nexsis_competence"; "prod")
DDF_Efface_et_Charge("nexsis_emetteur"; "prod")
DDF_Efface_et_Charge("nexsis_engin"; "prod")
DDF_Efface_et_Charge("nexsis_habilitation"; "prod")
DDF_Efface_et_Charge("nexsis_radio"; "prod")
//DDF_Efface_et_Charge("bi_tracabilite_participation_ag")
//DDF_Efface_et_Charge("bi_tracabilite_statuts_agents")
//DDF_Efface_et_Charge("bi_tracabilite_tracabilite")
DDF_Efface_et_Charge("sgo_referentiel_moyen"; "prod")
DDF_Efface_et_Charge("crss_referentiel_reponses")
DDF_Efface_et_Charge("ref_cisu_risques_menaces")
DDF_Efface_et_Charge("ref_intervenant")
DDF_Efface_et_Charge("ref_mission")
DDF_Efface_et_Charge("ref_nature_de_fait")
DDF_Efface_et_Charge("ref_pathologie")
DDF_Efface_et_Charge("ref_question")
DDF_Efface_et_Charge("ref_thematique")
DDF_Efface_et_Charge("ref_type_de_lieu")
DDF_Efface_et_Charge("ref_grade")
DDF_Efface_et_Charge("ref_position_administrative")
DDF_Efface_et_Charge("ref_structure")
//2) on récupère la qualification des affaires


//3) on récupère les CRSS validés en filtrant sur date_modification et etat_validation=VALIDE


//4) on récupère les crss_operation en filtrant sur la date_modification


//5) On récupère les engins dans crss_engin en filtrant sur la date de modification

//6) on récupère les agents dans crss_agent en filtrant sur la date de modification




// 7) On marque les crss comme pris en compte dans la paie en alimlentant la table crss_paie et en utilisant l'API statut-de-paie

// 8)on récupère les données dans crss_traitement pour suivre l'état de validation général des CRSS