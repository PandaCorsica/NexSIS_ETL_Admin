//%attributes = {}
If (Form event code:C388=Sur début chargement URL:K2:45)
	SET TIMER:C645(60*5)
End if 
If (FORM Event:C1606.code=Sur fin chargement URL:K2:47)
	$js:="document.document.getElementsByTagName('body')[0].innerHTML"
	WA EXECUTE JAVASCRIPT FUNCTION:C1043(*; This:C1470.area; "main.77b53ccb9f5013a7.js"; *)
	This:C1470.result:=WA Evaluate JavaScript:C1029(*; This:C1470.area; $js)
	$texte:=WA Get page content:C1038(*; This:C1470.area)
	SET TIMER:C645(0)
End if 
