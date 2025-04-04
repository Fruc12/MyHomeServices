<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('prestators', function (Blueprint $table) {
            $table->id();
            $table->integer('user_id')->index();
            $table->string('description');
            $table->boolean('validate')->default(false);
            $table->string(column: 'path');
            $table->string('address');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('prestators');
    }
};
