//%attributes = {}
$gradeNexsis:=$1
$gradeSystel:="05"  // on met un grade par défaut
$pos:=Position:C15("-SPV"; $gradeNexsis)
If ($pos>0)
	$gradeNexsis:=Substring:C12($gradeNexsis; 1; $pos-1)
End if 

QUERY:C277([IMPORT_GRADE:25]; [IMPORT_GRADE:25]code_Ref:5=$gradeNexsis)
If (Records in selection:C76([IMPORT_GRADE:25])#0)
	$gradeSystel:=[IMPORT_GRADE:25]cle:2
End if 


$0:=$gradeSystel