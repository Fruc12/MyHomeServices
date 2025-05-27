<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Service;
use App\Models\User; // N'oubliez pas d'importer le modèle User
use App\Models\Category; // N'oubliez pas d'importer le modèle Category
use App\Models\Prestator;
use Carbon\Carbon;

class ServiceSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Récupérez l'ID de la catégorie "Ménage"
        // Il est plus robuste de le récupérer que de le hardcoder à 1
        $menageCategory = Category::where('name', 'Ménage')->first();
        $coiffureCategory = Category::where('name', 'Coiffure')->first();
        if (!$menageCategory) {
            $this->command->warn('La catégorie "Ménage" n\'a pas été trouvée. Veuillez exécuter MenageCategorySeeder d\'abord.');
            return;
        }
        if (!$coiffureCategory) {
            $this->command->warn('La catégorie "Coiffure" n\'a pas été trouvée. Veuillez exécuter CoiffureCategorySeeder d\'abord.');
            return;
        }
        $coiffureCategoryId = $coiffureCategory->id;
        $menageCategoryId = $menageCategory->id;

        // Récupérez les IDs des utilisateurs qui sont des prestataires.
        // C'est crucial : nous voulons les IDs des users qui ont une entrée dans 'prestators'
        // plutôt que de se baser uniquement sur le rôle, pour s'assurer de la cohérence.
        // Si vous avez un modèle Prestator qui a une relation avec User, c'est encore mieux.
        // Si Prestator::all()->pluck('user_id')->toArray();
        // OU si vous utilisez le rôle 'prestator' dans UserSeeder et que ces IDs correspondent aux entrées de 'prestators':
        $prestatorUserIds = Prestator::pluck('id')->toArray();


        // Assurez-vous d'avoir au moins un prestataire et un client
        if (empty($prestatorUserIds)) {
            $this->command->warn('Aucun utilisateur prestataire trouvé. Veuillez exécuter UserSeeder et PrestatorSeeder d\'abord.');
            return;
        }


        // Créer des services de ménage pour différents prestataires et clients
        for ($i = 1; $i <= 6; $i++) {
            Service::create([
                'category_id' => $i,
                'prestator_id' => $prestatorUserIds[array_rand($prestatorUserIds)], // Sélectionne un ID de prestataire aléatoire
                'name' => 'Ménage ' . $i,
                'description' => 'Service de ménage standard pour ménage ' . $i,
            ]);
        }

        // Exemples de services spécifiques avec des IDs réels de prestataires
        $jeanPrestataire = User::where('email', 'jean.prestataire@example.com')->first();

        if ($jeanPrestataire) {
            Service::create([
                'category_id' => $coiffureCategoryId,
                'prestator_id' => $jeanPrestataire->id,
                'name' => 'Ménage approfondi',
                'description' => 'Nettoyage complet de la maison avec des produits spécifiques.',
            ]);
        }
    }
}