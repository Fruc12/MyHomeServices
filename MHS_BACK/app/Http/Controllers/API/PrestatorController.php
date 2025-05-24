<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Prestator;
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
        $prestators = Prestator::whereHas('user', function ($query) use ($categoryId) {
            $query->whereHas('services', function ($subQuery) use ($categoryId) {
                $subQuery->where('category_id', $categoryId);
            });
        })->with('user')->get(['user_id', 'description', 'address']); // Récupérer les informations nécessaires

        $formattedPrestators = $prestators->map(function ($prestator) {
            return [
                'name' => $prestator->user->name, // Assurez-vous que la relation 'user' est définie dans le modèle Prestator
                'description' => $prestator->description,
                'address' => $prestator->address,
                // Ajoutez d'autres informations si nécessaire
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
