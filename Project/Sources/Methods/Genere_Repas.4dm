//%attributes = {}
$annee:=$1
$mois:=$2
ARRAY LONGINT:C221($TMat; 0)
QUERY:C277([PLANNINGS:156]; [PLANNINGS:156]Annee:13=$1; *)
QUERY:C277([PLANNINGS:156]; [PLANNINGS:156]Mois:14=$2; *)
QUERY:C277([PLANNINGS:156]; [PLANNINGS:156]Traite:4=False:C215)
CREATE SET:C116([PLANNINGS:156]; "plannings")
DISTINCT VALUES:C339([PLANNINGS:156]Matricule:5; $TMat)
For ($i; 1; Size of array:C274($TMat))
	// on cree les repas correspondant
	USE SET:C118("plannings")
	QUERY SELECTION:C341([PLANNINGS:156]; [PLANNINGS:156]Matricule:5=$TMat{$i})
	CREATE SET:C116([PLANNINGS:156]; "tous")
	DISTINCT VALUES:C339([PLANNINGS:156]Code_Centre:3; $TCodeCentre)
	For ($j; 1; Size of array:C274($TCodeCentre))
		USE SET:C118("tous")
		QUERY SELECTION:C341([PLANNINGS:156]; [PLANNINGS:156]Code_Centre:3=$TCodeCentre{$j})
		$nbRepas:=Sum:C1([PLANNINGS:156]Nb_Repas:6)
		If ($nbRepas>0)
			FIRST RECORD:C50([PLANNINGS:156])
			$cat:="V"  // on ne paye des repas que pour les SPV    [PLANNINGS]Categorie
			$centre:=[PLANNINGS:156]Code_Centre:3
			CREATE RECORD:C68([PLANNINGS:156])
			[PLANNINGS:156]Categorie:2:=$cat
			[PLANNINGS:156]Code_Centre:3:=$centre
			[PLANNINGS:156]Matricule:5:=$TMat{$i}
			[PLANNINGS:156]Remarques:7:=""
			[PLANNINGS:156]Repas:8:=True:C214
			[PLANNINGS:156]Jour_Debut:9:=!00-00-00!
			[PLANNINGS:156]Heure_Debut:10:=?00:00:00?
			[PLANNINGS:156]Jour_Fin:15:=!00-00-00!
			[PLANNINGS:156]Heure_Fin:16:=?00:00:00?
			[PLANNINGS:156]Type_Activite:11:="REPAS"
			[PLANNINGS:156]Nb_Repas:6:=$nbRepas
			[PLANNINGS:156]Traite:4:=False:C215
			[PLANNINGS:156]Annee:13:=$annee
			[PLANNINGS:156]Mois:14:=$mois
			SAVE RECORD:C53([PLANNINGS:156])
		End if 
	End for 
	CLEAR SET:C117("tous")
End for 
CLEAR SET:C117("plannings")
