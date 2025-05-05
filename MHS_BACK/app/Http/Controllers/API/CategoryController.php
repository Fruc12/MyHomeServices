<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Category;
use Illuminate\Http\Request;

class CategoryController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $categories = Category::all();
        return response()->json([
            'success' => true,
            'message' => 'Liste des catégories récupérée avec succès.',
            'data' => $categories
        ], 200);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        // Validation des données
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'required|string',
        ]);

        // Création de la catégorie
        $categorie = Category::create($validated);

        return response()->json([
            'success' => true,
            'message' => 'Catégorie créée avec succès.',
            'data' => $categorie
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show($categorie_id)
    {
        $categorie = Category::find($categorie_id);

        if (!$categorie) {
            return response()->json([
                // 'success' => false,
                'message' => 'Catégorie non trouvée.'
            ], 404);
        }
        return response()->json([
            'success' => true,
            'message' => 'Catégorie récupérée avec succès.',
            'data' => $categorie
        ], 200);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $categorie_id)
    {
        // Validation des données
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'required|string',
        ]);

        // Mise à jour de la catégorie
        $categorie = Category::find($categorie_id);

        if (!$categorie) {
            return response()->json([
                // 'success' => false,
                'message' => 'Catégorie non trouvée.'
            ], 404);
        }

        $categorie->update($validated);

        return response()->json([
            'success' => true,
            'message' => 'Catégorie mise à jour avec succès.',
            'data' => $categorie
        ], 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($categorie_id)
    {
        $categorie = Category::find($categorie_id);

        if (!$categorie) {
            return response()->json([
                // 'success' => false,
                'message' => 'Catégorie non trouvée.'
            ], 404);
        }

        $categorie->delete();

        return response()->json([
            'success' => true,
            'message' => 'Catégorie supprimée avec succès.'
        ], 200);
    }
}
