<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Service;
use Illuminate\Http\Request;

class ServiceController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $services = Service::with(['category', 'prestator', 'customer'])->get();
        return response()->json([
            'success' => true,
            'message' => 'Liste des services récupérée avec succès.',
            'data' => $services
        ], 200);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'prestator_id' => 'nullable|exists:users,id',
            'customer_id' => 'nullable|exists:users,id',
            'name' => 'required|string|max:255',
            'description' => 'required|string',
            'category_id' => 'required|exists:categories,id',
            'status' => 'required|in:pending,in_progress,completed,canceled,reported',
            'service_moment' => 'nullable|date'
        ]);

        // Création du service
        $service = Service::create($validated);

        return response()->json([
            'success' => true,
            'message' => 'Service créée avec succès.',
            'data' => $service
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show($service_id)
    {
        $service = Service::with(['category', 'prestator', 'customer'])->find($service_id);

        if (!$service) {
            return response()->json([
                // 'success' => false,
                'message' => 'Catégorie non trouvée.'
            ], 404);
        }
        
        return response()->json([
            'success' => true,
            'message' => 'Catégorie récupérée avec succès.',
            'data' => $service
        ], 200);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $service_id)
    {
        $validated = $request->validate([
            'prestator_id' => 'nullable|exists:users,id',
            'customer_id' => 'nullable|exists:users,id',
            'name' => 'required|string|max:255',
            'description' => 'required|string',
            'category_id' => 'required|exists:categories,id',
            'status' => 'required|in:pending,in_progress,completed,canceled,reported',
            'service_moment' => 'nullable|date'
        ]);

        // Création du service
        $service = Service::find($service_id);

        if (!$service) {
            return response()->json([
                // 'success' => false,
                'message' => 'Service non trouvé.'
            ], 404);
        }

        $service->update($validated);

        return response()->json([
            'success' => true,
            'message' => 'Service mis a jour avec succès.',
            'data' => $service
        ], 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($service_id)
    {
        $services = Service::find($service_id);

        if (!$services) {
            return response()->json([
                // 'success' => false,
                'message' => 'Service non trouvé.'
            ], 404);
        }

        $services->delete();
        
        return response()->json([
            'success' => true,
            'message' => 'Service supprimé avec succès.'
        ], 200);
    }
}
