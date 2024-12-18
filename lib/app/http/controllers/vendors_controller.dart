import 'package:vania/vania.dart';
import '../../models/vendors.dart';

class VendorsController extends Controller {
  Future<Response> index() async {
    return Response.json({'message': 'Hello World'});
  }

  Future<Response> create(Request request) async {
    request.validate({
      'vend_name': 'required',
      'vend_address': 'required',
      'vend_kota': 'required',
      'vend_state': 'required',
      'vend_zip': 'required',
      'vend_country': 'required',
    }, {
      'vend_name.required': 'nama tidak boleh kosong',
      'vend_address.required': 'alamat tidak boleh kosong',
      'vend_kota.required': 'kota tidak boleh kosong',
      'vend_state.required': 'daerah tidak boleh kosong',
      'vend_zip.required': 'zip tidak boleh kosong',
      'vend_country.required': 'negara tidak boleh kosong',
    });

    final requestData = request.input();
    requestData['created_at'] = DateTime.now().toIso8601String();

    final existingCustomer = await Vendors()
        .query()
        .where('vend_name', '=', requestData['vend_name'])
        .first();
    if (existingCustomer != null) {
      return Response.json(
        {
          "message": "Vendor sudah terdaftar",
        },
        409,
      );
    }
    await Vendors().query().insert(requestData);

    return Response.json({
      "message": "vendor berhasil ditambahkan",
      "data": requestData,
    }, 201);
  }

  Future<Response> store(Request request) async {
    return Response.json({});
  }

  Future<Response> show() async {
    final customers = await Vendors().query().get();
    if (customers.isEmpty) {
      return Response.json({
        "message": "daftar vendors",
        "data": [],
      }, 404);
    }
    return Response.json({
      "message": "daftar vendors",
      "data": customers,
    }, 200);
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }

  Future<Response> update(Request request, int vend_id) async {
    // Validasi input dari request
    request.validate({
      'vend_name': 'required',
      'vend_address': 'required',
      'vend_kota': 'required',
      'vend_state': 'required',
      'vend_zip': 'required',
      'vend_country': 'required',
    }, {
      'vend_name.required': 'nama tidak boleh kosong',
      'vend_address.required': 'alamat tidak boleh kosong',
      'vend_kota.required': 'kota tidak boleh kosong',
      'vend_state.required': 'daerah tidak boleh kosong',
      'vend_zip.required': 'zip tidak boleh kosong',
      'vend_country.required': 'negara tidak boleh kosong',
    });

    // Ambil input data dari request
    final requestData = request.input();
    print("Data input: $requestData");

    // Tambahkan tanggal update
    requestData['updated_at'] = DateTime.now().toIso8601String();

    // Filter hanya kolom yang valid
    final validColumns = [
      'vend_name',
      'vend_address',
      'vend_kota',
      'vend_state',
      'vend_zip',
      'vend_country',
    ];
    final Map<String, dynamic> filteredData = Map<String, dynamic>.fromEntries(
        requestData.entries.where((entry) => validColumns.contains(entry.key)));

    try {
      // Update data berdasarkan cust_id
      final affectedRows = await Vendors()
          .query()
          .where('vend_id', '=', vend_id)
          .update(filteredData);

      // Jika tidak ada baris yang terpengaruh (data tidak ditemukan)
      if (affectedRows == 0) {
        return Response.json({
          "message": "Vendor dengan id $vend_id tidak ditemukan",
        }, 404);
      }

      // Jika update berhasil
      return Response.json({
        "message": "Vendor berhasil diupdate",
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

  Future<Response> destroy(int vend_id) async {
    try {
      // Menghapus data berdasarkan cust_id
      final affectedRows =
          await Vendors().query().where('vend_id', '=', vend_id).delete();

      // Jika tidak ada baris yang terpengaruh (data tidak ditemukan)
      if (affectedRows == 0) {
        return Response.json({
          "message": "Vendor dengan id $vend_id tidak ditemukan",
        }, 404);
      }

      // Jika delete berhasil
      return Response.json({
        "message": "Vendor dengan id $vend_id berhasil dihapus",
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

final VendorsController vendorsController = VendorsController();
