<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Service;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ServiceController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index() {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request) {
        $validated = $request->validate([
            'prestator_id' => 'required|exists:users,id',
            'category_id' => 'required|exists:categories,id',
            'name' => 'required|string|max:255',
            'description' => 'required|string',
        ]);

        $validated['customer_id'] = Auth::id();
        $validated['date'] = Carbon::createFromDate($request->date)->format('Y-m-d');
        $service = Service::create($validated);

        return response()->json([
            'success' => true,
            'message' => 'Service créé avec succès.',
            'data' => $service
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(Service $service) {
        $service = $service->load(['category', 'prestator']);

        if (!$service) {
            return response()->json([
                'message' => 'Service non trouvé.'
            ], 404);
        }

        return response()->json([
            'success' => true,
            'message' => 'Service récupéré avec succès.',
            'data' => $service
        ], 200);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Service $service) {
        $validated = $request->validate([
            'prestator_id' => 'required|exists:users,id',
            'category_id' => 'required|exists:categories,id',
            'name' => 'required|string|max:255',
            'description' => 'required|string',
        ]);

        if (!$service) {
            return response()->json([
                // 'success' => false,
                'message' => 'Service non trouvé.'
            ], 404);
        }

        $validated['date'] = Carbon::createFromDate($service['date'])->format('Y-m-d');
        $service->update($validated);
        return response()->json([
            'success' => true,
            'message' => 'Service mis à jour avec succès.',
            'data' => $service
        ]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Service $service) {
        if (!$service) {
            return response()->json([
                // 'success' => false,
                'message' => 'Service non trouvé.'
            ], 404);
        }

        $service->delete();

        return response()->json([
            'success' => true,
            'message' => 'Service supprimé avec succès.'
        ]);
    }

    public function getRating(Service $service) {
        // dd($service->reservations->load('rate')->toArray());
        $ratings = $service->reservations->map(function ($reservation) {
            return $reservation->rate ? $reservation->rate->rating : 0;
        })->filter(function ($rating) {
            return $rating > 0; // Exclude zero ratings
        });
        $average = $ratings->avg();
        $number = $ratings->count();

        return response()->json([
            'success' => true,
            'message' => 'Évaluation récupérée avec succès.',
            'data' => [
                'rate' => $average,
                'number' => $number,
            ]
        ]);

    }

}
