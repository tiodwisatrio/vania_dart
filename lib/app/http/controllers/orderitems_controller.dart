import 'package:vania/vania.dart';
import 'package:vania_crud_tio/app/models/order_items.dart';
// import 'package:vania_crud_tio/app/models/orders.dart';

class OrderitemsController extends Controller {
  Future<Response> show() async {
    final orderitems = await OrderItems().query().get();
    if (orderitems.isEmpty) {
      return Response.json({
        "message": "Tidak ada data orders",
        "data": [],
      }, 404);
    }
    return Response.json({
      "message": "Daftar orders items",
      "data": orderitems,
    }, 200);
  }

  Future<Response> create(Request request) async {
    request.validate({
      'prod_id': 'required',
      'quantity': 'required',
      'size': 'required'
    }, {
      'prod_id.required': 'Product ID tidak boleh kosong',
      'quantity.required': 'Quantity tidak boleh kosong',
      'size.required': 'Size tidak boleh kosong',
    });

    final requestData = request.input();
    requestData['created_at'] = DateTime.now().toIso8601String();

    final orderItems = await OrderItems()
        .query()
        .where('prod_id', '=', requestData['prod_id'])
        .first();
    if (orderItems == null) {
      return Response.json({
        "message":
            "Order Items dengan ${requestData['prod_id']} tidak ditemukan",
      }, 404);
    }

    await OrderItems().query().insert(requestData);

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

  Future<Response> update(Request request, int orderItem) async {
    // Validasi input
    request.validate({
      'prod_id': 'required',
      'quantity': 'required',
      'size': 'required'
    }, {
      'prod_id.required': 'Prod ID tidak boleh kosong',
      'quantity.required': 'Quantity tidak boleh kosong',
      'size.required': 'Size tidak boleh kosong',
    });

    // Ambil data dari request dan tambahkan timestamp
    final requestData = request.input();
    requestData['updated_at'] = DateTime.now().toIso8601String();

    // Debugging: Log isi requestData
    print('Request data sebelum update: $requestData');

    // Pastikan kolom yang tidak relevan dihapus
    requestData.remove('id'); // Hapus 'id' jika ada
    requestData.remove('order_item'); // Hindari mengubah primary key

    // Debugging: Log isi requestData setelah pembersihan
    print('Request data setelah pembersihan: $requestData');

    // Lakukan update berdasarkan kolom 'order_num'
    final affectedRows = await OrderItems()
        .query()
        .where('order_item', '=', orderItem)
        .update(requestData);

    // Jika tidak ada baris yang diperbarui
    if (affectedRows == 0) {
      return Response.json({
        "message": "Order dengan nomor $orderItem tidak ditemukan",
      }, 404);
    }

    // Jika update berhasil
    return Response.json({
      "message": "Order berhasil diupdate",
      "data": requestData,
    }, 200);
  }

  Future<Response> destroy(Request request, int orderItem) async {
    // Cari apakah data dengan 'order_item' ada di database
    final existingOrder =
        await OrderItems().query().where('prod_id', '=', orderItem).first();

    // Jika data tidak ditemukan
    if (existingOrder == null) {
      return Response.json({
        "message": "Order dengan nomor $orderItem tidak ditemukan",
      }, 404);
    }

    // Hapus data berdasarkan 'order_item'
    final affectedRows =
        await OrderItems().query().where('order_item', '=', orderItem).delete();

    // Jika berhasil dihapus
    return Response.json({
      "message": "Order dengan nomor $orderItem berhasil dihapus",
    }, 200);
  }
}

final OrderitemsController orderitemsController = OrderitemsController();
