<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Services extends Model
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
        return $this->belongsTo(Categories::class);
    }

    public function prestator()
    {
        return $this->belongsTo(Prestators::class);
    }

    public function customer()
    {
        return $this->belongsTo(User::class, 'customer_id');
    }
}