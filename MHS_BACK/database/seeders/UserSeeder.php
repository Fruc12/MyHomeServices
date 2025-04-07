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
            'role' => 'admin',
            'password' => Hash::make('qwerty123'),
        ]);
        User::create([
            'name' => 'Admin',
            'email' => 'customer@mhs.com',
            'role' => 'customer',
            'password' => Hash::make('qwerty123'),
        ]);
        User::create([
            'name' => 'Admin',
            'email' => 'prestator@mhs.com',
            'role' => 'prestator',
            'password' => Hash::make('qwerty123'),
        ]);
    }
}
