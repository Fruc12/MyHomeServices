<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Prestator;
use App\Models\Service;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use App\Models\User;
class PrestatorController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return Prestator::with('user')->get();
    }
     public function getPrestatorsByCategory(int $categoryId): JsonResponse
    {
        // 1. Trouver tous les user_ids (prestator_id) qui offrent des services dans cette catégorie
        $prestatorUserIds = Service::where('category_id', $categoryId)
                                   ->whereNotNull('prestator_id') // S'assurer qu'il y a un prestataire
                                   ->pluck('prestator_id')
                                   ->unique() // Éliminer les doublons d'IDs de prestataires
                                   ->toArray();

        // Si aucun prestataire n'offre de service dans cette catégorie, retournez un tableau vide
        if (empty($prestatorUserIds)) {
            return response()->json(['prestators' => []]);
        }

        // 2. Récupérer les informations des prestataires basées sur ces user_ids
        // Nous cherchons les entrées dans la table 'prestators' dont le user_id est dans la liste
        $prestators = Prestator::whereIn('user_id', $prestatorUserIds)
                               ->with('user') // Chargez la relation 'user' pour obtenir le nom
                               ->get();

        // 3. Formater les données pour la réponse API
        $formattedPrestators = $prestators->map(function ($prestator) {
            return [
                'id' => $prestator->id, // L'ID du prestataire dans la table 'prestators'
                'user_id' => $prestator->user_id, // L'ID de l'utilisateur lié
                'name' => $prestator->user->name ?? 'Nom inconnu', // Nom de l'utilisateur
                'email' => $prestator->user->email ?? 'Email inconnu', // Email de l'utilisateur
                'description' => $prestator->description ?? 'Description non disponible',
                'address' => $prestator->address ?? 'Adresse non disponible',
                // Ajoutez d'autres champs de Prestator si nécessaire
            ];
        });

        return response()->json(['prestators' => $formattedPrestators]);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'user_id' => 'required|exists:users,id|unique:prestators,user_id',
            'description' => 'required|string',
            'validate' => 'boolean',
            'path' => 'nullable|string',
            'address' => 'nullable|string'
        ]);

        return Prestator::create($validated);
    }

    /**
     * Display the specified resource.
     */
    public function show(Prestator $prestators)
    {
        
        return $prestators->load('user');
        
       
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Prestator $prestators)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Prestator $prestators)
    {
        //
        $validated = $request->validate([
            'user_id'=> 'nullable|exists:users,id|unique:prestators,user_id,'.$prestators->id,
            'description' => 'sometimes|string',
            'validate' => 'sometimes|boolean',
            'path' => 'nullable|string',
            'address' => 'nullable|string'
        ]);

        $prestators->update($validated);

        return $prestators;
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Prestator $prestators)
    {
        //
        $prestators->delete();
        return response(null, 204);

    }
}
