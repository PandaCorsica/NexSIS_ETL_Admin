//%attributes = {}
$url:="https://nexsis.prod.nexsis18-112.fr/sgo/uf/02a-cgo/operations/1fd808a9-54d8-4309-a7c2-b17c6b39d0e1/suivi-operation/main-courante?statut=A_TRAITER,EN_COURS&tri-operation=par-defaut"

$params:=New object:C1471
// url of the html file with the js function to use
$params.url:=$url

// Add a callback method called on event
$params.onEvent:=Formula:C1597(testWA)

// create offscreen web area according to $params
$title:=WA Run offscreen area:C1727($params)




C_TEXT:C284($answer)
$status:=HTTP Get:C1157($url; $answer)  // this loads the real content

If ($status=200)
	C_OBJECT:C1216($html)
	TRACE:C157
	$answertidy:=RunTidy($answer)  // make it nice XML conform
	If (False:C215)  // debug, step into if you need to check what you received
		SET TEXT TO PASTEBOARD:C523($answertidy)
	End if 
	
	$html:=XMLToObject($answertidy)  // convert to object
	If (False:C215)  // debug
		SET TEXT TO PASTEBOARD:C523(JSON Stringify:C1217($html; *))
	End if 
	
	
	// now we finally parse the content and fetch the needed stuff
	
	$articles:=$html.body.div[0].div.div.div[0].div.article
	$blogposts:=New collection:C1472  // here we collect our data
	For each ($article; $articles)
		$authorurl:=String:C10($article.div[0].div[0].div.img.src)
		$authorname:=String:C10($article.div[0].div[0].span.a.__value)
		$title:=String:C10($article.div[0].span[1].a.title)
		
		CLEAR VARIABLE:C89($content_p)
		$content:=""
		C_VARIANT:C1683($content_p)
		If ($article.div[1].div[1].p#Null:C1517)
			$content_p:=$article.div[1].div[1].p
			If (Value type:C1509($content_p)=Est une collection:K8:32)
				For each ($line; $content_p)
					If ($line.span.__value#Null:C1517)
						$content:=$content+$line.span.__value+Char:C90(13)
					End if 
				End for each 
			Else 
				$content:=String:C10($content_p.span.__value)
			End if 
		End if 
		
		C_PICTURE:C286($pict)
		$status:=HTTP Get:C1157($authorurl; $pict)
		$blogposts.push(New object:C1471("author"; $authorname; "picturl"; $authorurl; "pict"; $pict; "title"; $title; "content"; $content))
	End for each 
	
End if 