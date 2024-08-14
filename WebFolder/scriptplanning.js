const urlServeur = 'http://192.168.210.153';

var lundi;

document.addEventListener('DOMContentLoaded', () => {
        lundi = trouverLundiSemaineActuelle();
    	chargerCentres();

        loadPlannings(lundi);

    });
	
function chargerCentres() {
    // def: Charge la liste des centres depuis le serveur et les ajoute à un élément <select> dans le document HTML.
    // in: Aucune
    // out: Affiche les centres dans un élément <select> dans le document HTML
    
    const url = urlServeur + '/listecentres';
    fetch(url)
        .then(response => response.json()) // Convertir la réponse en JSON
        .then(data => {
            const selectCentre = document.getElementById('centre-select');
            data.forEach(centre => {
                const option = document.createElement('option');
                option.value = centre.code;
                option.textContent = centre.libelle;
                selectCentre.appendChild(option);
            });
        })
        .catch(error => console.error('Erreur lors du chargement des centres:', error));
}

	
	function miseAJourTableau (jsonData){
        document.getElementById('table-title').textContent = jsonData.title;

        const headerRow1 = document.getElementById('headerRow1');
        const headerRow2 = document.getElementById('headerRow2');
        const headerRow3 = document.getElementById('headerRow3');

        // Première ligne d'en-tête
        for (let i = 0; i < jsonData.header1.length; i++) {
            let th = document.createElement('th');
            th.colSpan = i === 0 || i === 1 ? 1 : 2;  // Les deux premières colonnes alignées
            th.textContent = jsonData.header1[i];
            headerRow1.appendChild(th);
        }

        // Deuxième ligne d'en-tête
//        let emptyTh1 = document.createElement('th');
//        let emptyTh2 = document.createElement('th');
//        headerRow2.appendChild(emptyTh1);
//        headerRow2.appendChild(emptyTh2);
        for (let i = 0; i < 16; i++) {
            let th = document.createElement('th');
            if (i==0){
                th.textContent = 'Noms';
            }else{
            if (i==1){
                th.textContent = 'Statut';
            }else{
            th.textContent = i % 2 === 0 ? 'J' : 'N';
            }};
            th.onclick = function() { sortTable(i); };
            headerRow2.appendChild(th);
        }

        // Troisième ligne d'en-tête
        for (let i = 0; i < 16; i++) {
            let th = document.createElement('th');
            if (i<2){
                th.textContent = ``;
            }else{
                th.textContent = `🔎`;
                th.onclick = function() { ouvrirPopup(jsonData.compte[i]); };
            };
            headerRow3.appendChild(th);
        }

        const tbody = document.querySelector('#dataTable tbody');

        jsonData.data.forEach(row => {
            const tr = document.createElement('tr');
            row.forEach(cell => {
                const td = document.createElement('td');
                td.textContent = cell;
                td.style.backgroundColor = getColorBasedOnValue(cell);
                td.style.color = getFrontColorBasedOnValue(cell);
                tr.appendChild(td);
            });
            tbody.appendChild(tr);
        });
		// on fixe le sens de tri sur ascendant au départ
		sortTable(-1); // on trie le tableau par ordre alphabétique au chargement
		
	}

    function loadPlannings(dateLundi){
		var centreSelectionne = document.getElementById('centre-select').value;
		if (centreSelectionne==''){
			centreSelectionne='OPS';
		};
        const url = urlServeur+'/planningSemaine?uf='+centreSelectionne+'&date='+dateLundi;
		fetch(url, {
			method: 'GET',
			headers: {
				'Content-Type': 'application/json'
			}
		})
            .then(response => response.json())
            .then(data => {
                 miseAJourTableau(data);
            })
            .catch(error => {
                const emptyData = {
                    title: "Erreur de chargement",
                    header1: ["", "", "L", "M", "Me", "J", "V", "S", "D"],
                    compte: ["","","","","", "","","","","","","","","","",""],
                        data: [["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
                ]};
                miseAJourTableau(emptyData);
            });

    }

    function sortTable(columnIndex) {
        const table = document.getElementById('dataTable');
        const tbody = table.tBodies[0];
        const rows = Array.from(tbody.rows);
		// cas particulier si on a passé -1 en parametre pour le premier chargement
       if (columnIndex==-1){
			table.setAttribute('data-sort-order', 'desc');
			columnIndex = 0;
	   };
	   const isAscending = table.getAttribute('data-sort-order') !== 'asc';

        rows.sort((a, b) => {
            const cellA = a.cells[columnIndex].textContent;
            const cellB = b.cells[columnIndex].textContent;
            return isAscending ? cellA.localeCompare(cellB) : cellB.localeCompare(cellA);
        });

        rows.forEach(row => tbody.appendChild(row));
        table.setAttribute('data-sort-order', isAscending ? 'asc' : 'desc');
    }

    function showPopup(val) {
        alert(val);
    }

function changeCentre (){
	effacerLignesTableau('dataTable');
    loadPlannings(lundi);	
}

function semainePrecedente (){
	var newLundi = new Date(lundi);
	newLundi.setDate(newLundi.getDate() - 7);
	effacerLignesTableau('dataTable');
	lundi = newLundi.toISOString().split('T')[0];
    loadPlannings(lundi);	
}

function semaineSuivante (){
	var newLundi = new Date(lundi);
	newLundi.setDate(newLundi.getDate() + 7);
	effacerLignesTableau('dataTable');
	lundi = newLundi.toISOString().split('T')[0];
    loadPlannings(lundi);	
}

	
 
    function trouverLundiSemaineActuelle() {
        const aujourdhui = new Date();
        const jourSemaine = aujourdhui.getDay(); // Sunday is 0, Monday is 1, ..., Saturday is 6
        const jourCorrection = jourSemaine === 0 ? 6 : jourSemaine - 1; // Corrige le jour pour que lundi soit 0
        const lundiSemaineActuelle = new Date(aujourdhui);
    
        lundiSemaineActuelle.setDate(aujourdhui.getDate() - jourCorrection);
		lundi = lundiSemaineActuelle;
        return lundiSemaineActuelle.toISOString().split('T')[0]; // Retourne la date au format YYYY-MM-DD
    }


    function getColorBasedOnValue(value) {
        switch (value) {
            case 'SPP' :
                return '#F5BCA9';
            case 'SMO' :
                return '#81BEF7';
            case 'PLG' :
                return '#81BEF7';
            case 'G' :
                return '#088A08';
            case 'CDT' :
                return '#F847E0';
            case 'GIFF' :
                return '#00525C';
            case 'GR' :
                return '#00FF00';
            case 'GCO' :
                return '#00FF00';
            case 'PEL' :
                return '#00FF00';
            case 'HBE' :
                return '#00FF00';
            case 'STAT' :
                return '#00FF00';
            case 'A' :
                return '#9A2EFF';
            case 'FDF' :
                return '#FF0000';
            case 'CDO' :
                return '#FF0000';
            case 'R' :
                return '#71F4FF';
            case 'PM' :
                return '#FFDA71';
            default :
                return '#FFFFFF'
        }
   }

    function getFrontColorBasedOnValue(value) {
        switch (value) {
            case 'G' :
                return '#FFFFFF';
            case 'CDT' :
                return '#FFFFFF';
            case 'GIFF' :
                return '#FFFFFF';
            case 'A' :
                return '#FFFFFF';
            case 'FDF' :
                return '#FFFFFF';
            case 'CDO' :
                return '#FFFFFF';
            default :
                return '#000000'
        }
   }


	function effacerLignesTableau(idTableau) {
		const tableau = document.getElementById(idTableau);
		const thead = tableau.getElementsByTagName('thead')[0];
		const tbody = tableau.getElementsByTagName('tbody')[0];
		// Vérifier si le tbody existe
		if (tbody) {
			while (tbody.rows.length > 0) {
				tbody.deleteRow(0);
			}
		}
		if (thead) {
			// Effacer les colonnes dans thead
			for (i=0;i<3;i++){
				thead.deleteRow(0)
				}	
		}
		// on remet les lignes d'entete
		const nouvelleLigne3 = thead.insertRow(0);
		nouvelleLigne3.id = "headerRow3";
		const nouvelleLigne2 = thead.insertRow(0);
		nouvelleLigne2.id = "headerRow2";
		const nouvelleLigne1 = thead.insertRow(0);
		nouvelleLigne1.id = "headerRow1";
	}



    // Fonction pour ouvrir le popup
    function ouvrirPopup(contenu) {
        document.getElementById('popup').style.display = 'block';
        document.getElementById('overlay').style.display = 'block';
        document.getElementById('popup').innerText = contenu;
    }

    // Fonction pour fermer le popup
    function fermerPopup() {
        document.getElementById('popup').style.display = 'none';
        document.getElementById('overlay').style.display = 'none';
    }
