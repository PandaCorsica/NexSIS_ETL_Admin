//%attributes = {}
$datetexte:=$1
$0:=Date:C102(Substring:C12($datetexte; 9; 2)+"/"+Substring:C12($datetexte; 6; 2)+"/"+Substring:C12($datetexte; 1; 4))