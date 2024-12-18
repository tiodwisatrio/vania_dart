import 'package:vania/vania.dart';
import 'package:vania_crud_tio/app/models/products.dart';

class CreateProductsTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('products', () {
      char('prod_id', length: 10);
      char('vend_id', length: 5);
      char('prod_name', length: 25);
      integer('prod_price');
      text('prod_desc');
      timeStamps();
      primary("prod_id");
      foreign('vend_id', 'vendors', 'vend_id');
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('products');
  }
}
