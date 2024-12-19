import 'package:vania/vania.dart';

import 'package:vania_crud_tio/app/models/user.dart';

class RegisterController extends Controller {
  Future<Response> register(Request request) async {
    // Validasi input
    request.validate({
      'email': 'required',
      'username': 'required',
      'password': 'required',
    }, {
      'email.required': 'Email tidak boleh kosong',
      'username.required': 'Username tidak boleh kosong',
      'password.required': 'Password tidak boleh kosong',
    });

    final requestData = request.input();

    final existingCustomer = await User()
        .query()
        .where('username', '=', requestData['username'])
        .first();
    if (existingCustomer != null) {
      return Response.json(
        {
          "message": "User sudah terdaftar",
        },
        409,
      );
    }
    await User().query().insert(requestData);

    return Response.json({
      "message": "User berhasil melakukan pendaftaran",
      "data": requestData,
    }, 201);
  }
}

final RegisterController registerController = RegisterController();
