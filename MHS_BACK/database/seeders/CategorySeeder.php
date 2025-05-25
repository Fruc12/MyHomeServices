<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Category;

class CategorySeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Category::create([
            'name' => 'Ménage',
            'description' => 'Services de nettoyage et d\'entretien de la maison.',
        ]);

        Category::create([
            'name' => 'Garde d\'enfants',
            'description' => 'Services de garde d\'enfants à domicile, y compris les nourrices et les babysitters.',
            
        ]);

        Category::create([
            'name' => 'Coiffure',
            'description' => 'Services de coiffure à domicile, y compris les coupes, les colorations et les coiffures spéciales.',
            
        ]);

        Category::create([
            'name' => 'Beauté',
            'description' => 'Services de beauté à domicile, y compris les soins du visage, les manucures et les pédicures.',

        ]);

        Category::create([
            'name' => 'Nettoyage après travaux',
            'description' => 'Nettoyage spécifique pour éliminer les résidus de construction ou de rénovation.',
        ]);

        Category::create([
            'name' => 'Massage',
            'description' => 'Services de massage relaxant et thérapeutique à domicile.',
            
        ]);
        Category::create([
            'name' => 'Coach sportif',
            'description' => 'Entraînement personnel et coaching sportif à domicile.',
            
            
        ]);
    }
}