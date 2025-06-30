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

        Prestator::create([
            'user_id' => 3,
            'description' => 'Professionnel du ménage avec 5 ans d\'expérience. Certifié et assuré.',
            'validate' => true,
            'path' => 'prestators/documents/',
            'address' => '123 Rue des Services, 75001 Paris',
        ]);

        Prestator::create([
            'user_id' => 4,
            'description' => 'Plombier professionnel avec 8 ans d\'expérience. Spécialisé dans les réparations d\'urgence.',
            'validate' => true,
            'path' => 'prestators/documents/',
            'address' => '789 Boulevard des Plombiers, 75003 Paris',
        ]);

        Prestator::create([
            'user_id' => 5,
            'description' => 'Électricien qualifié avec 10 ans d\'expérience. Disponible pour des travaux résidentiels et commerciaux.',
            'validate' => false,
            'path' => 'prestators/documents/',
            'address' => '456 Avenue des Électriciens, 75002 Paris',
        ]);

        Prestator::create([
            'user_id' => 6,
            'description' => 'Électricien qualifié avec 10 ans d\'expérience. Disponible pour des travaux résidentiels et commerciaux.',
            'validate' => false,
            'path' => 'prestators/documents/',
            'address' => '456 Avenue des Électriciens, 75002 Paris',
        ]);

        // Prestator::create([
        //     'user_id' => 7,
        //     'description' => 'Électronicien surqualifié avec 4 ans d\'expérience.',
        //     'validate' => false,
        //     'path' => 'prestators/documents/',
        //     'address' => '456 Avenue des Électroniciens, 75002 Paris',
        // ]);
    }

}