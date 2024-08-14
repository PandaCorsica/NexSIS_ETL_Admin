//%attributes = {}
$doc:=Create document:C266(Get 4D folder:C485(Dossier base:K5:14)+"RSR.CSV"; ".csv")
If (OK=1)
	SEND PACKET:C103($doc; "code_intervenant"+";")
	SEND PACKET:C103($doc; "famille"+";")
	SEND PACKET:C103($doc; "protocole"+";")
	SEND PACKET:C103($doc; "valeur"+Char:C90(Retour à la ligne:K15:40))
	
	
	ALL RECORDS:C47([RSR:16])
	While (Not:C34(End selection:C36([RSR:16])))
		SEND PACKET:C103($doc; [RSR:16]code_intervenant:2+";")
		SEND PACKET:C103($doc; [RSR:16]famille:3+";")
		SEND PACKET:C103($doc; [RSR:16]protocole:4+";")
		SEND PACKET:C103($doc; [RSR:16]valeur:5+Char:C90(Retour à la ligne:K15:40))
		
		
		NEXT RECORD:C51([RSR:16])
	End while 
	CLOSE DOCUMENT:C267($doc)
End if 
