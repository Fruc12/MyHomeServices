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
        Schema::create('services', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('category_id')->index();
            $table->unsignedBigInteger('prestator_id')->index();
            $table->unsignedBigInteger('customer_id')->index();

            $table->string('name');
            $table->string('description');
            $table->enum('status', ['pending', 'in_progress', 'completed', 'canceled', 'reported']);
            $table->timestamp('service_moment');

            $table->foreign('category_id')->references('id')->on('categories')->cascadeOnDelete();
            $table->foreign('prestator_id')->references('id')->on('users')->cascadeOnDelete();
            $table->foreign('customer_id')->references('id')->on('users')->cascadeOnDelete();

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('services');
    }
};
