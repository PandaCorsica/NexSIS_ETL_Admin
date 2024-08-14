//%attributes = {}
ALL RECORDS:C47([nexsis_habilitation:150])
While (Not:C34(End selection:C36([nexsis_habilitation:150])))
	$idUF:=Substring:C12([nexsis_habilitation:150]id_uf:6; 5)
	Case of 
		: ([nexsis_habilitation:150]code_grade:4="@SPV")
			$codeStatut:="0"
		: ([nexsis_habilitation:150]code_grade:4="@PATS@")
			$codeStatut:="2"
		Else 
			$codeStatut:="1"
	End case 
	[nexsis_habilitation:150]code_agent:14:=[nexsis_habilitation:150]matricule:3+"-"+$codeStatut+"_"+$idUF
	SAVE RECORD:C53([nexsis_habilitation:150])
	NEXT RECORD:C51([nexsis_habilitation:150])
End while 
// on sup^prime toutes les habilitations remontées de Nexsis de la table habilitations automatique
DISTINCT VALUES:C339([nexsis_habilitation:150]code_agent:14; $TCodeAgent)
For ($i; 1; Size of array:C274($TCodeAgent))
	QUERY:C277([HABILITATIONS:52]; [HABILITATIONS:52]id_affectation:2=$TCodeAgent{$i})
	DELETE SELECTION:C66([HABILITATIONS:52])
End for 
// on recrée les habilitations existantes dans NexSIS
FIRST RECORD:C50([nexsis_habilitation:150])
While (Not:C34(End selection:C36([nexsis_habilitation:150])))
	$idUF:=Substring:C12([nexsis_habilitation:150]id_uf:6; 5)
	Case of 
		: ([nexsis_habilitation:150]code_grade:4="@SPV")
			$codeStatut:="0"
		: ([nexsis_habilitation:150]code_grade:4="@PATS@")
			$codeStatut:="2"
		Else 
			$codeStatut:="1"
	End case 
	CREATE RECORD:C68([HABILITATIONS:52])
	[HABILITATIONS:52]id_affectation:2:=[nexsis_habilitation:150]matricule:3+"-"+$codeStatut+"_"+$idUF
	[HABILITATIONS:52]id_habilitation:3:=[nexsis_habilitation:150]code_profil:7
	SAVE RECORD:C53([HABILITATIONS:52])
	NEXT RECORD:C51([nexsis_habilitation:150])
End while 
