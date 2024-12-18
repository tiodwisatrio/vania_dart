import 'package:vania/vania.dart';
import 'package:vania_crud_tio/app/models/vendors.dart';

class CreateVendorsTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('vendors', () {
      char('vend_id', length: 5);
      char('vend_name', length: 50);
      text('vend_address');
      char('vend_kota', length: 50);
      char('vend_state', length: 20);
      char('vend_zip', length: 7);
      char('vend_country', length: 25);
      timeStamps();
      primary("vend_id");
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('vendors');
  }
}
