import 'package:vania/vania.dart';
import 'package:vania_crud_tio/app/models/product_notes.dart';
import 'package:vania_crud_tio/app/models/products.dart';

class ProductsController extends Controller {
  Future<Response> index() async {
    return Response.json({'message': 'Hello World'});
  }

  Future<Response> create(Request request) async {
    request.validate({
      'vend_id': 'required',
      'prod_name': 'required',
      'prod_price': 'required',
      'prod_desc': 'required'
    }, {
      'vend_id.required': 'Vend ID tidak boleh kosong',
      'prod_name.required': 'Nama Product tidak boleh kosong',
      'prod_price.required': 'Harga tidak boleh kosong',
      'prod_desc.required': 'Deskripsi tidak boleh kosong',
    });

    final requestData = request.input();
    requestData['created_at'] = DateTime.now().toIso8601String();

    final existingProduct = await Products()
        .query()
        .where('prod_name', '=', requestData['prod_name'])
        .first();
    if (existingProduct != null) {
      return Response.json(
        {
          "message": "Product sudah terdaftar",
        },
        409,
      );
    }
    await Products().query().insert(requestData);

    return Response.json({
      "message": "Product berhasil ditambahkan",
      "data": requestData,
    }, 201);
  }

  Future<Response> store(Request request) async {
    return Response.json({});
  }

  Future<Response> show() async {
    final customers = await Products().query().get();
    if (customers.isEmpty) {
      return Response.json({
        "message": "daftar products",
        "data": [],
      }, 404);
    }
    return Response.json({
      "message": "daftar products",
      "data": customers,
    }, 200);
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }

  Future<Response> update(Request request, int prod_id) async {
    // Validasi input dari request
    request.validate({
      'vend_id': 'required',
      'prod_name': 'required',
      'prod_price': 'required',
      'prod_desc': 'required'
    }, {
      'vend_id.required': 'Vend ID tidak boleh kosong',
      'prod_name.required': 'Nama Product tidak boleh kosong',
      'prod_price.required': 'Harga tidak boleh kosong',
      'prod_desc.required': 'Deskripsi tidak boleh kosong',
    });

    // Ambil input data dari request
    final requestData = request.input();
    print("Data input: $requestData");

    // Tambahkan tanggal update
    requestData['updated_at'] = DateTime.now().toIso8601String();

    // Filter hanya kolom yang valid
    final validColumns = [
      'vend_id',
      'prod_name',
      'prod_price',
      'prod_desc',
    ];
    final Map<String, dynamic> filteredData = Map<String, dynamic>.fromEntries(
        requestData.entries.where((entry) => validColumns.contains(entry.key)));

    try {
      // Update data berdasarkan cust_id
      final affectedRows = await Products()
          .query()
          .where('prod_id', '=', prod_id)
          .update(filteredData);

      // Jika tidak ada baris yang terpengaruh (data tidak ditemukan)
      if (affectedRows == 0) {
        return Response.json({
          "message": "Product dengan id $prod_id tidak ditemukan",
        }, 404);
      }

      // Jika update berhasil
      return Response.json({
        "message": "Product berhasil diupdate",
        "data": filteredData,
      }, 200);
    } catch (e) {
      print("Error: $e"); // Debugging error
      return Response.json({
        "message": "Terjadi kesalahan saat memperbarui data",
        "error": e.toString(),
      }, 500);
    }
  }

  Future<Response> destroy(int prodId) async {
    try {
      // First, delete related productnotes records
      final deletedNotes =
          await ProductNotes().query().where('prod_id', '=', prodId).delete();

      // Optionally, you can check if there were any related notes and handle it
      if (deletedNotes > 0) {
        print("Deleted $deletedNotes related productnotes records.");
      }

      // Now, delete the product record
      final affectedRows =
          await Products().query().where('prod_id', '=', prodId).delete();

      // If no rows were affected (product not found)
      if (affectedRows == 0) {
        return Response.json({
          "message": "Product dengan id $prodId tidak ditemukan",
        }, 404);
      }

      // If deletion was successful
      return Response.json({
        "message": "Product dengan id $prodId berhasil dihapus",
      }, 200);
    } catch (e) {
      // Handle errors
      print("Error: $e"); // Debugging error
      return Response.json({
        "message": "Terjadi kesalahan saat menghapus data",
        "error": e.toString(),
      }, 500);
    }
  }
}

final ProductsController productsController = ProductsController();
