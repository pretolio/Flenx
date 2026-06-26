// Ilha Flutter do carrinho na rota `/carrinho`. O `cart_page.imports.dart` é
// gerado pelo jaspr_builder a partir do @Import.onWeb (fica no .gitignore).
import 'package:flext/embed.dart';
import 'package:flext/flext.dart';
import 'package:jaspr/jaspr.dart';

@Import.onWeb('cart_app.dart', show: [#CartApp])
import 'cart_page.imports.dart' deferred as cart;

@client
class CartPage extends StatelessComponent {
  const CartPage({super.key});

  @override
  Component build(BuildContext context) {
    return FlextFullscreen(
      FlutterIsland(
        loadLibrary: cart.loadLibrary(),
        builder: () => cart.CartApp(),
      ),
    );
  }
}
