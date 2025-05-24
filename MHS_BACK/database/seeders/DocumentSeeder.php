<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Prestator;
use App\Models\Document;
use App\Models\User;

class DocumentSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Seed documents for the first prestataire (jean.prestataire@example.com)
        $prestatorUserJean = User::where('email', 'jean.prestataire@example.com')->first();
        if ($prestatorUserJean) {
            $prestatorJean = Prestator::where('user_id', $prestatorUserJean->id)->first();
            if ($prestatorJean) {
                Document::create([
                    'prestator_id' => $prestatorJean->id,
                    'path' => 'prestators/documents/' . $prestatorJean->id . '/carte_identite.pdf',
                 
                ]);

                Document::create([
                    'prestator_id' => $prestatorJean->id,
                    
                    'path' => 'prestators/documents/' . $prestatorJean->id . '/certificat_menage.pdf',
                    
                ]);

                Document::create([
                    'prestator_id' => $prestatorJean->id,
                  
                    'path' => 'prestators/documents/' . $prestatorJean->id . '/assurance_menage.pdf',
                    
                ]);
            }
        }

        // Seed documents for the second prestataire (fruc.prestataire@example.com)
        $prestatorUserFruc = User::where('email', 'fruc.prestataire@example.com')->first();
        if ($prestatorUserFruc) {
            $prestatorFruc = Prestator::where('user_id', $prestatorUserFruc->id)->first();
            if ($prestatorFruc) {
                Document::create([
                    'prestator_id' => $prestatorFruc->id,
                  
                    'path' => 'prestators/documents/' . $prestatorFruc->id . '/permis_conduire.pdf',
                  
                ]);

                Document::create([
                    'prestator_id' => $prestatorFruc->id,
                 
                    'path' => 'prestators/documents/' . $prestatorFruc->id . '/certificat_plombier.pdf',
                    
                ]);

                Document::create([
                    'prestator_id' => $prestatorFruc->id,
                
                    'path' => 'prestators/documents/' . $prestatorFruc->id . '/facture_outillage_plombier.pdf',
                  
                ]);
            }
        }

        // Seed documents for the third prestataire (steven.prestataire@example.com)
        $prestatorUserSteven = User::where('email', 'steven.prestataire@example.com')->first();
        if ($prestatorUserSteven) {
            $prestatorSteven = Prestator::where('user_id', $prestatorUserSteven->id)->first();
            if ($prestatorSteven) {
                Document::create([
                    'prestator_id' => $prestatorSteven->id,
                
                    'path' => 'prestators/documents/' . $prestatorSteven->id . '/passeport.pdf',
                    
                ]);

                Document::create([
                    'prestator_id' => $prestatorSteven->id,
                  
                    'path' => 'prestators/documents/' . $prestatorSteven->id . '/habilitation_electrique.pdf',
                 
                ]);

                Document::create([
                    'prestator_id' => $prestatorSteven->id,
                    'path' => 'prestators/documents/' . $prestatorSteven->id . '/devis_type_electricite.pdf',
                    
                ]);
            }
        }
    }
}