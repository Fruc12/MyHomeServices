<?php

namespace App\Http\Controllers;

use App\Models\Service;
use Illuminate\Http\Request;

class ServiceController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return Service::with(['category', 'prestator', 'customer'])->get();

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
            'name' => 'required|string|max:255',
            'description' => 'required|string',
            'category_id' => 'required|exists:categories,id',
            'prestator_id' => 'required|exists:prestators,id',
            'customer_id' => 'required|exists:users,id',
            'status' => 'required|string',
            'service_moment' => 'required|date'
        ]);

        return Service::create($validated);
    }

    /**
     * Display the specified resource.
     */
    public function show(Service $services)
    {
        //
        return $services->load(['category', 'prestator', 'customer']);
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Service $services)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Service $services)
    {
        $validated = $request->validate([
            'name' => 'sometimes|string|max:255',
            'description' => 'sometimes|string',
            'category_id' => 'sometimes|exists:categories,id',
            'prestator_id' => 'sometimes|exists:prestators,id',
            'customer_id' => 'sometimes|exists:users,id',
            'status' => 'sometimes|string',
            'service_moment' => 'sometimes|date'
        ]);

        $services->update($validated);

        return $services;
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Service $services)
    {
        $services->delete();
        return response(null, 204);
    }
}
