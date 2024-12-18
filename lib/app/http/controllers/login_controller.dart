import 'package:vania/vania.dart';
import 'package:vania_crud_tio/app/models/user.dart';
import '../../models/user.dart';

class LoginController extends Controller {
  Future<Response> login(Request request) async {
    request.validate({
      'username': 'required',
      'password': 'required',
    }, {
      'username.required': 'Username tidak boleh kosong',
      'password.required': 'Password tidak boleh kosong',
    });

    final data = request.input();
    final username = data['username'];
    final password = data['password'];

    print("Input username: $username");
    print("Input password: $password");

    final user = await User()
        .query()
        .where('username', '=', username)
        .where('password', '=', password)
        .first();

    if (user == null) {
      return Response.json({
        "message": "Username atau password salah",
      }, 401);
    }

    return Response.json({
      "message": "Login berhasil",
      "user": {
        "id": user['id'],
        "username": user['username'],
      },
    }, 200);
  }
}

final LoginController loginController = LoginController();
