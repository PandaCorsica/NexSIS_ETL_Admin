//%attributes = {}
// http://tidy.sourceforge.net

$in:=Replace string:C233($1; "&nbsp;"; "")  // remove none breaking space, they might disturb XML conversion
$in:=Replace string:C233($in; "&#160;"; "")


If (Is macOS:C1572)
	$tidypath:=Convert path system to POSIX:C1106(Get 4D folder:C485(Dossier Resources courant:K5:16)+"mac"+Séparateur dossier:K24:12+"tidy")
Else 
	$tidypath:="C:\\Program Files\\tidy 5.8.0\\bin\\tidy"
	//$tidypath:=Dossier 4D(Dossier Resources courant)+"win"+Séparateur dossier+"Tidy.exe"
End if 

$command:=Char:C90(34)+$tidypath+Char:C90(34)+" --tidy-mark no --output-xhtml y -wrap 0 --bare y --word-2000 y --show-warnings n --custom-tags blocklevel"
$out:=""
$error:=""
SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "true")
LAUNCH EXTERNAL PROCESS:C811($command; $in; $out; $error)

$0:=$out