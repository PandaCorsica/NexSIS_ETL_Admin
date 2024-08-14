//%attributes = {}

DDF_Efface_et_Charge("nexsis_engin"; "prod")
// on met à jour les tables des données montantes avec les données chargées
ALL RECORDS:C47([nexsis_engin:152])
While (Not:C34(End selection:C36([nexsis_engin:152])))
	QUERY:C277([IMPORT_MOYENS:43]; [IMPORT_MOYENS:43]id_Moyen:2=[nexsis_engin:152]nom_moyen:3)
	If (Records in selection:C76([IMPORT_MOYENS:43])=0)
		CREATE RECORD:C68([IMPORT_MOYENS:43])
		[IMPORT_MOYENS:43]id_Moyen:2:=[nexsis_engin:152]nom_moyen:3
		[IMPORT_MOYENS:43]aSupprimer:19:=False:C215
		[IMPORT_MOYENS:43]attelage:13:=""
		[IMPORT_MOYENS:43]capacite_traction:15:=""
		[IMPORT_MOYENS:43]classe:12:=""
		[IMPORT_MOYENS:43]hauteur:9:=""
		[IMPORT_MOYENS:43]id_uf_admin:7:="sis"
		[IMPORT_MOYENS:43]immatriculation:6:=""
		[IMPORT_MOYENS:43]largeur:10:=""
		[IMPORT_MOYENS:43]longueur:11:=""
		[IMPORT_MOYENS:43]num_ordre_cis:4:=""
		[IMPORT_MOYENS:43]ptac:16:=""
		[IMPORT_MOYENS:43]traite:18:=False:C215
		[IMPORT_MOYENS:43]type_vesteur:14:="vecteur"
		//[IMPORT_MOYENS]vecteur:=
	End if 
	If ([nexsis_engin:152]code_etat_disponibilite:6="DISPONIBLE_0")
		[IMPORT_MOYENS:43]etat_disponibilite:17:="D0"
	Else 
		[IMPORT_MOYENS:43]etat_disponibilite:17:="IND"
	End if 
	If (Substring:C12([nexsis_engin:152]code_unite_fonctionnelle_operat:5; 3)#"02a")
		$pos:=Position:C15("-"; [nexsis_engin:152]code_unite_fonctionnelle_operat:5)
		[nexsis_engin:152]code_unite_fonctionnelle_operat:5:="02a-"+Substring:C12([nexsis_engin:152]code_unite_fonctionnelle_operat:5; $pos+1)
		SAVE RECORD:C53([nexsis_engin:152])
	End if 
	[IMPORT_MOYENS:43]id_uf_ope:8:=Substring:C12([nexsis_engin:152]code_unite_fonctionnelle_operat:5; 5)
	$pos:=Position:C15("-"; [nexsis_engin:152]nom_moyen:3)
	[IMPORT_MOYENS:43]num_ordre_dept:5:=Num:C11(Substring:C12([nexsis_engin:152]nom_moyen:3; $pos+1))
	//[IMPORT_MOYENS]vecteur:=
	SAVE RECORD:C53([IMPORT_MOYENS:43])
	NEXT RECORD:C51([nexsis_engin:152])
End while 

DDF_Efface_et_Charge("nexsis_habilitation"; "prod")
//DDF_Efface_et_Charge("nexsis_radio"; "prod")
