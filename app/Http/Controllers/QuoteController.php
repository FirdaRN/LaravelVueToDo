<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\Http;

class QuoteController extends Controller
{
    public function fetch()
    {
        try {
            $response = Http::get('https://zenquotes.io/api/random');

            if ($response->successful()) {
                $data = $response->json()[0];
                return response()->json([
                    'quote' => $data['q'],
                    'author' => $data['a']
                ]);
            }

            return response()->json([
                'quote' => 'Failed to fetch quote',
            ], 500);
        } catch (\Exception $e) {
            return response()->json([
                'quote' => 'Error: ' . $e->getMessage()
            ], 500);
        }
    }
}
