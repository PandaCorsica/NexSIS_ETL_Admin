//%attributes = {}
// au moment de l'exécution de cette méthode, tous les PARTICIPATION_ENGIN et PARTICIPATION_AGENT ont été remplis et DONNEES INTER est en mémoire

//$numRappport:=$1
$messageErreur:=""

RELATE MANY:C262([DONNEES_INTERS:158]ID:1)
QUERY SELECTION:C341([PARTICIPATION_AGENT:163]; [PARTICIPATION_AGENT:163]Archivage:20=False:C215)
QUERY SELECTION:C341([PARTICIPATION_ENGIN:164]; [PARTICIPATION_ENGIN:164]Archivage:15=False:C215)
Case of 
	: (Records in selection:C76([PARTICIPATION_ENGIN:164])=0)
		$messageErreur:="Pas d'engin armé en personnel sur l'intervention"
	: (Records in selection:C76([PARTICIPATION_AGENT:163])=0)
		$messageErreur:="Pas de personnels sur l'intervention"
	Else 
		// on teste d'abord s'il y a plusieurs engins du même nom sur le rapport
		$messageErreur:=Teste_Engin_en_Double
		If ($messageErreur="")
			// on teste s'il y a des personnels en double sur le meme CRSS
			Teste_Personnel_en_Double
			
		End if 
End case 



$0:=$messageErreur