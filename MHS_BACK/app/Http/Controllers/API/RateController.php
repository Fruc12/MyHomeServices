<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Rate;
use Illuminate\Http\Request;

class RateController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index() {
        return response()->json([
            'success' => true,
            'message' => 'Liste des évaluations récupérée avec succès.',
            'data' => Rate::with('reservation')->get(),
        ]);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request) {
        $validated = $request->validate([
            'reservation_id' => 'required|exists:reservations,id|unique:rates,reservation_id',
            'rating' => 'required|integer|min:1|max:5',
            'comment' => 'nullable|string'
        ]);

        return Rate::create($validated);

    }

    /**
     * Display the specified resource.
     */
    public function show(Rate $rate) {
        return $rate->load('reservation.service');
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Rate $rate) {
        $validated = $request->validate([
            'rating' => 'sometimes|integer|min:1|max:5',
            'comment' => 'nullable|string'
        ]);

        $rate->update($validated);

        return $rate;
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Rate $rate) {
        $rate->delete();
        return response([
            'success' => true,
            'message' => 'Évaluation supprimée avec succès.'
        ]);

    }
}
