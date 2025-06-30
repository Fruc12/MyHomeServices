<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Service;
use App\Models\User;
use App\Models\Category;
use App\Models\Prestator; // Assurez-vous que ce modèle existe et est correctement lié aux utilisateurs/services
use Carbon\Carbon;

class ServiceSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Récupérer toutes les catégories pour un accès facile par nom
        $categories = Category::all()->keyBy('name');

        // Vérifier si les catégories nécessaires existent
        $requiredCategories = [
            'Ménage',
            'Garde d\'enfants',
            'Coiffure',
            'Beauté',
            'Nettoyage après travaux', // Ajout de la catégorie manquante
            'Massage',
            'Coach sportif',
        ];

        foreach ($requiredCategories as $catName) {
            if (!$categories->has($catName)) {
                $this->command->warn("La catégorie \"$catName\" n'a pas été trouvée. Veuillez exécuter les seeders de catégorie d'abord.");
                return;
            }
        }

        // Définir des modèles de services par catégorie avec des noms et descriptions pertinents
        $serviceTemplates = [
            'Ménage' => [
                ['name' => 'Ménage Standard', 'description' => 'Nettoyage complet des pièces de vie et chambres.'],
                ['name' => 'Grand Nettoyage', 'description' => 'Nettoyage en profondeur avec attention aux détails (cuisine, salle de bain inclus).'],
                ['name' => 'Entretien Régulier', 'description' => 'Service de ménage hebdomadaire ou bi-hebdomadaire pour maintenir la propreté.'],
            ],
            'Garde d\'enfants' => [
                ['name' => 'Babysitting Soirée', 'description' => 'Garde d\'enfants pour soirées et événements ponctuels.'],
                ['name' => 'Aide aux devoirs', 'description' => 'Soutien scolaire et garde après l\'école.'],
                ['name' => 'Garde à Domicile', 'description' => 'Garde à temps plein ou partiel à votre domicile.'],
            ],
            'Coiffure' => [
                ['name' => 'Coupe & Brushing', 'description' => 'Coupe de cheveux simple et mise en forme avec brushing.'],
                ['name' => 'Coloration Complète', 'description' => 'Application de couleur sur l\'ensemble des cheveux.'],
                ['name' => 'Coiffure de Mariée', 'description' => 'Coiffure élaborée et personnalisée pour les mariages.'],
            ],
            'Beauté' => [
                ['name' => 'Manucure & Pédicure', 'description' => 'Soins complets des mains et des pieds, avec pose de vernis.'],
                ['name' => 'Soins du Visage Hydratant', 'description' => 'Nettoyage, exfoliation et hydratation profonde du visage.'],
                ['name' => 'Maquillage Événementiel', 'description' => 'Maquillage professionnel pour occasions spéciales (fêtes, cérémonies).'],
            ],
            'Nettoyage après travaux' => [
                ['name' => 'Nettoyage Fin de Chantier', 'description' => 'Élimination des débris, poussière et résidus de construction après travaux.'],
                ['name' => 'Remise en état après Rénovation', 'description' => 'Nettoyage approfondi et désinfection après une rénovation majeure.'],
            ],
            'Massage' => [
                ['name' => 'Massage Relaxant', 'description' => 'Massage doux pour la détente musculaire et le bien-être général.'],
                ['name' => 'Massage Thérapeutique', 'description' => 'Massage ciblé pour soulager les tensions et douleurs musculaires.'],
                ['name' => 'Massage aux Pierres Chaudes', 'description' => 'Massage utilisant des pierres chauffées pour une relaxation profonde et une sensation de chaleur.'],
            ],
            'Coach sportif' => [
                ['name' => 'Séance Fitness Personnalisée', 'description' => 'Entraînement individuel adapté à vos objectifs de remise en forme.'],
                ['name' => 'Préparation Physique Spécifique', 'description' => 'Programme d\'entraînement pour athlètes ou préparation à un événement sportif.'],
                ['name' => 'Cours de Yoga/Pilates', 'description' => 'Séances de yoga ou Pilates pour la flexibilité et le renforcement du corps.'],
            ],
        ];

        // Récupérer les IDs des prestataires existants
        // Assurez-vous que le modèle Prestator est correctement configuré et qu'il y a des prestataires dans la base
        $prestatorIds = Prestator::pluck('id')->toArray();

        if (empty($prestatorIds)) {
            $this->command->warn('Aucun prestataire trouvé. Veuillez exécuter UserSeeder et PrestatorSeeder d\'abord.');
            return;
        }

        // Créer des services pour chaque catégorie en utilisant les modèles définis
        foreach ($serviceTemplates as $categoryName => $templates) {
            $categoryId = $categories[$categoryName]->id; // Récupère l'ID réel de la catégorie

            foreach ($templates as $template) {
                Service::create([
                    'category_id' => $categoryId,
                    'prestator_id' => $prestatorIds[array_rand($prestatorIds)], // Sélectionne un ID de prestataire aléatoire
                    'name' => $template['name'],
                    'description' => $template['description'],
                ]);
            }
        }

        // --- Exemples de services spécifiques avec des IDs réels de prestataires ---

        // Service de Coiffure pour Jean (s'il est coiffeur)
        if ($categories->has('Coiffure')) {
            Service::create([
                'category_id' => $categories['Coiffure']->id,
                'prestator_id' => 3, // ID de prestator
                'name' => 'Coupe Homme Tendance',
                'description' => 'Coupe et stylisation moderne pour hommes, conseils personnalisés.',
            ]);
        }

        // Service de Massage pour Jean (s'il est masseur)
        if ($categories->has('Massage')) {
            Service::create([
                'category_id' => $categories['Massage']->id,
                'prestator_id' => 3, // ID de prestator
                'name' => 'Massage aux Huiles Essentielles',
                'description' => 'Massage relaxant avec des huiles essentielles pour une détente profonde.',
            ]);
        }
    }
}