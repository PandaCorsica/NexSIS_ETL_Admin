document.addEventListener('DOMContentLoaded', () => {
    chargerCentres(); // Charger les centres lors du chargement de la page
});

const urlServeur = 'http://192.168.210.153';  // URL du serveur

function chargerCentres() {
    // def : Charger la liste des centres depuis le serveur ou un fichier local et les ajouter à un élément <select> dans le document HTML.
    // in : None
    // out : Mise à jour de l'élément <select> avec la liste des centres

    const url = `${urlServeur}/listeUF`;
    //const url = `listeuf.json`;

    fetch(url)
        .then(response => response.json())
        .then(data => {
            const selectCentre = document.getElementById('centre-select');
            
            // Trier les centres par ordre alphabétique
            data.sort((a, b) => a.libelle.localeCompare(b.libelle));
            
            data.forEach(centre => {
                const option = document.createElement('option');
                option.value = centre.libelle;
                option.textContent = centre.libelle;
                selectCentre.appendChild(option);
            });
        })
        .catch(error => console.error('Erreur lors du chargement des centres:', error));
}

function rechercherDonnees() {
    // def : Rechercher les données en fonction des critères sélectionnés par l'utilisateur
    // in : None
    // out : Affichage des résultats filtrés dans un tableau HTML

    if (!validerDates() || !validerCriteresRequis()) {
        return;
    }

    const dateDebut = document.getElementById('date-debut').value;
    const dateFin = document.getElementById('date-fin').value;
    const centre = document.getElementById('centre-select').value;
    const etatCRSS = document.getElementById('etat-crss-select').value;
    const etatValidation = document.getElementById('etat-validation-select').value;
    const etatPaiement = document.getElementById('etat-paiement-select').value;

    const url = `${urlServeur}/listeCRSS?dateDeb=${dateDebut}&dateFin=${dateFin}&centre=${centre}&etatCRSS=${etatCRSS}&etatValidation=${etatValidation}&etatPaiement=${etatPaiement}`;
    //const url = `rizza.json`;

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
        return response.json();
    })
    .then(data => {
        // Filtrer les données selon les dates et les critères sélectionnés
        const filteredData = data.filter(intervention => {
            const interventionDate = parseDate(intervention.date);
            const startDate = new Date(`${dateDebut}`);
            const endDate = new Date(`${dateFin}`);
            
            return interventionDate >= startDate && interventionDate <= endDate &&
                (centre === "" || intervention.centre === centre) &&
                (etatCRSS === "" || intervention.etatCRSS === etatCRSS) &&
                (etatValidation === "" || intervention.etatValidation === etatValidation) &&
                (etatPaiement === "" || intervention.etatPaiement === etatPaiement);
        });

        // Trier les données par date et heure croissantes
        filteredData.sort((a, b) => new Date(a.date) - new Date(b.date));

        // Afficher les résultats dans un tableau
        afficherTableau(filteredData);
    })
    .catch(error => console.error('Erreur lors de la recherche des données:', error));
}

function parseDate(dateStr) {
    // def : Convertir une chaîne de date au format dd/MM/yyyy HH:mm:ss en objet Date
    // in : dateStr (string) - chaîne de date
    // out : Date object correspondant à la chaîne de date

    const [day, month, yearTime] = dateStr.split('/');
    const [year, time] = yearTime.split(' ');
    return new Date(`${year}-${month}-${day}T${time}`);
}

function afficherTableau(data) {
    // def : Afficher les résultats de la recherche dans un tableau HTML
    // in : data (array) - tableau des interventions filtrées
    // out : Mise à jour de l'élément HTML avec le tableau des résultats
    const resultatsRecherche = document.getElementById('resultats-recherche');
    resultatsRecherche.innerHTML = ''; // Effacer les résultats précédents

    const table = document.createElement('table');
    const thead = document.createElement('thead');
    const tr = document.createElement('tr');
    
    const thDate = document.createElement('th');
    thDate.textContent = 'Date';
    const thCentre = document.createElement('th');
    thCentre.textContent = 'Centre';
    const thEtat = document.createElement('th');
    thEtat.textContent = 'État';
    const thNuminter = document.createElement('th');
    thNuminter.textContent = 'Numéro CRSS';

    tr.appendChild(thDate);
    tr.appendChild(thCentre);
    tr.appendChild(thEtat);
    tr.appendChild(thNuminter);
    thead.appendChild(tr);
    table.appendChild(thead);

    const tbody = document.createElement('tbody');

    data.forEach(intervention => {
        const tr = document.createElement('tr');

        const tdDate = document.createElement('td');
        tdDate.textContent = intervention.date;
        const tdCentre = document.createElement('td');
        tdCentre.textContent = intervention.centre;
        const tdEtat = document.createElement('td');
        tdEtat.textContent = intervention.etat;
        const tdNuminter = document.createElement('td');
        const aNuminter = document.createElement('a');
        aNuminter.href = `${urlServeur}/detailCRSS?centre=${intervention.centre}&numero=${intervention.numinter}`;
        aNuminter.textContent = intervention.numinter;
        aNuminter.target = '_blank';

        tdNuminter.appendChild(aNuminter);
        tr.appendChild(tdDate);
        tr.appendChild(tdCentre);
        tr.appendChild(tdEtat);
        tr.appendChild(tdNuminter);
        tbody.appendChild(tr);
    });

    table.appendChild(tbody);
    resultatsRecherche.appendChild(table);
}

function validerDates() {
    // def: Vérifie que la date de début est antérieure à la date de fin pour éviter les erreurs de saisie.
    // in: Date de début et date de fin extraites du document HTML
    // out: Retourne true si la validation réussit, sinon affiche un message d'erreur et retourne false
    
    const dateDebut = new Date(document.getElementById('date-debut').value ); 
    const dateFin = new Date(document.getElementById('date-fin').value ); 

    if (dateDebut >= dateFin) {
        alert("La date de début doit être antérieure à la date de fin.");
        return false; 
    }
    return true; 
}

function validerCriteresRequis() {
    // def: Vérifie que les critères de recherche nécessaires sont remplis
    // in: None
    // out: Retourne true si tous les critères nécessaires sont remplis, sinon affiche un message d'erreur et retourne false
    
    const dateDebut = document.getElementById('date-debut').value;
    const dateFin = document.getElementById('date-fin').value;
    
    if (!dateDebut  || !dateFin ) {
        alert("Veuillez remplir toutes les dates de début et de fin.");
        return false;
    }
    return true;
}
