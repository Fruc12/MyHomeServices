<?php

namespace App\Http\Controllers;

use App\Models\Category;
use Illuminate\Http\Request;

class CategoryController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
    
        return Category::all();
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
            'description' => 'required|string'
        ]);

        return Category::create($validated);

    }

    /**
     * Display the specified resource.
     */
    public function show(Category $categories)
    {
        //
        return $categories;
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Category $categories)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Category $categories)
    {
        $validated = $request->validate([
            'nom' => 'sometimes|string|max:255',
            'description' => 'sometimes|string'
        ]);

        $categories->update($validated);

        return $categories;
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Category $categories)
    {
        $categories->delete();
        return response(null, 204);
        
    }
}
