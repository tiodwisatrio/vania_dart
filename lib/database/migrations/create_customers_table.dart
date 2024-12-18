import 'package:vania/vania.dart';
import 'package:vania_crud_tio/app/models/customers.dart';

class CreateCustomersTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('customers', () {
      char('cust_id', length: 5);
      char('cust_name', length: 50);
      char('cust_address', length: 100);
      char('cust_city', length: 20);
      char('cust_state', length: 20);
      char('cust_zip', length: 7);
      char('cust_country', length: 25);
      char('cust_telp', length: 15);
      timeStamps();
      primary("cust_id");
    });
  }

  @override
  Future<void> down() async {
    super.down();
    // Menghapus tabel customers jika ada
    await dropIfExists('customers');
  }
}
