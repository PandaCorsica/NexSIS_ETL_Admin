


function ouvrircrss() {
	const idcrss = document.getElementById('idcrss').value;
    const ufcrss = document.getElementById('ufmoyen').value;
	window.open("https://nexsis.prod.nexsis18-112.fr/crss/uf/"+ufcrss+"/cr-operations/"+idcrss+"/consultation", '_blank');


}

function ouvririnter() {
	const idoperation = document.getElementById('idinter').value;
	window.open("https://nexsis.prod.nexsis18-112.fr/sgo/uf/02a-cgo/operations/"+idoperation+"/suivi-operation/main-courante?statut=A_TRAITER,EN_COURS&tri-operation=par-defaut", '_blank');

}

