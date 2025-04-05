<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Prestators extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'description',
        'validate',
        'path',
        'address'
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function services()
    {
        return $this->hasMany(Services::class);
    }

    public function documents()
    {
        return $this->hasMany(Documents::class);
    }

    public function ratings()
    {
        return $this->hasMany(Rate::class);
    }
}