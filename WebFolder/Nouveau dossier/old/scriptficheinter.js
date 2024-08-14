document.addEventListener('DOMContentLoaded', () => {
    chargerCommunes();
});

const urlServeur = 'http://192.168.210.153';  // URL du serveur

function chargerCommunes() {
    const url = urlServeur + '/listecommunes';
    fetch(url)
        .then(response => response.json())
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

function rechercherDonnees() {
    if (!validerSaisies()) {
        alert("Veuillez remplir les paramètres de recherche nécessaires : \n - Numéro d'intervention \n OU \n - Date et heure de début, date et heure de fin et/ou commune");
        return;
    }
    
    const url = urlServeur + '/listeinterdetail?dateDeb=' + document.getElementById('date-debut').value + "&heureDeb=" + document.getElementById('heure-debut').value + "&dateFin=" + document.getElementById('date-fin').value + "&heureFin=" + document.getElementById('heure-fin').value + "&commune=" + document.getElementById('commune-select').value + "&numinter=" + document.getElementById('numero-intervention').value;
    let tableau = [];
    const numeroIntervention = document.getElementById('numero-intervention').value;
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
        return response.json();
    })
    .then(data => {
        try {
            let donneesFiltrees;
            if (numeroIntervention) {
                donneesFiltrees = filtrerDonneesParNumeroIntervention(data, numeroIntervention);
            } else {
                donneesFiltrees = filtrerDonneesParDateEtCommune(data, communeSelectionnee);
            }
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
                });
            });
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
    const numeroIntervention = document.getElementById('numero-intervention').value;
    const dateDebut = document.getElementById('date-debut').value;
    const dateFin = document.getElementById('date-fin').value;
    const heureDebut = document.getElementById('heure-debut').value;
    const heureFin = document.getElementById('heure-fin').value;
    
    if (numeroIntervention) {
        return true;
    }

    if (dateDebut && dateFin && heureDebut && heureFin) {
        return true;
    }

    return false;
}

function parseDateFrancaise(dateString, timeString) {
    const [day, month, year] = dateString.split('/').map(Number);
    const [hours, minutes] = timeString.split(':').map(Number);
    return new Date(year, month - 1, day, hours, minutes);
}

function filtrerDonneesParDateEtCommune(data, communeSelectionnee) {
    const dateDebut = parseDateFrancaise(document.getElementById('date-debut').value.split('-').reverse().join('/'), document.getElementById('heure-debut').value);
    const dateFin = parseDateFrancaise(document.getElementById('date-fin').value.split('-').reverse().join('/'), document.getElementById('heure-fin').value);

    return data.filter(item => {
        const dateItem = parseDateFrancaise(item.date_inter, item.heure_inter);
        return dateItem >= dateDebut && dateItem <= dateFin &&
            (!communeSelectionnee || item.commune.toLowerCase() === communeSelectionnee.toLowerCase());
    });
}

function filtrerDonneesParNumeroIntervention(data, numeroIntervention) {
    return data.filter(item => item.numinter.toLowerCase().includes(numeroIntervention.toLowerCase()));
}

function trierDonneesParDate(data) {
    return data.sort((a, b) => {
        const dateA = parseDateFrancaise(a.date_inter, a.heure_inter);
        const dateB = parseDateFrancaise(b.date_inter, b.heure_inter);
        return dateA - dateB;
    });
}

function afficherBandeaux(bandeaux) {
    const conteneurBandeaux = document.getElementById('conteneur-bandeaux');

    conteneurBandeaux.innerHTML = bandeaux.map(bandeau => `
        <div class="bandeau" onclick="ouvrirPage('${bandeau.numero}')">
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
                    <div>Centre(s) engagé(s) : ${bandeau.centres}</div> 
                    <div>Moyen(s) : ${bandeau.moyens}</div>
                </div>
            </div>
        </div>
    `).join('');
}

function ouvrirPage(numeroIntervention) {
    const url = `${urlServeur}/detailinter?numinter=${numeroIntervention}`;
    window.open(url, '_blank');
}
