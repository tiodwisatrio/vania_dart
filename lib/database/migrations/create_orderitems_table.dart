import 'package:vania/vania.dart';

class CreateOrderItemsTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('orderitems', () {
      integer('order_item');
      integer('order_num');
      char('prod_id', length: 10);
      integer('quantity');
      integer('size');
      timeStamps();
      primary("order_item");
      foreign('order_num', 'orders', 'order_num');
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('orderitems');
  }
}
