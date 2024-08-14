//%attributes = {}

$TS:=$1

$nbJours:=$TS\86400

$restant:=$TS-($nbJours*86400)

$heures:=$restant\3600

$minutes:=($restant-($heures*3600))\60



$0:=String:C10($heures; "00")+":"+String:C10($minutes; "00")

