import 'package:vania/vania.dart';
import '../../models/customers.dart';

class CustomersController extends Controller {
  Future<Response> create(Request request) async {
    request.validate({
      'cust_name': 'required',
      'cust_address': 'required',
      'cust_city': 'required',
      'cust_state': 'required',
      'cust_zip': 'required',
      'cust_country': 'required',
      'cust_telp': 'required',
    }, {
      'cust_name.required': 'nama tidak boleh kosong',
      'cust_address.required': 'alamat tidak boleh kosong',
      'cust_city.required': 'kota tidak boleh kosong',
      'cust_state.required': 'daerah tidak boleh kosong',
      'cust_zip.required': 'zip tidak boleh kosong',
      'cust_country.required': 'negara tidak boleh kosong',
      'cust_telp.required': 'telepon tidak boleh kosong',
    });

    final requestData = request.input();
    requestData['created_at'] = DateTime.now().toIso8601String();

    final existingCustomer = await Customers()
        .query()
        .where('cust_name', '=', requestData['cust_name'])
        .first();
    if (existingCustomer != null) {
      return Response.json(
        {
          "message": "Customers sudah terdaftar",
        },
        409,
      );
    }
    await Customers().query().insert(requestData);

    return Response.json({
      "message": "product berhasil ditambahkan",
      "data": requestData,
    }, 201);
  }

  Future<Response> store(Request request) async {
    return Response.json({});
  }

  Future<Response> show() async {
    final customers = await Customers().query().get();
    if (customers.isEmpty) {
      return Response.json({
        "message": "daftar customers",
        "data": [],
      }, 404);
    }
    return Response.json({
      "message": "daftar customers",
      "data": customers,
    }, 200);
  }

  Future<Response> update(Request request, int cust_id) async {
    // Validasi input dari request
    request.validate({
      'cust_name': 'required',
      'cust_address': 'required',
      'cust_city': 'required',
      'cust_state': 'required',
      'cust_zip': 'required',
      'cust_country': 'required',
      'cust_telp': 'required',
    }, {
      'cust_name.required': 'Nama tidak boleh kosong',
      'cust_address.required': 'Alamat tidak boleh kosong',
      'cust_city.required': 'Kota tidak boleh kosong',
      'cust_state.required': 'Daerah tidak boleh kosong',
      'cust_zip.required': 'Zip tidak boleh kosong',
      'cust_country.required': 'Negara tidak boleh kosong',
      'cust_telp.required': 'Telepon tidak boleh kosong',
    });

    // Ambil input data dari request
    final requestData = request.input();
    print("Data input: $requestData");

    // Tambahkan tanggal update
    requestData['updated_at'] = DateTime.now().toIso8601String();

    // Filter hanya kolom yang valid
    final validColumns = [
      'cust_name',
      'cust_address',
      'cust_city',
      'cust_state',
      'cust_zip',
      'cust_country',
      'cust_telp',
      'updated_at',
    ];
    final Map<String, dynamic> filteredData = Map<String, dynamic>.fromEntries(
        requestData.entries.where((entry) => validColumns.contains(entry.key)));

    try {
      // Update data berdasarkan cust_id
      final affectedRows = await Customers()
          .query()
          .where('cust_id', '=', cust_id)
          .update(filteredData);

      // Jika tidak ada baris yang terpengaruh (data tidak ditemukan)
      if (affectedRows == 0) {
        return Response.json({
          "message": "Customer dengan id $cust_id tidak ditemukan",
        }, 404);
      }

      // Jika update berhasil
      return Response.json({
        "message": "Customer berhasil diupdate",
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

  Future<Response> destroy(int id) async {
    try {
      // Menghapus data berdasarkan cust_id
      final affectedRows =
          await Customers().query().where('cust_id', '=', id).delete();

      // Jika tidak ada baris yang terpengaruh (data tidak ditemukan)
      if (affectedRows == 0) {
        return Response.json({
          "message": "Customer dengan id $id tidak ditemukan",
        }, 404);
      }

      // Jika delete berhasil
      return Response.json({
        "message": "Customer dengan id $id berhasil dihapus",
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

final CustomersController customersController = CustomersController();
