const urlServeur = 'http://192.168.210.153';

document.addEventListener('DOMContentLoaded', () => {
    chargerMoyens(); // Charger les moyens lors du chargement de la page
    chargerCentres(); // Charger les centres lors du chargement de la page
});

function chargerMoyens() {
    // def : Fonction pour charger et afficher les moyens
    // in : Aucun
    // out : Remplit le tableau HTML avec les moyens obtenus depuis le serveur

    const url = `${urlServeur}/listemoyens`;
    //const url = `listemoyens.json`;

    fetch(url)
        .then(response => response.json())
        .then(data => {
            const corpsTableau = document.getElementById('corps-tableau');
            const moyens = data.moyens;

            moyens.forEach(moyen => {
                const ligne = document.createElement('tr');
                ligne.innerHTML = `
                    <td>${moyen.nom}</td>
                    <td>${moyen.centre}</td>
                    <td>${moyen.etat}</td>
                    <td>${moyen.rfgi}</td>
                `;
                corpsTableau.appendChild(ligne);
            });
        })
        .catch(error => console.error('Erreur lors du chargement des moyens:', error));
}

function chargerCentres() {
    // def : Fonction pour charger et afficher les centres
    // in : Aucun
    // out : Remplit le sélecteur HTML avec les centres obtenus depuis le serveur    

    const url = `${urlServeur}/listecentres`;
    //const url = `listemoyens.json`;

    fetch(url)
        .then(response => response.json())
        .then(data => {
            const selectCentre = document.getElementById('select-centre');
            const centres = data;//.centres;

            centres.forEach(centre => {
                const option = document.createElement('option');
                option.value = centre.libelle;
                option.textContent = centre.libelle;
                selectCentre.appendChild(option);
            });
        })
        .catch(error => console.error('Erreur lors du chargement des centres:', error));
}

function filtrerTableau() {
    // def : Fonction pour filtrer les lignes du tableau selon les critères de nom et de centre
    // in : Aucun
    // out : Affiche seulement les lignes du tableau qui correspondent aux filtres appliqués

    const filtreNom = document.getElementById('filtre-nom').value.toLowerCase();
    const filtreCentre = document.getElementById('select-centre').value;
    const corpsTableau = document.getElementById('corps-tableau');
    const lignes = corpsTableau.getElementsByTagName('tr');

    Array.from(lignes).forEach(ligne => {
        const celluleNom = ligne.cells[0].textContent.toLowerCase();
        const celluleCentre = ligne.cells[1].textContent;

        const correspondNom = celluleNom.includes(filtreNom);
        const correspondCentre = filtreCentre === '' || celluleCentre === filtreCentre;

        if (correspondNom && correspondCentre) {
            ligne.style.display = '';
        } else {
            ligne.style.display = 'none';
        }
    });
}
