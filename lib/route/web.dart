import 'package:vania/vania.dart';

class WebRoute implements Route {
  @override
  void register() {
    Router.get("/", () {
      return Response.html(
          "<span>Welcome to Vania Framework - Tio Dwi Satrio</span>");
    });
  }
}
