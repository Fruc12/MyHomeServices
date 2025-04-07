<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Prestator;
use Illuminate\Http\Request;

class PrestatorController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return Prestator::with('user')->get();
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
