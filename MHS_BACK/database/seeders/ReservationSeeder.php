<?php

namespace Database\Seeders;

use App\Models\Reservation;
use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Carbon\Carbon;

class ReservationSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {

        // Récupérez les IDs des utilisateurs qui sont des clients
        $customerUserIds = User::where('role', 'customer')->pluck('id')->toArray();
        if (empty($customerUserIds)) {
            $this->command->warn('Aucun utilisateur client trouvé. Veuillez exécuter UserSeeder d\'abord.');
            return;
        }


        for ($i = 1; $i <= 6; $i++) {
            Reservation::create([
                'service_id' => $i,
                'customer_id' => $customerUserIds[array_rand($customerUserIds)], // Sélectionne un ID de client aléatoire
                'status' => ['pending', 'in_progress', 'completed', 'canceled', 'reported'][array_rand(['pending', 'in_progress', 'completed', 'canceled', 'reported'])],
                'date' => Carbon::now()->addDays(rand(1, 30)),
                'time' => Carbon::now()->addMinutes(rand(1, 1440)),
                'location' => '123 Main St, Cityville' . $i,
                'price' => rand(50, 200), // Prix aléatoire entre 50 et 200
            ]);
        }
        Reservation::create([
            'service_id' => 2,
            'customer_id' => $customerUserIds[array_rand($customerUserIds)], // Sélectionne un ID de client aléatoire
            'status' => ['pending', 'in_progress', 'completed', 'canceled', 'reported'][array_rand(['pending', 'in_progress', 'completed', 'canceled', 'reported'])],
            'date' => Carbon::now()->addDays(rand(1, 30)),
            'time' => Carbon::now()->addMinutes(rand(1,1440)),
            'location' => '456 Elm St, Townsville',
            'price' => rand(50, 200), // Prix aléatoire entre 50 et 200
            
        ]);
        
        foreach (['pending', 'in_progress', 'completed', 'canceled', 'reported'] as $status) {
            Reservation::create([
                'service_id' => 3,
                'customer_id' => 2,
                'status' => 'completed',
                'status' => $status,
                'date' => Carbon::now()->subDays(2),
                'time' => Carbon::now()->subHours(3)->format('H:i:s'),
                'location' => '123 Rue de Paris, Paris',
                'price' => 150,
            ]);
        }
    }
}
