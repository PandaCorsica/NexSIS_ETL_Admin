//%attributes = {}
$centre:=$1  // le centre concerné par l'export
DDF_Recupere_LDG_MoisEnCours($centre)

// Creation du document
$doc:=New object:C1471("version"; 1; "dateCreation"; Timestamp:C1445; "dateModified"; Timestamp:C1445)
$doc.spreadJS:=New object:C1471("version"; "13.0.6"; "sheetCount"; 5; "sheets"; New object:C1471)
//
// Creation du premier onglet avec les CRSS rejetes
$sheet:=New object:C1471("name"; "CRSS rejetes"; "rowCount"; 100; "columnCount"; 20)
$doc.spreadJS.sheets[$sheet.name]:=$sheet
//
// Lignes d'entete
$sheet.data:=New object:C1471("dataTable"; New object:C1471)
$sheet.data.dataTable["0"]:=New object:C1471  // first row
$sheet.data.dataTable["0"]["0"]:=New object:C1471("value"; "Centre")  // set A1
$sheet.data.dataTable["0"]["1"]:=New object:C1471("value"; "Date")  // set B1
$sheet.data.dataTable["0"]["2"]:=New object:C1471("value"; "Numero CRSS")  // set C1
$sheet.data.dataTable["0"]["3"]:=New object:C1471("value"; "Motif rejet")  // set D1

// on va récupérer tous les rapports concernés du centre
QUERY:C277([crss_validation:154]; [crss_validation:154]etat_validation:4="REFUSE"; *)
QUERY:C277([crss_validation:154];  | ; [crss_validation:154]etat_validation:4="A REFUSER"; *)
QUERY:C277([crss_validation:154]; [crss_validation:154]unite_fonctionnelle:8=$centre)
If (Records in selection:C76([crss_validation:154])#0)
	ORDER BY:C49([crss_validation:154]; [crss_validation:154]numero_operation:21; >)
	$count:=0
	While (Not:C34(End selection:C36([crss_validation:154])))
		$count:=$count+1
		$countString:=String:C10($count)
		If (Substring:C12([crss_validation:154]numero_operation:21; 1; 3)="SIS")
			$num2Use:=Substring:C12([crss_validation:154]numero_operation:21; 7)
		Else 
			$num2Use:=[crss_validation:154]numero_operation:21
		End if 
		$myDate:=Substring:C12($num2Use; 7; 2)+"/"+Substring:C12($num2Use; 5; 2)+"/"+Substring:C12($num2Use; 1; 4)
		$sheet.data.dataTable[$countString]:=New object:C1471  // first row
		$sheet.data.dataTable[$countString]["0"]:=New object:C1471("value"; $centre)  // set A1
		$sheet.data.dataTable[$countString]["1"]:=New object:C1471("value"; $myDate)  // set B1
		$sheet.data.dataTable[$countString]["2"]:=New object:C1471("value"; [crss_validation:154]numero_operation:21)  // set C1
		$sheet.data.dataTable[$countString]["3"]:=New object:C1471("value"; [crss_validation:154]message:14)  // set D1
		
		NEXT RECORD:C51([crss_validation:154])
	End while 
End if 
// Creation du 2e onglet avec les CRSS à valider
$sheet2:=New object:C1471("name"; "CRSS à valider"; "rowCount"; 100; "columnCount"; 20)
$doc.spreadJS.sheets[$sheet2.name]:=$sheet2
//
// Lignes d'entete
$sheet2.data:=New object:C1471("dataTable"; New object:C1471)
$sheet2.data.dataTable["0"]:=New object:C1471  // first row
$sheet2.data.dataTable["0"]["0"]:=New object:C1471("value"; "Centre")  // set A1
$sheet2.data.dataTable["0"]["1"]:=New object:C1471("value"; "Date")  // set B1
$sheet2.data.dataTable["0"]["2"]:=New object:C1471("value"; "Numero CRSS")  // set C1

// on va récupérer tous les rapports concernés du centre
QUERY:C277([crss_traitement:143]; [crss_traitement:143]etat_validation:15="pas validée"; *)
QUERY:C277([crss_traitement:143]; [crss_traitement:143]etat_redaction_moyen:14="rédigé"; *)
QUERY:C277([crss_traitement:143]; [crss_traitement:143]uf_moyen:6=$centre)
QUERY SELECTION BY FORMULA:C207([crss_traitement:143]; Not:C34((([crss_traitement:143]etat_redaction_cos:13="à rédiger") | ([crss_traitement:143]etat_redaction_cos:13="brouillon")) & ([crss_traitement:143]agent_redacteur_cos_est_dans_uf:12=True:C214)))
If (Records in selection:C76([crss_traitement:143])#0)
	ORDER BY:C49([crss_traitement:143]; [crss_traitement:143]numero_operation:3; >)
	$count:=0
	While (Not:C34(End selection:C36([crss_traitement:143])))
		$count:=$count+1
		$countString:=String:C10($count)
		$sheet2.data.dataTable[$countString]:=New object:C1471  // first row
		$sheet2.data.dataTable[$countString]["0"]:=New object:C1471("value"; $centre)  // set A1
		$sheet2.data.dataTable[$countString]["1"]:=New object:C1471("value"; String:C10(Date:C102([crss_traitement:143]created_at:4)))  // set B1
		$sheet2.data.dataTable[$countString]["2"]:=New object:C1471("value"; [crss_traitement:143]numero_operation:3)  // set C1
		
		NEXT RECORD:C51([crss_traitement:143])
	End while 
End if 

// Creation du 3e onglet avec les CRSS à rédiger
$sheet3:=New object:C1471("name"; "CRSS à rédiger"; "rowCount"; 100; "columnCount"; 20)
$doc.spreadJS.sheets[$sheet3.name]:=$sheet3
//
// Lignes d'entete
$sheet3.data:=New object:C1471("dataTable"; New object:C1471)
$sheet3.data.dataTable["0"]:=New object:C1471  // first row
$sheet3.data.dataTable["0"]["0"]:=New object:C1471("value"; "Centre")  // set A1
$sheet3.data.dataTable["0"]["1"]:=New object:C1471("value"; "Date")  // set B1
$sheet3.data.dataTable["0"]["2"]:=New object:C1471("value"; "Numero CRSS")  // set C1
$sheet3.data.dataTable["0"]["3"]:=New object:C1471("value"; "Engin")  // set D1
$sheet3.data.dataTable["0"]["4"]:=New object:C1471("value"; "Chef Agres")  // set E1

// on va récupérer tous les rapports concernés du centre
QUERY:C277([crss_traitement:143]; [crss_traitement:143]etat_redaction_moyen:14="à rédiger"; *)
QUERY:C277([crss_traitement:143];  | ; [crss_traitement:143]etat_redaction_moyen:14="brouillon"; *)
QUERY:C277([crss_traitement:143]; [crss_traitement:143]uf_moyen:6=$centre)
CREATE SET:C116([crss_traitement:143]; "engin")
QUERY:C277([crss_traitement:143]; [crss_traitement:143]etat_redaction_cos:13="à rédiger"; *)
QUERY:C277([crss_traitement:143];  | ; [crss_traitement:143]etat_redaction_cos:13="brouillon"; *)
QUERY:C277([crss_traitement:143]; [crss_traitement:143]agent_redacteur_cos_est_dans_uf:12=True:C214; *)
QUERY:C277([crss_traitement:143]; [crss_traitement:143]uf_moyen:6=$centre)
CREATE SET:C116([crss_traitement:143]; "cos")
UNION:C120("engin"; "cos"; "engin")
USE SET:C118("engin")
CLEAR SET:C117("engin")
CLEAR SET:C117("cos")

If (Records in selection:C76([crss_traitement:143])#0)
	ORDER BY:C49([crss_traitement:143]; [crss_traitement:143]numero_operation:3; >)
	$count:=0
	While (Not:C34(End selection:C36([crss_traitement:143])))
		$count:=$count+1
		$countString:=String:C10($count)
		QUERY:C277([crss_agent:99]; [crss_agent:99]id_engin:2=[crss_traitement:143]id_engin:8; *)
		QUERY:C277([crss_agent:99]; [crss_agent:99]code_poste_mission:15="CA")
		$sheet3.data.dataTable[$countString]:=New object:C1471  // first row
		$sheet3.data.dataTable[$countString]["0"]:=New object:C1471("value"; $centre)  // set A1
		$sheet3.data.dataTable[$countString]["1"]:=New object:C1471("value"; String:C10(Date:C102([crss_traitement:143]created_at:4)))  // set B1
		$sheet3.data.dataTable[$countString]["2"]:=New object:C1471("value"; [crss_traitement:143]numero_operation:3)  // set C1
		$sheet3.data.dataTable[$countString]["3"]:=New object:C1471("value"; [crss_traitement:143]code_engin:9)  // set D1
		If (Records in selection:C76([crss_agent:99])=0)
			$sheet3.data.dataTable[$countString]["4"]:=New object:C1471("value"; "Inconnu")  // set E1
		Else 
			$sheet3.data.dataTable[$countString]["4"]:=New object:C1471("value"; [crss_agent:99]nom:11+" "+[crss_agent:99]prenom:12)  // set E1
		End if 
		
		NEXT RECORD:C51([crss_traitement:143])
	End while 
End if 

// Creation du 4e onglet avec les Plannings à valider
$sheet4:=New object:C1471("name"; "Plannings à valider"; "rowCount"; 100; "columnCount"; 20)
$doc.spreadJS.sheets[$sheet4.name]:=$sheet4
//
// Lignes d'entete
$sheet4.data:=New object:C1471("dataTable"; New object:C1471)
$sheet4.data.dataTable["0"]:=New object:C1471  // first row
$sheet4.data.dataTable["0"]["0"]:=New object:C1471("value"; "Centre")  // set A1
$sheet4.data.dataTable["0"]["1"]:=New object:C1471("value"; "Date")  // set B1
$sheet4.data.dataTable["0"]["2"]:=New object:C1471("value"; "Agent")  // set C1
$sheet4.data.dataTable["0"]["3"]:=New object:C1471("value"; "Position administrative")  // set D1

// on va récupérer tous les rapports concernés du centre
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]nom_agent_valideur_1:20=Null:C1517; *)
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]nom_agent_valideur_2:26=Null:C1517; *)
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]date_archivage:18=Null:C1517; *)
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]code_unite_fonctionnelle:10=$centre)
QUERY SELECTION BY FORMULA:C207([fdg_service_fait:124]; [fdg_service_fait:124]mois:43=Month of:C24(Current date:C33); *)
QUERY SELECTION BY FORMULA:C207([fdg_service_fait:124]; [fdg_service_fait:124]annee:42=Year of:C25(Current date:C33))
If (Records in selection:C76([fdg_service_fait:124])#0)
	ORDER BY:C49([fdg_service_fait:124]; [fdg_service_fait:124]date_debut:12; >; [fdg_service_fait:124]nom:3; >; [fdg_service_fait:124]prenom:4; >)
	$count:=0
	While (Not:C34(End selection:C36([fdg_service_fait:124])))
		$count:=$count+1
		$countString:=String:C10($count)
		$sheet4.data.dataTable[$countString]:=New object:C1471  // first row
		$sheet4.data.dataTable[$countString]["0"]:=New object:C1471("value"; $centre)  // set A1
		$sheet4.data.dataTable[$countString]["1"]:=New object:C1471("value"; String:C10(Date:C102([fdg_service_fait:124]date_debut:12)))  // set B1
		$sheet4.data.dataTable[$countString]["2"]:=New object:C1471("value"; [fdg_service_fait:124]nom:3+" "+[fdg_service_fait:124]prenom:4)  // set C1
		$sheet4.data.dataTable[$countString]["3"]:=New object:C1471("value"; [fdg_service_fait:124]libelle_position_administrative:37)  // set D1
		
		NEXT RECORD:C51([fdg_service_fait:124])
	End while 
	$sheet4.rowCount:=$count+1
End if 

// Creation du 5e onglet avec les Plannings sans position administrative
$sheet5:=New object:C1471("name"; "Plannings sans position administrative"; "rowCount"; 100; "columnCount"; 20)
$doc.spreadJS.sheets[$sheet5.name]:=$sheet5
//
// Lignes d'entete
$sheet5.data:=New object:C1471("dataTable"; New object:C1471)
$sheet5.data.dataTable["0"]:=New object:C1471  // first row
$sheet5.data.dataTable["0"]["0"]:=New object:C1471("value"; "Centre")  // set A1
$sheet5.data.dataTable["0"]["1"]:=New object:C1471("value"; "Date")  // set B1
$sheet5.data.dataTable["0"]["2"]:=New object:C1471("value"; "Heure")  // set C1
$sheet5.data.dataTable["0"]["3"]:=New object:C1471("value"; "Agent")  // setD1

// on va récupérer tous les rapports concernés du centre
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]code_position_administrative:36=Null:C1517; *)
QUERY:C277([fdg_service_fait:124];  | ; [fdg_service_fait:124]code_position_administrative:36=""; *)
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]source:33="prod"; *)
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]date_archivage:18=Null:C1517; *)
QUERY:C277([fdg_service_fait:124]; [fdg_service_fait:124]code_unite_fonctionnelle:10=$centre)
QUERY SELECTION BY FORMULA:C207([fdg_service_fait:124]; [fdg_service_fait:124]mois:43=Month of:C24(Current date:C33); *)
QUERY SELECTION BY FORMULA:C207([fdg_service_fait:124]; [fdg_service_fait:124]annee:42=Year of:C25(Current date:C33))
If (Records in selection:C76([fdg_service_fait:124])#0)
	ORDER BY:C49([fdg_service_fait:124]; [fdg_service_fait:124]date_debut:12; >; [fdg_service_fait:124]nom:3; >; [fdg_service_fait:124]prenom:4; >)
	$count:=0
	While (Not:C34(End selection:C36([fdg_service_fait:124])))
		$count:=$count+1
		$countString:=String:C10($count)
		$sheet5.data.dataTable[$countString]:=New object:C1471  // first row
		$sheet5.data.dataTable[$countString]["0"]:=New object:C1471("value"; $centre)  // set A1
		$sheet5.data.dataTable[$countString]["1"]:=New object:C1471("value"; String:C10(Date:C102([fdg_service_fait:124]date_debut:12)))  // set B1
		$sheet5.data.dataTable[$countString]["2"]:=New object:C1471("value"; String:C10(Time:C179([fdg_service_fait:124]date_debut:12)))  // set C1
		$sheet5.data.dataTable[$countString]["3"]:=New object:C1471("value"; [fdg_service_fait:124]nom:3+" "+[fdg_service_fait:124]prenom:4)  // set D1
		
		NEXT RECORD:C51([fdg_service_fait:124])
	End while 
	$sheet5.rowCount:=$count+1
End if 

//
//$doc contient le document en jSON

//on peut maintenant faire son export en excel
// Creates an offscreen object from the Offscreen class. This object will be pass in parameter to VP Run offscreen area command 
C_OBJECT:C1216($offscreen)
C_TEXT:C284($cheminExport)
$cheminExport:="C:\\temp\\"
$offscreen:=cs:C1710.Offscreen.new($doc; $cheminExport; $centre)

$result:=VP Run offscreen area($offscreen)
$0:=$cheminExport+$centre
