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
    public function index()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
       
        $request->customer_id = Auth::id();
        
        $validated = $request->validate([
            'prestator_id' => 'required|exists:users,id',
            'category_id' => 'required|exists:categories,id',
            'name' => 'required|string|max:255',
            'description' => 'required|string',
        ]);

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
    public function show($id)
    {
        $service = Service::with(['category', 'prestator'])->find($id);

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
    public function update(Request $request, $id)
    {
        $validated = $request->validate([
            'prestator_id' => 'required|exists:users,id',
            'category_id' => 'required|exists:categories,id',
            'name' => 'required|string|max:255',
            'description' => 'required|string',
        ]);

        $service = Service::find($id);

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
        ], 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        $service = Service::find($id);

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
        ], 200);
    }
}
