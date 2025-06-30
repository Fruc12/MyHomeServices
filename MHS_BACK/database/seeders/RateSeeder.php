<?php

namespace Database\Seeders;

use App\Models\Rate;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class RateSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        for ($i=8; $i <= 12; $i++) {
            Rate::create([
                'reservation_id' => $i,
                'rating' => rand(1, 5), // Note aléatoire entre 1 et 5
                'comment' => 'Commentaire de test pour la réservation ' . $i,
            ]);
        }
    }
}
