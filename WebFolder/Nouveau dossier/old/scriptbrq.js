let commentaires = {};  // Objet pour stocker les commentaires des interventions par numéro d'intervention
let commentaireGeneral = '';  // Variable pour stocker le commentaire général
const urlServeur = 'http://192.168.210.153';  // URL du serveur

// Fonction pour définir les dates et heures par défaut
function definirDateHeureParDefaut() {
    const maintenant = new Date();
    const heureActuelle = maintenant.getHours();

    // Si l'heure actuelle est après 7h du matin, la date de début sera la date du jour avec l'heure à 6h30 et la date de fin sera le lendemain à 6h30 
    if (heureActuelle >= 7) {
        const aujourdhui = maintenant.toISOString().split('T')[0];
        maintenant.setDate(maintenant.getDate() + 1);
        const demain = maintenant.toISOString().split('T')[0];

        document.getElementById('date-debut').value = aujourdhui;
        document.getElementById('heure-debut').value = '06:30';
        document.getElementById('date-fin').value = demain;
        document.getElementById('heure-fin').value = '06:30';
    // Si l'heure actuelle est avant 7h du matin, la date de début sera hier à 6h30 et la date de fin sera aujourd'hui à 6h30.
    } else {
        maintenant.setDate(maintenant.getDate() - 1);
        const hier = maintenant.toISOString().split('T')[0];
        const aujourdhui = new Date().toISOString().split('T')[0];

        document.getElementById('date-debut').value = hier;
        document.getElementById('heure-debut').value = '06:30';
        document.getElementById('date-fin').value = aujourdhui;
        document.getElementById('heure-fin').value = '06:30';
    }
}

// Fonction pour valider que la date de début est antérieure à la date de fin
function validerDates() {
    const dateDebut = new Date(document.getElementById('date-debut').value + 'T' + document.getElementById('heure-debut').value);
    const dateFin = new Date(document.getElementById('date-fin').value + 'T' + document.getElementById('heure-fin').value);

    if (dateDebut >= dateFin) {
        alert("La date de début doit être antérieure à la date de fin.");
        return false;
    }
    return true;
}

// Fonction pour rechercher les données à partir du serveur ou d'un fichier local
function rechercherDonnees() {
    if (!validerDates()) {
        return; 
    }
    
    //const url = 'http://127.0.0.1:5500/brq/listeinterbrq.json';
    const url = urlServeur + '/listeinterbrq?dateDeb=' + document.getElementById('date-debut').value + "&heureDeb=" + document.getElementById('heure-debut').value + "&dateFin=" + document.getElementById('date-fin').value + "&heureFin=" + document.getElementById('heure-fin').value;

    let tableau = [];

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
            const donneesFiltrees = filtrerDonneesParDate(data.inters);
            const donneesTriees = trierDonneesParDate(donneesFiltrees);
            donneesTriees.forEach(item => {
                const commentaire = item.commentaire || '';
                if (commentaire) {
                    commentaires[item.numinter] = commentaire;
                }
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
                    "commentaire": commentaire,
                    "type": item.type,
                });
            });
            commentaireGeneral = data.commentgene || '';
            afficherBandeaux(tableau);
            afficherBandeauRecapitulatif(data);
            afficherFiltreType();
        } catch (error) {
            alert('Erreur lors de l\'analyse des données : ' + error.message);
        }
    })
    .catch(error => {
        alert('Erreur : ' + error.message);
    });
}

// Fonction pour convertir une date et une heure au format français en objet Date
function parseDateFrancaise(dateString, timeString) {
    const [jour, mois, annee] = dateString.split('/').map(Number);
    const [heures, minutes] = timeString.split(':').map(Number);
    return new Date(annee, mois - 1, jour, heures, minutes);
}

// Fonction pour filtrer les données pour ne conserver que celles qui se situent entre deux dates spécifiques
function filtrerDonneesParDate(data) {
    const dateDebut = parseDateFrancaise(document.getElementById('date-debut').value.split('-').reverse().join('/'), document.getElementById('heure-debut').value);
    const dateFin = parseDateFrancaise(document.getElementById('date-fin').value.split('-').reverse().join('/'), document.getElementById('heure-fin').value);

    return data.filter(item => {
        const dateItem = parseDateFrancaise(item.date_inter, item.heure_inter);
        return dateItem >= dateDebut && dateItem <= dateFin;
    });
}

// Fonction pour trier les données par date et heure dans l'ordre croissant
function trierDonneesParDate(data) {
    return data.sort((a, b) => {
        const dateA = parseDateFrancaise(a.date_inter, a.heure_inter);
        const dateB = parseDateFrancaise(b.date_inter, b.heure_inter);
        return dateA - dateB;
    });
}

// Fonction pour afficher les bandeaux des interventions
function afficherBandeaux(bandeaux) {
    const conteneurBandeaux = document.getElementById('conteneur-bandeaux');
    const conteneurCommentaireGeneral = document.getElementById('conteneur-commentaire-general');

    conteneurBandeaux.innerHTML = bandeaux.map(bandeau => `
        <div class="bandeau ${bandeau.commentaire ? 'bandeau-rouge' : ''}" data-type="${bandeau.type}">
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
            <div class="boutons">
                <button onclick="window.open('${bandeau.url_page}', '_blank')">Main Courante</button>
                <button onclick="ouvrirPopup('${bandeau.numero}')">Intervention particulière</button>
            </div>
            <div class="commentaire" id="conteneur-commentaire-${bandeau.numero}" style="display: ${bandeau.commentaire ? 'block' : 'none'};">
                <strong>Commentaire :</strong>
                <p id="affichage-commentaire-${bandeau.numero}">${bandeau.commentaire}</p>
            </div>
        </div>
    `).join('');

    if (bandeaux.length > 0) {
        conteneurCommentaireGeneral.style.display = 'block';
        if (commentaireGeneral) {
            document.getElementById('commentaire-general').value = commentaireGeneral;
        }
    } else {
        conteneurCommentaireGeneral.style.display = 'none';
    }
}

// Fonction pour afficher le bandeau récapitulatif des interventions
function afficherBandeauRecapitulatif(data) {
    const bandeauRecapitulatif = document.getElementById('bandeau-recapitulatif');

    const formatDate = (dateStr) => {
        const [year, month, day] = dateStr.split('-');
        return `${day}/${month}/${year}`;
    };

    const dateDebut = `${formatDate(document.getElementById('date-debut').value)} ${document.getElementById('heure-debut').value}`;
    const dateFin = `${formatDate(document.getElementById('date-fin').value)} ${document.getElementById('heure-fin').value}`;

    bandeauRecapitulatif.innerHTML = `
        <div class="bandeau-periode">
            <h2>Récapitulatif du ${dateDebut} au ${dateFin}</h2>
            <p>Total des interventions : ${data.totaljour}</p>
            <p>Secours à personnes : ${data.sapjour}</p>
            <p>Accidents de circulation : ${data.avpjour}</p>
            <p>Incendies : ${data.incjour}</p>
            <p>        dont feux d'espaces naturels : ${data.incffjour}</p>
            <p>Explosions : ${data.explojour}</p>
            <p>Risques technologiques : ${data.rtjour}</p>
            <p>Risques naturels : ${data.rnjour}</p>
            <p>Atteintes aux biens et aux animaux : ${data.biensjour}</p>
            <p>Missions Police : ${data.policejour}</p>
            <p>Recherches : ${data.rechjour}</p>
            <p>Opérations diverses : ${data.divjour}</p>
        </div>
        <div class="bandeau-annee">
            <h2>Récapitulatif depuis le 1er janvier</h2>
            <p>Total des interventions : ${data.totalan}</p>
            <p>Secours à personnes : ${data.sapan}</p>
            <p>Accidents de circulation : ${data.avpan}</p>
            <p>Incendies : ${data.incan}</p>
            <p>        dont feux d'espaces naturels : ${data.incffan}</p>
            <p>Explosions : ${data.exploan}</p>
            <p>Risques technologiques : ${data.rtan}</p>
            <p>Risques naturels : ${data.rnan}</p>
            <p>Atteintes aux biens et aux animaux : ${data.biensan}</p>
            <p>Missions Police : ${data.policean}</p>
            <p>Recherches : ${data.rechan}</p>
            <p>Opérations diverses : ${data.divan}</p>
        </div>
    `;

    if (data.commentgene) {
        document.getElementById('commentaire-general').value = data.commentgene;
        commentaireGeneral = data.commentgene;
    }
}

// Fonction pour afficher le filtre de type d'intervention
function afficherFiltreType() {
    const conteneurFiltre = document.getElementById('conteneur-filtre');
    conteneurFiltre.innerHTML = `
        <p>Choisir un type d'intervention à afficher : <select id="filtre-type" onchange="filtrerParType()"></p>
            <option value="Toutes les interventions">Toutes les interventions</option>
            <option value="Secours à personnes">Secours à personnes</option>
            <option value="Accidents de circulation">Accidents de circulation</option>
            <option value="Incendies">Incendies</option>
            <option value="Explosions">Explosions</option>
            <option value="Risques technologiques">Risques technologiques</option>
            <option value="Risques naturels">Risques naturels</option>
            <option value="Atteintes aux biens et aux animaux">Atteintes aux biens et aux animaux</option>
            <option value="Missions Police">Missions Police</option>
            <option value="Recherches">Recherches</option>
            <option value="Opérations diverses">Opérations diverses</option>
        </select>
    `;
}

// Fonction pour filtrer les interventions par type
function filtrerParType() {
    const typeSelectionne = document.getElementById('filtre-type').value;
    const bandeaux = document.querySelectorAll('.bandeau');

    bandeaux.forEach(bandeau => {
        if (typeSelectionne === "Toutes les interventions" || bandeau.dataset.type === typeSelectionne) {
            bandeau.style.display = 'block';
        } else {
            bandeau.style.display = 'none';
        }
    });
}

// Fonction pour ouvrir la popup d'ajout de commentaire pour une intervention
function ouvrirPopup(numeroIntervention) {
    document.getElementById('popup').style.display = 'block';
    document.getElementById('popup').dataset.numeroIntervention = numeroIntervention;
    document.getElementById('commentaire').value = commentaires[numeroIntervention] || '';
}

// Fonction pour fermer la popup d'ajout de commentaire
function fermerPopup() {
    document.getElementById('popup').style.display = 'none';
    document.getElementById('popup').dataset.numeroIntervention = '';
}

// Fonction pour envoyer le commentaire d'une intervention au serveur
function envoyerCommentaire(numeroIntervention, commentaire) {
    const url = urlServeur + '/interpart';
    const data = {
        numinter: numeroIntervention,
        commentaire: commentaire
    };

    fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(data)
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Erreur lors de l\'envoi du commentaire');
        }
    })
    /*.then(() => {
    //  alert('Commentaire envoyé avec succès');
    }) */
    .catch(error => {
        alert('Erreur : ' + error.message);
    });
}

// Fonction pour supprimer le commentaire d'une intervention sur le serveur
function supprimerCommentaire(numeroIntervention) {
    const url = urlServeur + '/interpart';
    const data = {
        numinter: numeroIntervention,
        commentaire: ''
    };

    fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(data)
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Erreur lors de la suppression du commentaire');
        }
    })
    /*.then(() => {
        alert('Commentaire supprimé avec succès');
    })*/
    .catch(error => {
        alert('Erreur : ' + error.message);
    });
}

// Fonction pour valider et envoyer le commentaire d'une intervention
function validerCommentaire() {
    const commentaire = document.getElementById('commentaire').value;
    if (commentaire) {
        const numeroIntervention = document.getElementById('popup').dataset.numeroIntervention;
        commentaires[numeroIntervention] = commentaire;
        const bandeau = document.querySelector(`.bandeau .boutons button[onclick="ouvrirPopup('${numeroIntervention}')"]`).closest('.bandeau');
        bandeau.classList.add('bandeau-rouge');
        document.getElementById(`affichage-commentaire-${numeroIntervention}`).innerText = commentaire;
        document.getElementById(`conteneur-commentaire-${numeroIntervention}`).style.display = 'block';
        envoyerCommentaire(numeroIntervention, commentaire);
        fermerPopup();
    } else {
        alert("Veuillez saisir un commentaire avant de valider.");
    }
}

// Fonction pour valider et envoyer le commentaire général
function validerCommentaireGeneral() {
    const commentaire = document.getElementById('commentaire-general').value;
    if (commentaire) {
        commentaireGeneral = commentaire;

        const dateDebut = document.getElementById('date-debut').value;
        const heureDebut = document.getElementById('heure-debut').value;
        const dateFin = document.getElementById('date-fin').value;
        const heureFin = document.getElementById('heure-fin').value;

        const url = urlServeur + '/validateBRQ';
        const data = {
            date_debut: `${dateDebut}T${heureDebut}`,
            date_fin: `${dateFin}T${heureFin}`,
            commentaire: commentaire
        };

        fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(data)
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Erreur lors de l\'envoi du commentaire général');
            }
        })
        /*.then(() => {
            alert("Commentaire général soumis : " + commentaire);
        })*/
        .catch(error => {
            alert('Erreur : ' + error.message);
        });
    } else {
        alert("Veuillez saisir un commentaire avant de valider.");
    }
}

// Fonction pour annuler et supprimer le commentaire d'une intervention
function annulerCommentaire() {
    const numeroIntervention = document.getElementById('popup').dataset.numeroIntervention;
    if (confirm("Voulez-vous vraiment effacer ce commentaire?")) {
        delete commentaires[numeroIntervention];
        const bandeau = document.querySelector(`.bandeau .boutons button[onclick="ouvrirPopup('${numeroIntervention}')"]`).closest('.bandeau');
        bandeau.classList.remove('bandeau-rouge');
        document.getElementById(`affichage-commentaire-${numeroIntervention}`).innerText = '';
        document.getElementById(`conteneur-commentaire-${numeroIntervention}`).style.display = 'none';
        supprimerCommentaire(numeroIntervention);
        fermerPopup();
    }
}
