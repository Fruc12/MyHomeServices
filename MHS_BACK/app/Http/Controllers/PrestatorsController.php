<?php

namespace App\Http\Controllers;

use App\Models\Prestators;
use Illuminate\Http\Request;

class PrestatorsController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return Prestators::with('user')->get();
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

        return Prestators::create($validated);
    }

    /**
     * Display the specified resource.
     */
    public function show(Prestators $prestators)
    {
        
        return $prestators->load('user');
        
       
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Prestators $prestators)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Prestators $prestators)
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
    public function destroy(Prestators $prestators)
    {
        //
        $prestators->delete();
        return response(null, 204);

    }
}
