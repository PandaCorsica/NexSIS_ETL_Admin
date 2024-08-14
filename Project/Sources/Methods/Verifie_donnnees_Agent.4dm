//%attributes = {}
$error:=False:C215

//$doc:=Créer document(Dossier 4D(Dossier base)+"erreursAgents.txt"; ".txt")
$doc:=$1

QUERY:C277([AGENTS:2]; [AGENTS:2]matricule:5="")
If (Records in selection:C76([AGENTS:2])>0)
	SEND PACKET:C103($doc; "Des agents n'ont pas de matricule"+Char:C90(Retour à la ligne:K15:40))
	$error:=True:C214
	DELETE SELECTION:C66([AGENTS:2])
End if 

//verification de l'existance des agents
ALL RECORDS:C47([AGENTS:2])
While (Not:C34(End selection:C36([AGENTS:2])))
	QUERY:C277([INDIVIDUS:1]; [INDIVIDUS:1]id_individu:2=[AGENTS:2]id_individu:2)
	If (Records in selection:C76([INDIVIDUS:1])=0)
		SEND PACKET:C103($doc; "Individu inexistant matricule "+[AGENTS:2]matricule:5+Char:C90(Retour à la ligne:K15:40))
		//[AGENTS]id_individu:=""
		$error:=True:C214
		SAVE RECORD:C53([AGENTS:2])
	End if 
	NEXT RECORD:C51([AGENTS:2])
End while 
QUERY:C277([AGENTS:2]; [AGENTS:2]id_individu:2="")
DELETE SELECTION:C66([AGENTS:2])


// verification du format de l'ID_connexion
ALL RECORDS:C47([AGENTS:2])
While (Not:C34(End selection:C36([AGENTS:2])))
	If (Not:C34(Match regex:C1019("[a-z0-9-_]+\\.[a-z0-9_-]+@sis2a.corsica"; [AGENTS:2]id_connexion:4)))
		SEND PACKET:C103($doc; "Mauvais ID agent pour agent matricule "+[AGENTS:2]matricule:5+Char:C90(Retour à la ligne:K15:40))
		//[AGENTS]id_connexion:=""
		$error:=True:C214
		SAVE RECORD:C53([AGENTS:2])
	End if 
	NEXT RECORD:C51([AGENTS:2])
End while 
QUERY:C277([AGENTS:2]; [AGENTS:2]id_connexion:4="")
DELETE SELECTION:C66([AGENTS:2])



QUERY:C277([AGENTS:2]; [AGENTS:2]grade:7="")
If (Records in selection:C76([AGENTS:2])>0)
	While (Not:C34(End selection:C36([AGENTS:2])))
		SEND PACKET:C103($doc; "Agent sans grade : matricule "+[AGENTS:2]matricule:5+Char:C90(Retour à la ligne:K15:40))
		NEXT RECORD:C51([AGENTS:2])
	End while 
	$error:=True:C214
	//SUPPRIMER SÉLECTION([AGENTS])
End if 

QUERY:C277([AGENTS:2]; [AGENTS:2]statut:6="")
If (Records in selection:C76([AGENTS:2])>0)
	While (Not:C34(End selection:C36([AGENTS:2])))
		SEND PACKET:C103($doc; "Agent sans statut : matricule "+[AGENTS:2]matricule:5+Char:C90(Retour à la ligne:K15:40))
		NEXT RECORD:C51([AGENTS:2])
	End while 
	$error:=True:C214
	DELETE SELECTION:C66([AGENTS:2])
End if 


//verification de l'existance des agents affectes
ALL RECORDS:C47([AFFECTATIONS:3])
While (Not:C34(End selection:C36([AFFECTATIONS:3])))
	QUERY:C277([AGENTS:2]; [AGENTS:2]id_agent:3=[AFFECTATIONS:3]id_agent:3)
	If (Records in selection:C76([AGENTS:2])=0)
		SEND PACKET:C103($doc; "Affectation d'un agent non existant id_agent :"+[AFFECTATIONS:3]id_agent:3+Char:C90(Retour à la ligne:K15:40))
		//[AFFECTATIONS]id_agent:=""
		$error:=True:C214
		SAVE RECORD:C53([AFFECTATIONS:3])
	End if 
	NEXT RECORD:C51([AFFECTATIONS:3])
End while 
QUERY:C277([AFFECTATIONS:3]; [AFFECTATIONS:3]id_agent:3="")
DELETE SELECTION:C66([AFFECTATIONS:3])

// verification du format de l'ID_affectation
ALL RECORDS:C47([AFFECTATIONS:3])
While (Not:C34(End selection:C36([AFFECTATIONS:3])))
	If (Not:C34(Match regex:C1019("[0-9]+\\-[0-9]+\\_[a-zA-Z0-9]+"; [AFFECTATIONS:3]id_affectation:2)))
		SEND PACKET:C103($doc; "Mauvais ID affectation pour ID agent "+[AFFECTATIONS:3]id_agent:3+Char:C90(Retour à la ligne:K15:40))
		//[AFFECTATIONS]id_affectation:=""
		$error:=True:C214
		SAVE RECORD:C53([AFFECTATIONS:3])
	End if 
	NEXT RECORD:C51([AFFECTATIONS:3])
End while 
QUERY:C277([AFFECTATIONS:3]; [AFFECTATIONS:3]id_affectation:2="")
DELETE SELECTION:C66([AFFECTATIONS:3])

// verification de l'ID uf
ALL RECORDS:C47([AFFECTATIONS:3])
While (Not:C34(End selection:C36([AFFECTATIONS:3])))
	QUERY:C277([UF:5]; [UF:5]id_uf:5=[AFFECTATIONS:3]id_uf:4)
	If (Records in selection:C76([UF:5])=0)
		SEND PACKET:C103($doc; "UF non existante id_agent "+[AFFECTATIONS:3]id_agent:3+Char:C90(Retour à la ligne:K15:40))
		//[AFFECTATIONS]id_uf:=""
		$error:=True:C214
		SAVE RECORD:C53([AFFECTATIONS:3])
	End if 
	NEXT RECORD:C51([AFFECTATIONS:3])
End while 
QUERY:C277([AFFECTATIONS:3]; [AFFECTATIONS:3]id_uf:4="")
DELETE SELECTION:C66([AFFECTATIONS:3])

QUERY:C277([AFFECTATIONS:3]; [AFFECTATIONS:3]type:5#"AFFECTATION@")
If (Records in selection:C76([AFFECTATIONS:3])>0)
	While (Not:C34(End selection:C36([AFFECTATIONS:3])))
		SEND PACKET:C103($doc; "type affectation non défini id_agent "+[AFFECTATIONS:3]id_agent:3+Char:C90(Retour à la ligne:K15:40))
		NEXT RECORD:C51([AFFECTATIONS:3])
	End while 
	$error:=True:C214
	//SUPPRIMER SÉLECTION([AFFECTATIONS])
End if 


QUERY:C277([COMPETENCES:4]; [COMPETENCES:4]Matricule:4="")
If (Records in selection:C76([COMPETENCES:4])>0)
	SEND PACKET:C103($doc; "certains matricules ne sont pas definis pour des competences"+Char:C90(Retour à la ligne:K15:40))
	$error:=True:C214
	//SUPPRIMER SÉLECTION([COMPETENCES])
End if 

// verification du format de l'ID_affectation dans competences
ALL RECORDS:C47([COMPETENCES:4])
While (Not:C34(End selection:C36([COMPETENCES:4])))
	If (Not:C34(Match regex:C1019("[0-9]+\\-[0-9]+\\_[a-zA-Z0-9]+"; [COMPETENCES:4]id_affectation:2)))
		SEND PACKET:C103($doc; "Mauvais ID affectation pour matricule "+[COMPETENCES:4]Matricule:4+Char:C90(Retour à la ligne:K15:40))
		//[COMPETENCES]id_affectation:=""
		$error:=True:C214
		SAVE RECORD:C53([COMPETENCES:4])
	End if 
	NEXT RECORD:C51([COMPETENCES:4])
End while 
QUERY:C277([COMPETENCES:4]; [COMPETENCES:4]id_affectation:2="")
DELETE SELECTION:C66([COMPETENCES:4])

QUERY:C277([COMPETENCES:4]; [COMPETENCES:4]competence:3="")
If (Records in selection:C76([COMPETENCES:4])>0)
	While (Not:C34(End selection:C36([COMPETENCES:4])))
		SEND PACKET:C103($doc; "competence non définie pour matricule "+[COMPETENCES:4]Matricule:4+Char:C90(Retour à la ligne:K15:40))
		NEXT RECORD:C51([COMPETENCES:4])
	End while 
	$error:=True:C214
	//SUPPRIMER SÉLECTION([COMPETENCES])
End if 


// verification d'unicité agents
ALL RECORDS:C47([AGENTS:2])
DISTINCT VALUES:C339([AGENTS:2]id_agent:3; $TID)
For ($i; 1; Size of array:C274($TID))
	QUERY:C277([AGENTS:2]; [AGENTS:2]id_agent:3=$TID{$i})
	If (Records in selection:C76([AGENTS:2])>1)
		SEND PACKET:C103($doc; "agent en doublon ID_agent "+$TID{$i}+Char:C90(Retour à la ligne:K15:40))
		$error:=True:C214
	End if 
End for 

// verification d'unicité de competences
ALL RECORDS:C47([COMPETENCES:4])
SELECTION TO ARRAY:C260([COMPETENCES:4]id_affectation:2; $TIDAffect; [COMPETENCES:4]competence:3; $Tcompet)
For ($i; 1; Size of array:C274($TIDAffect))
	QUERY:C277([COMPETENCES:4]; [COMPETENCES:4]id_affectation:2=$TIDAffect{$i}; *)
	QUERY:C277([COMPETENCES:4]; [COMPETENCES:4]competence:3=$Tcompet{$i})
	If (Records in selection:C76([COMPETENCES:4])>1)
		SEND PACKET:C103($doc; "competence en doublon matricule "+[COMPETENCES:4]Matricule:4+Char:C90(Retour à la ligne:K15:40))
		$error:=True:C214
	End if 
End for 


$0:=$error

