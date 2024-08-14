//%attributes = {}
C_OBJECT:C1216($response)
C_OBJECT:C1216($requete)

$codeNF:="C02.11.01"
$codeTypeLieu:="L01.02.02"
$codeRMS:="M24.01"
$codeNbVictimes:="P01"
ARRAY OBJECT:C1221($rms; 0)
APPEND TO ARRAY:C911($rms; New object:C1471("code"; "R88"; "label"; "Victime face à danger immédiat"))
APPEND TO ARRAY:C911($rms; New object:C1471("code"; "R87"; "label"; "Victime piégée, coincée"))

ARRAY OBJECT:C1221($dio; 0)
APPEND TO ARRAY:C911($dio; New object:C1471("code_type"; "D13"; "code_valeur"; 3; "label_type"; "Local à sommeil"; "label_valeur"; "Niv. 3 - Partiellement maîtrisé"))
APPEND TO ARRAY:C911($dio; New object:C1471("code_type"; "D101"; "code_valeur"; 5; "label_type"; "Hauteur des bâtiments d'habitations"; "label_valeur"; "Hauteur des bâtiments d'habitations : 8m à 18m"))

ARRAY OBJECT:C1221($ega; 0)
APPEND TO ARRAY:C911($ega; New object:C1471("id"; "9001c403-02d9-400c-bbfe-1da335dc04b8"; "label"; "Aéroport Napoléon Bonaparte"))


//$objEGA:=Créer objet("ega"; $ega)
//$objDIO:=Créer objet("dio"; $dio)
$objCirconstances:=New object:C1471("code_nature_de_fait"; $codeNF; "code_type_de_lieu"; $codeTypeLieu; "code_mrms"; $codeRMS; "rms"; $rms; "nombre_victimes"; $codeNbVictimes)
$requete:=New object:C1471("id_operation"; "string"; "id_transaction"; "string"; "id_correlation"; "string"; "code_sis"; "02a-sis"; "tag_aiguillage"; "SIMU"; "circonstances"; $objCirconstances; "dio"; $dio; "ega"; $ega)
$requeteTexte:=JSON Stringify:C1217($requete)

ARRAY TEXT:C222(TNomEntetes; 0)
ARRAY TEXT:C222(TValeursEntetes; 0)
APPEND TO ARRAY:C911(TNomEntetes; "Accept")
APPEND TO ARRAY:C911(TValeursEntetes; "application/json, text/plain, */*")
APPEND TO ARRAY:C911(TNomEntetes; "Authorization")
APPEND TO ARRAY:C911(TValeursEntetes; "Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJDZTdHcDhLXzJabDlOYnBse.eyJleHAiOjE3MDIyNDgyODksImlhdCI6MTcwMjI0Nzk4OSwiYXV0aF90aW1lIjoxNzAyMjQ3OTg2LCJqdGkiOiJhMGVhNzI5Yy05NjQ3LTQyOGEtYWMxNC1jNTdkNzhmMWRhODIiLCJpc3MiOiJodHRwczovL25leHNpcy5wcm"+"9kLm5leHNpczE4LTExMi5mci9hdXRoL3JlYWxtcy9uZXhzaXMiLCJhdWQiOlsibmV4c2lzLXJlcGVydG9pcmU.CrgyRbUWE5NssGR5e8LTvkY3tKftwcT8Y1O-r4bqqCukt_yzumLwJCg7BtX22MA9TtyrlUFcyK-5JP_oaVLim1oXy-SMWRWlk5Yapt7JA4ngGNcCPDwg8mwzTJk5EXgwLe-rAEMPrr2YilRBpexhbNGTaCzih8o1pIhKJ"+"iO7mFSg0f-XJNDzlsksMnPrSuu1X9NKovveNKu7ZEFrjvNDqhWbLKmaNd_ns1XCUO307ScdD3OqQTkZNWSq1xVDIgG-Y1F4xOpKtw")
APPEND TO ARRAY:C911(TNomEntetes; "Content-Type")
APPEND TO ARRAY:C911(TValeursEntetes; "application/json")
//AJOUTER À TABLEAU(TNomEntetes; "traceparent")
//AJOUTER À TABLEAU(TValeursEntetes; "00-c2aa7f9ec97ad591d5a0efabb978d06b-70aa3e890ce204a5-01")
//AJOUTER À TABLEAU(TNomEntetes; "Origin")
//AJOUTER À TABLEAU(TValeursEntetes; "https://nexsis.prod.nexsis18-112.fr")
//AJOUTER À TABLEAU(TNomEntetes; "Referer")
//AJOUTER À TABLEAU(TValeursEntetes; "https://nexsis.prod.nexsis18-112.fr/admin/administration/02a-sis/regles/moteur-regles")
//AJOUTER À TABLEAU(TNomEntetes; "Sec-Fetch-Dest")
//AJOUTER À TABLEAU(TValeursEntetes; "empty")
//AJOUTER À TABLEAU(TNomEntetes; "Sec-Fetch-Mode")
//AJOUTER À TABLEAU(TValeursEntetes; "cors")
//AJOUTER À TABLEAU(TNomEntetes; "Sec-Fetch-Site")
//AJOUTER À TABLEAU(TValeursEntetes; "same-origin")
//AJOUTER À TABLEAU(TNomEntetes; "TE")
//AJOUTER À TABLEAU(TValeursEntetes; "trailers")


//$httpStatus:=HTTP Request(HTTP méthode POST; "https://nexsis.prod.nexsis18-112.fr/admin-moteur/api/editeur/simuler?sis=02a-sis"; $requeteTexte; $response; TNomEntetes; TValeursEntetes; *)
$httpStatus:=HTTP Request:C1158(HTTP méthode POST:K71:2; "https://formation.qualif.scw.ansc.fr/admin-moteur/api/editeur/simuler?sis=02a-sis"; $requeteTexte; $response; TNomEntetes; TValeursEntetes; *)
