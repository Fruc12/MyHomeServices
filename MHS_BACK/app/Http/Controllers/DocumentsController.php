<?php

namespace App\Http\Controllers;

use App\Models\Documents;
use Illuminate\Http\Request;

class DocumentsController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        //
        return Documents::with('prestator')->get();
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
        //
        $validated = $request->validate([
            'prestator_id' => 'required|exists:prestators,id',
            'path' => 'required|string'
        ]);

        return Documents::create($validated);
    }

    /**
     * Display the specified resource.
     */
    public function show(Documents $documents)
    {
        //
        return $documents->load('prestators');
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Documents $documents)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Documents $documents)
    {
        //
        $validated = $request->validate([
            'path' => 'sometimes|string'
        ]);

        $documents->update($validated);

        return $documents;
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Documents $documents)
    {
        //
        $documents->delete();
        return response(null, 204);
    


    }
}
