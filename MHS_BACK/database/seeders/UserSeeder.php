<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public static function run(): void
    {
        User::create([
            'name' => 'Admin',
            'email' => 'admin@mhs.com',
            'phone' => '0161000000',
            'role' => 'admin',
            'password' => Hash::make('qwerty123'),
        ]);
        User::create([
            'name' => 'Admin',
            'email' => 'customer@mhs.com',
            'phone' => '0161000000',
            'role' => 'customer',
            'password' => Hash::make('qwerty123'),
        ]);
        User::create([
            'name' => 'Admin',
            'email' => 'prestator@mhs.com',
            'phone' => '0161000000',
            'role' => 'prestator',
            'password' => Hash::make('qwerty123'),
        ]);
        User::create([
            'name' => 'Jean Dupont',
            'email' => 'jean.prestataire@example.com',
            'phone' => '0161000000',
            'role' => 'prestator',
            'password' => Hash::make('password123'),
           
            
        ]);
        User::create([
            'name' => 'Fruc Dupont',
            'email' => 'fruc.prestataire@example.com',
            'phone' => '0161000000',
            'role' => 'prestator',                                                                      
            'password' => Hash::make('password123'),
            
            
        ]);
        User::create([
            'name' => 'Steven Dupont',
            'email' => 'steven.prestataire@example.com',
            'phone' => '0161000000',
            'role' => 'prestator',
            'password' => Hash::make('password123'),
            
           
        ]);
    }
}
