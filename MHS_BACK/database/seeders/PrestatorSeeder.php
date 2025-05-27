<?php

namespace Database\Seeders;
use App\Models\Prestator;
use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;



class PrestatorSeeder extends Seeder

{
    public function run(): void
    {
        $prestatorUser = User::where('email', 'jean.prestataire@example.com')->first();

        if ($prestatorUser) {
            Prestator::create([
                'user_id' => $prestatorUser->id,
                'description' => 'Professionnel du ménage avec 5 ans d\'expérience. Certifié et assuré.',
                'validate' => true,
                'path' => 'prestators/documents/',
                'address' => '123 Rue des Services, 75001 Paris',
            ]);
        }

        $prestatorUser = User::where('email', 'fruc.prestataire@example.com')->first();
        if ($prestatorUser) {
            Prestator::create([
            'user_id' => $prestatorUser->id,
            'description' => 'Plombier professionnel avec 8 ans d\'expérience. Spécialisé dans les réparations d\'urgence.',
            'validate' => true,
            'path' => 'prestators/documents/',
            'address' => '789 Boulevard des Plombiers, 75003 Paris',
        ]);
    }


    $prestatorUser = User::where('email', 'steven.prestataire@example.com')->first();

    if ($prestatorUser) {

    Prestator::create([

    'user_id' => $prestatorUser->id,

    'description' => 'Électricien qualifié avec 10 ans d\'expérience. Disponible pour des travaux résidentiels et commerciaux.',

    'validate' => false,

    'path' => 'prestators/documents/',

    'address' => '456 Avenue des Électriciens, 75002 Paris',

    ]);

    }

    }

}