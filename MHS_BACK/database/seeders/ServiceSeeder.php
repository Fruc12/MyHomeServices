<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Service;
use App\Models\User; // N'oubliez pas d'importer le modèle User
use App\Models\Category; // N'oubliez pas d'importer le modèle Category
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
        if (!$menageCategory) {
            $this->command->warn('La catégorie "Ménage" n\'a pas été trouvée. Veuillez exécuter MenageCategorySeeder d\'abord.');
            return;
        }
        $menageCategoryId = $menageCategory->id;

        // Récupérez les IDs des utilisateurs qui sont des prestataires.
        // C'est crucial : nous voulons les IDs des users qui ont une entrée dans 'prestators'
        // plutôt que de se baser uniquement sur le rôle, pour s'assurer de la cohérence.
        // Si vous avez un modèle Prestator qui a une relation avec User, c'est encore mieux.
        // Si Prestator::all()->pluck('user_id')->toArray();
        // OU si vous utilisez le rôle 'prestator' dans UserSeeder et que ces IDs correspondent aux entrées de 'prestators':
        $prestatorUserIds = User::where('role', 'prestator')->pluck('id')->toArray();


        // Récupérez les IDs des utilisateurs qui sont des clients
        $customerUserIds = User::where('role', 'customer')->pluck('id')->toArray();

        // Assurez-vous d'avoir au moins un prestataire et un client
        if (empty($prestatorUserIds)) {
            $this->command->warn('Aucun utilisateur prestataire trouvé. Veuillez exécuter UserSeeder et PrestatorSeeder d\'abord.');
            return;
        }
        if (empty($customerUserIds)) {
            $this->command->warn('Aucun utilisateur client trouvé. Veuillez exécuter UserSeeder d\'abord.');
            return;
        }

        // Créer des services de ménage pour différents prestataires et clients
        for ($i = 1; $i <= 5; $i++) {
            Service::create([
                'category_id' => $menageCategoryId,
                'prestator_id' => $prestatorUserIds[array_rand($prestatorUserIds)], // Sélectionne un ID de prestataire aléatoire
                'customer_id' => $customerUserIds[array_rand($customerUserIds)], // Sélectionne un ID de client aléatoire
                'name' => 'Ménage ' . $i,
                'description' => 'Service de ménage standard pour ménage ' . $i,
                'status' => ['pending', 'in_progress', 'completed', 'canceled', 'reported'][array_rand(['pending', 'in_progress', 'completed', 'canceled', 'reported'])],
                'service_moment' => Carbon::now()->addDays(rand(1, 30)),
            ]);
        }

        // Exemples de services spécifiques avec des IDs réels de prestataires
        $jeanPrestataire = User::where('email', 'jean.prestataire@example.com')->first();
        $client1 = User::where('email', 'client1@example.com')->first();

        if ($jeanPrestataire && $client1) {
            Service::create([
                'category_id' => $menageCategoryId,
                'prestator_id' => $jeanPrestataire->id,
                'customer_id' => $client1->id,
                'name' => 'Ménage approfondi',
                'description' => 'Nettoyage complet de la maison avec des produits spécifiques.',
                'status' => 'completed',
                'service_moment' => Carbon::now()->subDays(2),
            ]);
        }
    }
}