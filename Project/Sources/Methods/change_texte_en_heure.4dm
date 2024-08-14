//%attributes = {}
$heuretexte:=$1
$0:=Time:C179(Substring:C12($heuretexte; 1; 2)+":"+Substring:C12($heuretexte; 4; 2)+":00")