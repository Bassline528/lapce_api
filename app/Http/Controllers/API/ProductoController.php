<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Producto;
use Illuminate\Http\Request;
use App\Http\Resources\ProductoResource;
use Illuminate\Support\Facades\Validator as FacadesValidator;

class ProductoController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        //
        $producto = Producto::all();

        return response(
            ['productos' => ProductoResource::collection($producto),
            'message' => 'Retrieved Sucessfully'], 200);
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
            'id_categoria' => 'required',
            'descripcion' => 'required|max:255',
            'precio' => 'required'
        ]);

        if($validator->fails()) {
            return response ([
                'error' => $validator->errors(),
                'message' => 'Validation Fail'
            ], 400);
        }

        $producto = Producto::create($data);

        return response([
            'producto' => new ProductoResource($producto), 
            'message' => 'Created Sucessfully'
        ], 200);
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\Producto  $Producto
     * @return \Illuminate\Http\Response
     */
    public function show(Producto $producto)
    {
        //
        return response([
            'producto' => new ProductoResource($producto), 
            'message' => 'Retrieved Sucessfully'
        ], 200);
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Models\Producto  $Producto
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, Producto $producto)
    {
        //
        $producto->update($request->all());
        return response([
            'producto' => new ProductoResource($producto), 
            'message' => 'Updated Sucessfully'
        ], 200);
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\Producto  $Producto
     * @return \Illuminate\Http\Response
     */
    public function destroy(Producto $producto)
    {
        //
        $producto->delete();
        return response([
            'message' => 'Deleted Sucessfully'
        ], 200);
    }
}
