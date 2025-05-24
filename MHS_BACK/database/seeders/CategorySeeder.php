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
            'name' => 'Nettoyage régulier',
            'description' => 'Nettoyage hebdomadaire ou bi-hebdomadaire pour maintenir la propreté de votre domicile.',
        ]);

        Category::create([
            'name' => 'Grand nettoyage',
            'description' => 'Nettoyage en profondeur de toute la maison, idéal pour le printemps ou après un événement.',
        ]);

        Category::create([
            'name' => 'Nettoyage de vitres',
            'description' => 'Nettoyage intérieur et extérieur de vos fenêtres et baies vitrées.',
        ]);

        Category::create([
            'name' => 'Nettoyage après travaux',
            'description' => 'Nettoyage spécifique pour éliminer les résidus de construction ou de rénovation.',
        ]);

        Category::create([
            'name' => 'Repassage',
            'description' => 'Service de repassage de votre linge à domicile.',
        ]);
    }
}