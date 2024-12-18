import 'package:vania/vania.dart';
import '../../models/orders.dart';
import '../../models/customers.dart';

class OrdersController extends Controller {
  Future<Response> show() async {
    final orders = await Orders().query().get();
    if (orders.isEmpty) {
      return Response.json({
        "message": "Tidak ada data orders",
        "data": [],
      }, 404);
    }
    return Response.json({
      "message": "Daftar orders",
      "data": orders,
    }, 200);
  }

  Future<Response> create(Request request) async {
    request.validate({
      'cust_id': 'required',
    }, {
      'cust_id.required': 'Customer ID tidak boleh kosong',
    });

    final requestData = request.input();
    requestData['created_at'] = DateTime.now().toIso8601String();

    final customer = await Customers()
        .query()
        .where('cust_id', '=', requestData['cust_id'])
        .first();
    if (customer == null) {
      return Response.json({
        "message":
            "Customer dengan ID ${requestData['cust_id']} tidak ditemukan",
      }, 404);
    }

    await Orders().query().insert(requestData);

    return Response.json({
      "message": "Order berhasil ditambahkan",
      "data": requestData,
    }, 201);
  }

  Future<Response> store(Request request) async {
    return Response.json({});
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }

  Future<Response> update(Request request, int orderNum) async {
    // Validasi input
    request.validate({
      'cust_id': 'required',
    }, {
      'cust_id.required': 'Customer ID tidak boleh kosong',
    });

    // Ambil data dari request dan tambahkan timestamp
    final requestData = request.input();
    requestData['updated_at'] = DateTime.now().toIso8601String();

    // Debugging: Log isi requestData
    print('Request data sebelum update: $requestData');

    // Pastikan kolom yang tidak relevan dihapus
    requestData.remove('id'); // Hapus 'id' jika ada
    requestData.remove('order_num'); // Hindari mengubah primary key

    // Debugging: Log isi requestData setelah pembersihan
    print('Request data setelah pembersihan: $requestData');

    // Lakukan update berdasarkan kolom 'order_num'
    final affectedRows = await Orders()
        .query()
        .where('order_num', '=', orderNum)
        .update(requestData);

    // Jika tidak ada baris yang diperbarui
    if (affectedRows == 0) {
      return Response.json({
        "message": "Order dengan nomor $orderNum tidak ditemukan",
      }, 404);
    }

    // Jika update berhasil
    return Response.json({
      "message": "Order berhasil diupdate",
      "data": requestData,
    }, 200);
  }

  Future<Response> destroy(Request request, int orderNum) async {
    // Cari apakah data dengan 'order_num' ada di database
    final existingOrder =
        await Orders().query().where('order_num', '=', orderNum).first();

    // Jika data tidak ditemukan
    if (existingOrder == null) {
      return Response.json({
        "message": "Order dengan nomor $orderNum tidak ditemukan",
      }, 404);
    }

    // Hapus data berdasarkan 'order_num'
    final affectedRows =
        await Orders().query().where('order_num', '=', orderNum).delete();

    // Jika berhasil dihapus
    return Response.json({
      "message": "Order dengan nomor $orderNum berhasil dihapus",
    }, 200);
  }


}

final OrdersController ordersController = OrdersController();
