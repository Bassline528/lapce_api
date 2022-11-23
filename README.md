# Pasos para correr

### 1. Instalar paquetes

En la terminal correr
```
$ php composer install
```
### 2. Crear un .env en el root del proyecto

Vas a tomar el .env.examle y copiar todo su contenido, creas un archivo .env y pegas todo, luego seteas la configuracion de la base de datos 

Ejemplo:

```
DB_CONNECTION=pgsql
DB_HOST=127.0.0.1
DB_PORT=5432
DB_DATABASE=lapce_db
DB_USERNAME=tarea4_user
DB_PASSWORD=admin
```

### 3. No se porque hay que correr este comando

```
$ php artisan passport:install
```

## Como crear funcionalidades/endpoints

Correr el siguiente comando
```
$ php artisan make:model <nombre_de_la_funcionalidad> -mcr
```

Esto generara 3 archivos

```
app/Models/<nombre_de_la_funcionalidad>.php
app/Http/Controllers/<nombre_de_la_funcionalidad>Controller.php
database/migrations/<fecha_y_hora_de_creacion>_create_<nombre_de_la_funcionalidad>_table.php
````

Luego correr el siguiente comando:
```
$ php artisan make:resource <nombre_de_la_funcionalidad>Resource
```
Basicamente lo que hara este comando es generar un archivo en **app/Http/Resources/<nombre_de_la_funcionalidad>Resource.php** y lo que contiene este archivo es una funcion para convertir a json tu objeto.

Luego de correr ese comando iremos al la carpeta migrations y al archivo que se acaba de generar, se tendra algo asi:

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('productos', function (Blueprint $table) { //Aca se define el nombre de la tabla que se va a generar en la base de datos
            $table->id();//Aca se definen los atributos que tiene la tabla
            $table->unsignedBigInteger('id_categoria'); //Aca se definen que tiene un ID
            $table->string('nombre');
            $table->string('descripcion');
            $table->integer('precio');
            $table->timestamps();

            $table->foreign('id_categoria')->references('id')->on('categorias'); // Aca se define que ese ID es un foreing key
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('productos');
    }
};
```

Luego en el archivo models hay que definir que atributos vienen en el response:

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Producto extends Model
{
    use HasFactory;

     /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [ // Aca se definen esos atributos, fijarse que ID no viene porque ese se genera al insertar en la base de datos
        'id_categoria',
        'nombre',
        'descripcion',
        'precio',
    ];
}
```
En el archivo controlador es donde se coloca toda la logica (como hace el insert delete update etc.)

```php
<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Categoria;
use Illuminate\Http\Request;
use App\Http\Resources\CategoriaResource; //Te acordas del comando Resource? tenes que importarlo aca
use Illuminate\Support\Facades\Validator as FacadesValidator;

class CategoriaController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index() //GET ALL
    {
        //
        $categoria = Categoria::all();

        return response([
            'categorias' => CategoriaResource::collection($categoria), //Aca se usa el resource
            'message' => 'Retrieved Sucessfully' //Asi se retorna datos
        ], 200); //Status del response
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request) //CREATE
    {
        //
        $data = $request->all();

        $validator = FacadesValidator::make($data, [ //Aca se valida que la data venga correctamente
            'nombre' => 'required|max:255',
            'sub_categoria' => 'required|max:255',
            'descripcion' => 'required|max:255',
        ]);

        if($validator->fails()) { //Si falla, retornas error
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
    public function show(Categoria $categoria) //GET BY ID
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
    public function update(Request $request, Categoria $categoria) //UPDATE
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
    public function destroy(Categoria $categoria) //DELETE 
    {
        //
        $categoria->delete();
        return response([
            'message' => 'Deleted Sucessfully'
        ], 200);
    }
}
```

## Como agregar la ruta

Ir al siguiente archivo
```
routes/api.php //Lleva este nombre porque asi podemos apuntar a la URL /api
```

```php
<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\API\AuthController;
use App\Http\Controllers\API\CategoriaController;
use App\Http\Controllers\API\ProductoController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});
// Se pone Route::<metodo que se va a usar>
Route::post('/register', [AuthController::class, 'register']);  // en este caso ruta /api/register y utiliza el controlador Auth que es donde se realiza toda la logica de auth y register
Route::post('/login', [AuthController::class, 'login']); 
// Aca se pone asi porque asi me dijo el tutorial xd
// Parece que agrupa el crud o algo asi

Route::apiResource('/productos', ProductoController::class)->middleware('auth:api'); //Se le pasa el controlador de dicha funcionalidad para poder hacer el CRUD
Route::apiResource('/categorias', CategoriaController::class)->middleware('auth:api'); // Este middleware auth api es para que la ruta sea protegida y no pueda ser accedida sin el token de acceso

//SIEMPRE PRIMERO GENERAR EL TOKEN DE ACCESO CON EL LOGIN O EL REGISTER

```

## Paso final

Una vez hecho todo eso se ejecuta el siguiente comando

```
$php artisan migrate:fresh // Este fresh podes no meterle, basicamente lo que hace es que borra toda la data y genera todo desde 0, por ahi si ya tenes data cargada omitir
```

Este comando lo que va hacer es generar la tabla en la base de datos, asi de facil, sin SQL 

```
$ php artisan serve
```

para levantar la api
