<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Service extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'description',
        'category_id',
        'prestator_id',
        'customer_id',
        'status',
        'service_moment'
    ];

    public function category()
    {
        return $this->belongsTo(Category::class);
    }

    public function prestator()
    {
        return $this->belongsTo(User::class, 'prestator_id');
    }

    public function customer()
    {
        return $this->belongsTo(User::class, 'customer_id');
    }

    public function rate()
    {
        return $this->hasOne(Rate::class);
    }
}