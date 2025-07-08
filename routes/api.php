<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\TaskController;
use Illuminate\Support\Facades\Http;

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:api')->group(function() {
    Route::get('/tasks', [TaskController::class, 'index']);
    Route::post('/tasks', [TaskController::class, 'store']);
    Route::put('/tasks/{task}', [TaskController::class, 'update'])->middleware('can:update,task');
    Route::delete('/tasks/{task}', [TaskController::class, 'destroy'])->middleware('can:delete,task');
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/quote', [App\Http\Controllers\QuoteController::class, 'fetch']);
});