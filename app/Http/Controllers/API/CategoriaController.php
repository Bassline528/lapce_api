<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Categoria;
use Illuminate\Http\Request;
use App\Http\Resources\CategoriaResource;
use Illuminate\Support\Facades\Validator as FacadesValidator;

class CategoriaController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        //
        $categoria = Categoria::all();

        return response([
            'categorias' => CategoriaResource::collection($categoria),
            'message' => 'Retrieved Sucessfully'
        ], 200);
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        //
        $data = $request->all();

        $validator = FacadesValidator::make($data, [
            'nombre' => 'required|max:255',
            'sub_categoria' => 'required|max:255',
            'descripcion' => 'required|max:255',
        ]);

        if($validator->fails()) {
            return response ([
                'error' => $validator->errors(),
                'message' => 'Validation Fail'
            ], 400);
        }

        $categoria = Categoria::create($data);

        return response([
            'categoria' => new CategoriaResource($categoria), 
            'message' => 'Created Sucessfully'
        ], 200);
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\Categoria  $categoria
     * @return \Illuminate\Http\Response
     */
    public function show(Categoria $categoria)
    {
        //
        return response([
            'producto' => new CategoriaResource($categoria), 
            'message' => 'Retrieved Sucessfully'
        ], 200);
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\Categoria  $categoria
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, Categoria $categoria)
    {
        //
        $categoria->update($request->all());
        return response([
            'categoria' => new CategoriaResource($categoria), 
            'message' => 'Updated Sucessfully'
        ], 200);
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\Categoria  $categoria
     * @return \Illuminate\Http\Response
     */
    public function destroy(Categoria $categoria)
    {
        //
        $categoria->delete();
        return response([
            'message' => 'Deleted Sucessfully'
        ], 200);
    }
}
