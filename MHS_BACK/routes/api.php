<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

// Route::get('/user', function (Request $request) {
//     return $request->user();
// })->middleware('auth:sanctum');
Route::apiResource('users', \App\Http\Controllers\UserController::class);
Route::apiResource('prestators', \App\Http\Controllers\PrestatorController::class);
Route::apiResource('categories', \App\Http\Controllers\CategoryController::class);
Route::apiResource('services', \App\Http\Controllers\ServiceController::class);
Route::apiResource('documents', \App\Http\Controllers\DocumentController::class);
Route::apiResource('rates', \App\Http\Controllers\RateController::class);