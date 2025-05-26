<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Rate extends Model
{
    use HasFactory;

    protected $fillable = [
        'reservation_id',
        'comment',
        'rating',
    ];

    public function reservation()
    {
        return $this->belongsTo(Reservation::class);
    }
}