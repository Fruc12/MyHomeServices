<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Reservation;
use App\Models\Service;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Carbon\Carbon;

class ReservationController extends Controller
{
        /**
     * Display a listing of the resource.
     */
    public function index(string $role) {
        if ($role == 'customer') {
            $reservations = Reservation::with(['service.prestator', 'service.category'])->where('customer_id', Auth::id())->get();
        }
        else if ($role == 'prestator') {
            if ( Auth::user()->role == 'customer') {
                return response()->json([
                    // 'success' => false,
                    'message' => 'Seul un prestataire peut voir les reservations de role prestator.'
                ], 403);
            }
            $reservations = Reservation::with(['customer', 'service.category'])->whereHas('service', function ($query) {
                $query->where('prestator_id', Auth::id());
            })->get();
        } else {
            return response()->json([
                // 'success' => false,
                'message' => 'Le rôle doit etre customer ou prestataire.'
            ], 400);
        }
        // Récupération des services en fonction du rôle de l'utilisateur
        return response()->json([
            'success' => true,
            'message' => 'Liste des services récupérée avec succès.',
            'data' => $reservations
        ], 200);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
       
        $request->customer_id = Auth::id();
        
        $validated = $request->validate([
            'service_id' => 'required|exists:services,id',
            'customer_id' => 'nullable|exists:users,id',
            'status' => 'required|in:pending,in_progress,completed,canceled,reported',
            'date' => 'required|date|after:today',
            'time' => 'required|date_format:H:i,H:i:s',
            'location' => 'required|string|max:255',
            'price' => 'nullable|integer|min:0',
        ]);

        $validated['date'] = Carbon::createFromDate($request->date)->format('Y-m-d');
        $validated['time'] = Carbon::createFromDate($request->tome)->format('H:i');
        $reservation = Reservation::create($validated);

        return response()->json([
            'success' => true,
            'message' => 'Service créé avec succès.',
            'data' => $reservation
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(Reservation $reservation)
    {
        $reservation = $reservation->load(['service.prestator', 'service.category', 'customer', 'rate']);

        return response()->json([
            'success' => true,
            'message' => 'Service récupéré avec succès.',
            'data' => $reservation
        ], 200);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Reservation $reservation)
    {
        $validated = $request->validate([
            'service_id' => 'required|exists:services,id',
            'customer_id' => 'nullable|exists:users,id',
            'status' => 'required|in:pending,in_progress,completed,canceled,reported',
            'date' => 'required|date|after:today',
            'time' => 'required|date_format:H:i,H:i:s',
            'location' => 'required|string|max:255',
            'price' => 'nullable|integer|min:0',
        ]);

        $validated['date'] = Carbon::createFromDate($request->date)->format('Y-m-d');
        $validated['time'] = Carbon::createFromDate($request->tome)->format('H:i');

        $reservation->update($validated);

        return response()->json([
            'success' => true,
            'message' => 'Service mis à jour avec succès.',
            'data' => $reservation
        ], 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Reservation $reservation)
    {
        $reservation->delete();

        return response()->json([
            'success' => true,
            'message' => 'Service supprimé avec succès.'
        ], 200);
    }
}
