//%attributes = {}
ARRAY TEXT:C222($TSelect; 0)
$doc:=Select document:C905(""; "*"; "Choix fu fichier"; 0; $TSelect)
$liste:=Document to text:C1236($TSelect{1})

$pos:=Position:C15("("; $liste)
While ($pos>0)
	If ($pos>0)
		$liste:=Substring:C12($liste; $pos+1)
		$pos2:=Position:C15(")"; $liste)
		$code:=Substring:C12($liste; 1; $pos2-1)
		If (Num:C11($code)#0)
			CREATE RECORD:C68([ALGERIE:31])
			[ALGERIE:31]insee:2:=$code
			SAVE RECORD:C53([ALGERIE:31])
		End if 
		
		$liste:=Substring:C12($liste; $pos2+1)
	End if 
	$pos:=Position:C15("("; $liste)
End while 
