import 'package:vania/vania.dart';
import 'package:vania_crud_tio/app/models/orders.dart';

class CreateOrdersTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('orders', () {
      integer('order_num');
      char('cust_id', length: 5);
      timeStamps();
      primary("order_num");
      foreign('cust_id', 'customers', 'cust_id');
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('orders');
  }
}
