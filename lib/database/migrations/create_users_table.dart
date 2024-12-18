import 'package:vania/vania.dart';

class CreateUserTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('users', () {
      id();
      char('email', length: 100);
      char('username', length: 50);
      char('password', length: 100);
      timeStamps();
      primary("id");
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('users'); // Menghapus tabel jika ada
  }
}
