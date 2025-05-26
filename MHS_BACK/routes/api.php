<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\API\AuthController;
use App\Http\Controllers\API\UserController;
use App\Http\Controllers\API\PrestatorController;
use App\Http\Controllers\API\CategoryController;
use App\Http\Controllers\API\ServiceController;
use App\Http\Controllers\API\RateController;
use App\Http\Controllers\API\ReservationController;

// Auth routes
Route::post('/register', [UserController::class, 'store']);
Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/auth', [AuthController::class, 'auth_user']);
    Route::post('/logout', [AuthController::class, 'logout']);

    Route::apiResource('users', UserController::class)->except(['store']);
    Route::apiResource('prestators', PrestatorController::class);
    Route::apiResource('categories', CategoryController::class);
    Route::get('categories/{category}/services', [CategoryController::class, 'getCategoryServices']);
    Route::apiResource('services', ServiceController::class)->except(['index']);
    Route::get('/services/{service}/reservations', [ReservationController::class, 'index']);
    Route::apiResource('rates', RateController::class);
   
    // Route::apiResource('documents', DocumentController::class);
});
Route::get('/prestators/category/{categoryId}', [PrestatorController::class, 'getPrestatorsByCategory']);
Route::post('/service', [ServiceController::class, 'update']);