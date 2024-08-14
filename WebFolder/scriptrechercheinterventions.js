document.addEventListener('DOMContentLoaded', () => {
    chargerCommunes(); // Charger les communes lors du chargement de la page
	chargerNF0();
});

const urlServeur = 'http://192.168.210.153';  // URL du serveur

function chargerCommunes() {
    // def: Charge la liste des communes depuis le serveur et les ajoute à un élément <select> dans le document HTML.
    // in: Aucune
    // out: Affiche les communes dans un élément <select> dans le document HTML
    
    const url = urlServeur + '/listecommunes';
    fetch(url)
        .then(response => response.json()) // Convertir la réponse en JSON
        .then(data => {
            const selectCommune = document.getElementById('commune-select');
            data.forEach(commune => {
                const option = document.createElement('option');
                option.value = commune.libelle;
                option.textContent = commune.libelle;
                selectCommune.appendChild(option);
            });
        })
        .catch(error => console.error('Erreur lors du chargement des communes:', error));
}

function vidageNF1() {
	const selectNF1 = document.getElementById('NF1-select');
	selectNF1.options.length = 0;
    const option = document.createElement('option');
    option.value = "";
    option.textContent = "Sélectionner une nature de fait N1";
    selectNF1.appendChild(option);
}

function vidageNF2() {
	const selectNF2 = document.getElementById('NF2-select');
	selectNF2.options.length = 0;
    const option = document.createElement('option');
    option.value = "";
    option.textContent = "Sélectionner une nature de fait N2";
    selectNF2.appendChild(option);
}


function chargerNF0() {
    // def: Charge la liste des NF0 depuis le serveur et les ajoute à un élément <select> dans le document HTML.
    // in: Aucune
    // out: Affiche les NF0 dans un élément <select> dans le document HTML
    
    const url = urlServeur + '/listeNF0';
    fetch(url)
        .then(response => response.json()) // Convertir la réponse en JSON
        .then(data => {
            const selectNF0 = document.getElementById('NF0-select');
            data.forEach(NF0 => {
                const option = document.createElement('option');
                option.value = NF0.code;
                option.textContent = NF0.libelle;
                selectNF0.appendChild(option);
            });
			vidageNF1();
			vidageNF2();
        })
        .catch(error => console.error('Erreur lors du chargement des NF0:', error));
}

function chargerNF1() {
    // def: Charge la liste des NF1 corespondant au NF0 depuis le serveur et les ajoute à un élément <select> dans le document HTML.
    // in: Aucune
    // out: Affiche les NF1 dans un élément <select> dans le document HTML
	vidageNF2();
	vidageNF1();
    const NF0 = document.getElementById('NF0-select').value;
    const url = urlServeur + '/listeNF1/'+NF0;
    fetch(url)
        .then(response => response.json()) // Convertir la réponse en JSON
        .then(data => {
            const selectNF1 = document.getElementById('NF1-select');
            data.forEach(NF1 => {
                const option = document.createElement('option');
                option.value = NF1.code;
                option.textContent = NF1.libelle;
                selectNF1.appendChild(option);
            });
        })
        .catch(error => console.error('Erreur lors du chargement des NF1:', error));
}

function chargerNF2() {
    // def: Charge la liste des NF2 corespondant au NF1 depuis le serveur et les ajoute à un élément <select> dans le document HTML.
    // in: Aucune
    // out: Affiche les NF2 dans un élément <select> dans le document HTML
	vidageNF2();
    const NF1 = document.getElementById('NF1-select').value;    
    const url = urlServeur + '/listeNF2/'+NF1;
    fetch(url)
        .then(response => response.json()) // Convertir la réponse en JSON
        .then(data => {
            const selectNF2 = document.getElementById('NF2-select');
            data.forEach(NF2 => {
                const option = document.createElement('option');
                option.value = NF2.code;
                option.textContent = NF2.libelle;
                selectNF2.appendChild(option);
            });
        })
        .catch(error => console.error('Erreur lors du chargement des NF2:', error));
}

function validerDates() {
    // def: Vérifie que la date de début est antérieure à la date de fin pour éviter les erreurs de saisie.
    // in: Date de début et date de fin extraites du document HTML
    // out: Retourne true si la validation réussit, sinon affiche un message d'erreur et retourne false
    
    const dateDebut = new Date(document.getElementById('date-debut').value + 'T' + document.getElementById('heure-debut').value); 
    const dateFin = new Date(document.getElementById('date-fin').value + 'T' + document.getElementById('heure-fin').value); 
    if (dateDebut >= dateFin) {
        alert("La date de début doit être antérieure à la date de fin.");
        return false; 
    }
    return true; 
}

function rechercherDonnees() {
    // def: Effectue une requête pour récupérer les données des interventions selon les critères de recherche spécifiés, filtre et trie ces données, puis les affiche.
    // in: Aucune directe, mais dépend de la validation des saisies
    // out: Affiche les données filtrées et triées, ou des messages d'erreur en cas d'échec

    if (!validerSaisies()) {
        alert("Veuillez remplir les paramètres de recherche nécessaires :  \n - Date et heure de début, date et heure de fin et/ou commune et/ou natures de faits");
        return;
    };

    if (!validerDates()) { // Valider les dates avant de rechercher les données
		alert('passage');
        return; 
    }

    const url = urlServeur + '/listerechercheinterventions?dateDeb=' + document.getElementById('date-debut').value + "&heureDeb=" + document.getElementById('heure-debut').value + "&dateFin=" + document.getElementById('date-fin').value + "&heureFin=" + document.getElementById('heure-fin').value + "&commune=" + document.getElementById('commune-select').value + "&NF0=" + document.getElementById('NF0-select').value+ "&NF1=" + document.getElementById('NF1-select').value+ "&NF2=" + document.getElementById('NF2-select').value;
    let tableau = [];
    const communeSelectionnee = document.getElementById('commune-select').value;

    fetch(url, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json'
        }
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Erreur lors de la requête');
        }
        return response.json(); // Convertir la réponse en JSON
    })
    .then(data => {
        try {
            let donneesFiltrees;
                donneesFiltrees = filtrerDonneesParDateEtCommune(data, communeSelectionnee);
            const donneesTriees = trierDonneesParDate(donneesFiltrees);
            donneesTriees.forEach(item => {
                tableau.push({
                    "date": item.date_inter,
                    "heure": item.heure_inter,
                    "numero": item.numinter,
                    "commune": item.commune,
                    "adresse": item.adresse,
                    "motif": item.motif,
                    "centres": item.centres,
                    "moyens": item.moyens,
                    "url_page": item.url_page,
                });
            });
			afficherNombre(tableau.length);
            afficherBandeaux(tableau);
        } catch (error) {
            alert('Erreur lors de l\'analyse des données : ' + error.message);
        }
    })
    .catch(error => {
        alert('Erreur : ' + error.message);
    });
}

function validerSaisies() {
    // def: Valide que les critères de recherche nécessaires sont remplis.
    // in: Valeurs des champs de recherche dans le document HTML
    // out: Retourne true si les critères sont remplis, sinon retourne false

    const dateDebut = document.getElementById('date-debut').value;
    const dateFin = document.getElementById('date-fin').value;
    const heureDebut = document.getElementById('heure-debut').value;
    const heureFin = document.getElementById('heure-fin').value;
    

    if (dateDebut && dateFin && heureDebut && heureFin) {
        return true;
    }

    return false;
}

function parseDateFrancaise(dateString, timeString) {
    // def: Convertit les dates et heures au format français en objets Date.
    // in: dateString (chaîne de caractères au format jj/mm/aaaa), timeString (chaîne de caractères au format hh:mm)
    // out: Objet Date

    const [day, month, year] = dateString.split('/').map(Number);
    const [hours, minutes] = timeString.split(':').map(Number);
    return new Date(year, month - 1, day, hours, minutes);
}

function filtrerDonneesParDateEtCommune(data, communeSelectionnee) {
    // def: Filtre les interventions pour n'inclure que celles situées entre les dates spécifiées et éventuellement pour une commune sélectionnée.
    // in: Données des interventions, commune sélectionnée
    // out: Données des interventions filtrées

    const dateDebut = parseDateFrancaise(document.getElementById('date-debut').value.split('-').reverse().join('/'), document.getElementById('heure-debut').value);
    const dateFin = parseDateFrancaise(document.getElementById('date-fin').value.split('-').reverse().join('/'), document.getElementById('heure-fin').value);

    return data.filter(item => {
        const dateItem = parseDateFrancaise(item.date_inter, item.heure_inter);
        return dateItem >= dateDebut && dateItem <= dateFin &&
            (!communeSelectionnee || item.commune.toLowerCase() === communeSelectionnee.toLowerCase());
    });
}

function filtrerDonneesParNumeroIntervention(data, numeroIntervention) {
    // def: Filtre les interventions pour n'inclure que celles dont le numéro d'intervention correspond à la recherche.
    // in: Données des interventions, numéro d'intervention recherché
    // out: Données des interventions filtrées

    return data.filter(item => item.numinter.toLowerCase().includes(numeroIntervention.toLowerCase()));
}

function trierDonneesParDate(data) {
    // def: Trie les interventions par date et heure croissantes pour un affichage ordonné.
    // in: Données des interventions filtrées
    // out: Données des interventions triées par date

    return data.sort((a, b) => {
        const dateA = parseDateFrancaise(a.date_inter, a.heure_inter);
        const dateB = parseDateFrancaise(b.date_inter, b.heure_inter);
        return dateA - dateB;
    });
}

function afficherBandeaux(bandeaux) {
    // def: Génère et insère du HTML pour chaque intervention filtrée et triée.
    // in: Données des interventions filtrées et triées
    // out: Affichage des bandeaux des interventions dans le document HTML

    const conteneurBandeaux = document.getElementById('conteneur-bandeaux');

    conteneurBandeaux.innerHTML = bandeaux.map(bandeau => `
        <div class="bandeau" onclick="ouvrirPage('${bandeau.url_page}')">
            <div class="motif">
                <div>Motif : ${bandeau.motif}</div>
            </div>
            <div class="ligne-principale">
                <div class="infos-gauche">
                    <div>Date / heure : ${bandeau.date} ${bandeau.heure}</div>
                    <div>N° Intervention : ${bandeau.numero}</div>
                    <div>Adresse : ${bandeau.adresse}</div>
                </div>
                <div class="infos-droite">
                    <div>Commune : ${bandeau.commune}</div>
                    <div>Centre(s) engagé(s)  : ${bandeau.centres}</div> 
                    <div>Moyen(s) : ${bandeau.moyens}</div>
                </div>
            </div>
        </div>
    `).join('');
}

function afficherNombre(nombre) {
	const conteneurresume = document.getElementById('conteneur-resume');
	conteneurresume.innerHTML = "<label>"+nombre + " interventions trouvées"+"</label>"
}

function ouvrirPage(url) {
    // def: Ouvre une nouvelle page pour afficher les détails d'une intervention spécifique.
    // in: URL de la page à ouvrir
    // out: Ouvre une nouvelle page dans le navigateur avec l'URL spécifiée

    window.open(url, '_blank');
}
