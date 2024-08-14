C_TEXT:C284(URLText_t)
C_BLOB:C604(Text_t)
C_COLLECTION:C1488(myResult; myResultFiltered; $test)
Case of 
	: (vPra=1)
		$valenv:="pra"
	: (vForm=1)
		$valenv:="form"
	: (vMad=1)
		$valenv:="mad"
End case 

//URLText_t:="https://data.nexsis18-112.fr:443/api/2a/"+TTables{TTables}

//TABLEAU TEXTE(HeaderNames_at; 1)
//TABLEAU TEXTE(HeaderValues_at; 1)
//HeaderNames_at{1}:="Authorization"
//HeaderValues_at{1}:="Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoic2lzMDJhIn0.Bxie55h7NJSDj3jxXAJJVgcLJaflf1h4leq0i0gWuhg"
////$httpResponse:=HTTP Request(HTTP méthode GET; URLText_t; ""; Text_t; HeaderNames_at; HeaderValues_at)
//$httpResponse:=HTTP Get(URLText_t; Text_t; HeaderNames_at; HeaderValues_at)
//$return_Text:=BLOB vers texte(Text_t; UTF8 chaîne en C)
//myResult:=JSON Parse($return_Text)
////COLLECTION VERS TABLEAU(myResult; TNumeros; "numero")

//// On va filtrer sur la source
//myResultFiltered:=myResult.filter("Filtrage_Collection_Par_Source"; $valenv)
//Si (TChamps{TChamps}#"")
//myResultFiltered:=myResultFiltered.query(":1 =:2"; TChamps{TChamps}; vValeur)
//Fin de si 

$ptrTable:=Table:C252(TNumTables{TTables})
$vlTable:=Table:C252($ptrTable)
ARRAY TEXT:C222($taChamps; Get last field number:C255($vlTable))
$numChamp:=0
For ($vlChamp; Size of array:C274($taChamps); 1; -1)
	If (Is field number valid:C1000($vlTable; $vlChamp))
		If (Field name:C257($vlTable; $vlChamp)="source")
			$numChamp:=$vlChamp
			$vlChamp:=1
		End if 
	End if 
End for 
If ($numChamp=0)
	TRACE:C157
End if 
$ptrChamp:=Field:C253($vlTable; $numChamp)
QUERY:C277($ptrTable->; $ptrChamp->=$valenv)


//// on efface les colonnes de la LB
//$nbCol:=LISTBOX Lire nombre colonnes(*; "LBResult")
//LISTBOX SUPPRIMER COLONNE(*; "LBResult"; 1; $nbCol)
//Boucle ($i; 1; Taille tableau(TChamps))
//Si (Sous chaîne(TChamps{$i}; 1; 1)#"#")
//$ptrCol:=Pointeur vers("colLB"+Chaîne($i))
//$ptrChamp:=Champ($vlTable; $i)
//LISTBOX INSÉRER COLONNE FORMULE(*; "LBResult"; $i; TChamps{$i}; "This."+TChamps{$i}; Est un texte; "JTHeader"+Chaîne($i); $ptrCol->)
//OBJET FIXER TITRE($ptrCol->; TChamps{$i})
//Fin de si 
//Fin de boucle 

FORM SET OUTPUT:C54("["+Table name:C256($ptrTable)+"]"; "export")