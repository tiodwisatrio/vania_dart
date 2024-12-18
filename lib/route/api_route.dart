import 'package:vania/vania.dart';
import 'package:vania_crud_tio/app/http/controllers/customers_controller.dart';
import 'package:vania_crud_tio/app/http/controllers/home_controller.dart';
import 'package:vania_crud_tio/app/http/controllers/login_controller.dart';
import 'package:vania_crud_tio/app/http/controllers/orderitems_controller.dart';
import 'package:vania_crud_tio/app/http/controllers/orders_controller.dart';
import 'package:vania_crud_tio/app/http/controllers/vendors_controller.dart';
import 'package:vania_crud_tio/app/http/controllers/productnotes_controller.dart';
import 'package:vania_crud_tio/app/http/controllers/products_controller.dart';
import 'package:vania_crud_tio/app/http/middleware/authenticate.dart';
import 'package:vania_crud_tio/app/http/middleware/home_middleware.dart';
import 'package:vania_crud_tio/app/http/middleware/error_response_middleware.dart';

class ApiRoute implements Route {
  @override
  void register() {
    Router.post('/create_customers', customersController.create);
    Router.get('/customers', customersController.show);
    Router.put('/edit_customers/{id}', customersController.update);
    Router.delete('/delete_customers/{id}', customersController.destroy);

    Router.post('/create_orders', ordersController.create);
    Router.get('/orders', ordersController.show);
    Router.put('/edit_orders/{id}', ordersController.update);
    Router.delete('/delete_orders/{id}', ordersController.destroy);

    Router.post('/create_orderitems', orderitemsController.create);
    Router.get('/orderitems', orderitemsController.show);
    Router.put('/edit_orderitems/{id}', orderitemsController.update);
    Router.delete('/delete_orderitems/{id}', orderitemsController.destroy);

    Router.post('/create_vendors', vendorsController.create);
    Router.get('/vendors', vendorsController.show);
    Router.put('/edit_vendors/{id}', vendorsController.update);
    Router.delete('/delete_vendors/{id}', vendorsController.destroy);

    Router.post('/create_productnotes', productnotesController.create);
    Router.get('/productnotes', productnotesController.show);
    Router.put('/edit_productnotes/{id}', productnotesController.update);
    Router.delete('/delete_productnotes/{id}', productnotesController.destroy);

    Router.post('/create_products', productsController.create);
    Router.get('/products', productsController.show);
    Router.put('/edit_products/{id}', productsController.update);
    Router.delete('/delete_products/{id}', productsController.destroy);

    Router.post('/login', loginController.login);
  }
}
