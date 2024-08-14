//%attributes = {}
$TS:=$1

$nbJours:=$TS\86400

$jour:=Add to date:C393(!1970-01-01!; 0; 0; $nbJours)

$0:=$jour
