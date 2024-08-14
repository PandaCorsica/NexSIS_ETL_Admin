//%attributes = {}
//CORS Domains Settings
$settings:=New collection:C1472
$settings.push(New object:C1471("host"; "127.0.0.1:5500"; "methods"; "get;post"))

//enable CORS
WEB SET OPTION:C1210(Web CORS activé:K73:33; 1)

//CORS Domains Settings

WEB SET OPTION:C1210(Web propriétés CORS:K73:34; $settings)

