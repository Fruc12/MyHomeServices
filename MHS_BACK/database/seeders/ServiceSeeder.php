<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Service;
use Carbon\Carbon;

class ServiceSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Créer des services de ménage pour différents prestataires et clients
        for ($i = 1; $i <= 5; $i++) { // Créer 5 services (vous pouvez ajuster ce nombre)
            Service::create([
                'category_id' => 1, // Toujours 1 (Ménage)
                'prestator_id' => 1, // 1, 2 ou 3
                'customer_id' => rand(1, 3), // 1, 2 ou 3
                'name' => 'Ménage ' . $i, // "Ménage 1", "Ménage 2", etc.
                'description' => 'Service de ménage standard.',
                'status' => ['pending', 'in_progress', 'completed', 'canceled', 'reported'][array_rand(['pending', 'in_progress', 'completed', 'canceled', 'reported'])], // Statut aléatoire
                'service_moment' => Carbon::now()->addDays(rand(1, 30)), // Date de service aléatoire dans les 30 prochains jours
            ]);
        }

        Service::create([
            'category_id' => 1,
            'prestator_id' => 2,
            'customer_id' => 2,
            'name' => 'Ménage',
            'description' => 'Nettoyage complet de la maison avec des produits spécifiques.',
            'status' => 'completed',
            'service_moment' => Carbon::now()->subDays(2),
        ]);

        Service::create([
            'category_id' => 1,
            'prestator_id' => 2,
            'customer_id' => 2,
            'name' => 'Ménage',
            'description' => 'Grand nettoyage de printemps, incluant les vitres et les placards.',
            'status' => 'in_progress',
            'service_moment' => Carbon::now()->addDays(5),
        ]);
    }
}