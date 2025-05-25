<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class AuthController extends Controller
{
    public function login(Request $request)
    {
        $credentials = Validator::make($request->all(), [
            'email' => 'required|email',
            'password' => 'required',
        ]);

        if ($credentials->fails()) {
            return response()->json([
                // 'success' => false
                'messaage' => $credentials->errors(),
            ], 422);
        }

        if (Auth::attempt($request->all())) {
            $user = Auth::user();
            $token = $user->createToken('API Token')->plainTextToken;

            return response()->json([
                'success' => true,
                'data' => $user,
                'token' => $token,
            ]);
        }

        return response()->json([
            // 'success' => false,
            'message' => 'Identifiants invalidess',
        ], 401);
    }

    public function auth_user()
    {
        return response()->json([
            'success' => true,
            'data' => Auth::user(),
        ]);
    }

    public function logout()
    {
        Auth::user()->currentAccessToken()->delete();

        return response()->json([
            'success' => true,
            'message' => 'Déconnexion réussie',
        ]);
    }
}
