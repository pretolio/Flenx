// Ilha Flutter do carrinho na rota `/carrinho`. O `cart_page.imports.dart` é
// gerado pelo jaspr_builder a partir do @Import.onWeb (fica no .gitignore).
import 'package:flenx/embed.dart';
import 'package:flenx/flenx.dart';

@Import.onWeb('cart_app.dart', show: [#CartApp])
import 'cart_page.imports.dart' deferred as cart;

@client
class CartPage extends StatelessComponent {
  const CartPage({super.key});

  @override
  Component build(BuildContext context) {
    return FlenxFullscreen(
      FlutterIsland(
        loadLibrary: cart.loadLibrary(),
        builder: () => cart.CartApp(),
      ),
    );
  }
}
