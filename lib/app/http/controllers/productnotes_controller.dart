import 'dart:ffi';

import 'package:vania/vania.dart';
import '../../models/product_notes.dart';

class ProductnotesController extends Controller {
  Future<Response> index() async {
    return Response.json({'message': 'Hello World'});
  }

  Future<Response> create(Request request) async {
    request.validate({
      'note_id': 'required',
      'prod_id': 'required',
      'note_date': 'required',
      'note_text': 'required',
    }, {
      'note_id.required': 'note id tidak boleh kosong',
      'prod_id.required': 'prod id tidak boleh kosong',
      'note_date.required': 'date tidak boleh kosong',
      'note_text.required': 'text tidak boleh kosong',
    });

    final requestData = request.input();
    requestData['created_at'] = DateTime.now().toIso8601String();

    final existingNotes = await ProductNotes()
        .query()
        .where('note_id', '=', requestData['note_id'])
        .first();
    if (existingNotes != null) {
      return Response.json(
        {
          "message": "Product Notes sudah terdaftar",
        },
        409,
      );
    }
    await ProductNotes().query().insert(requestData);

    return Response.json({
      "message": "Product Notes berhasil ditambahkan",
      "data": requestData,
    }, 201);
  }

  Future<Response> store(Request request) async {
    return Response.json({});
  }

  Future<Response> show() async {
    final productNotes = await ProductNotes().query().get();
    if (productNotes.isEmpty) {
      return Response.json({
        "message": "daftar Product Notes",
        "data": [],
      }, 404);
    }
    return Response.json({
      "message": "Daftar Product Notes",
      "data": productNotes,
    }, 200);
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }

  Future<Response> update(Request request, int note_id) async {
    // Validasi input dari request
    request.validate({
      'prod_id': 'required',
      'note_date': 'required',
      'note_text': 'required',
    }, {
      'prod_id.required': 'prod id tidak boleh kosong',
      'note_date.required': 'date tidak boleh kosong',
      'note_text.required': 'text tidak boleh kosong',
    });

    // Ambil input data dari request
    final requestData = request.input();
    print("Data input: $requestData");

    // Tambahkan tanggal update
    requestData['updated_at'] = DateTime.now().toIso8601String();

    // Filter hanya kolom yang valid
    final validColumns = [
      'prod_id',
      'note_date',
      'note_text',
    ];
    final Map<String, dynamic> filteredData = Map<String, dynamic>.fromEntries(
        requestData.entries.where((entry) => validColumns.contains(entry.key)));

    try {
      // Update data berdasarkan cust_id
      final affectedRows = await ProductNotes()
          .query()
          .where('note_id', '=', note_id)
          .update(filteredData);

      // Jika tidak ada baris yang terpengaruh (data tidak ditemukan)
      if (affectedRows == 0) {
        return Response.json({
          "message": "Product Notes dengan id $note_id tidak ditemukan",
        }, 404);
      }

      // Jika update berhasil
      return Response.json({
        "message": "Product Notes berhasil diupdate",
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

  Future<Response> destroy(int note_id) async {
    try {
      // Menghapus data berdasarkan cust_id
      final affectedRows =
          await ProductNotes().query().where('note_id', '=', note_id).delete();

      // Jika tidak ada baris yang terpengaruh (data tidak ditemukan)
      if (affectedRows == 0) {
        return Response.json({
          "message": "Product Notes dengan id $note_id tidak ditemukan",
        }, 404);
      }

      // Jika delete berhasil
      return Response.json({
        "message": "Product Notes dengan id $note_id berhasil dihapus",
      }, 200);
    } catch (e) {
      // Tangani jika terjadi error saat query
      print("Error: $e"); // Debugging error
      return Response.json({
        "message": "Terjadi kesalahan saat menghapus data",
        "error": e.toString(),
      }, 500);
    }
  }
}

final ProductnotesController productnotesController = ProductnotesController();
