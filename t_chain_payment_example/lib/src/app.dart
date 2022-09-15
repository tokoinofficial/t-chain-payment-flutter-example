import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:t_chain_payment_example/src/cart/cart_controller.dart';
import 'package:t_chain_payment_example/src/cart/cart_view.dart';
import 'package:t_chain_payment_example/src/products/products_controller.dart';
import 'package:t_chain_payment_example/src/products/products_service.dart';
import 'package:t_chain_payment_example/src/products/product_details_view.dart';
import 'package:t_chain_payment_example/src/products/product_list_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              ProductsController(ProductsService())..loadData(),
        ),
        ChangeNotifierProvider(create: (context) => CartController()),
      ],
      child: MaterialApp(
        restorationScopeId: 'app',
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English, no country code
        ],
        onGenerateTitle: (BuildContext context) =>
            AppLocalizations.of(context)!.appTitle,
        theme: ThemeData(),
        darkTheme: ThemeData.dark(),
        onGenerateRoute: (RouteSettings routeSettings) {
          return MaterialPageRoute<void>(
            settings: routeSettings,
            builder: (BuildContext context) {
              switch (routeSettings.name) {
                case CartView.routeName:
                  return const CartView();
                case ProductDetailsView.routeName:
                  final productID = routeSettings.arguments as String?;
                  if (productID == null) {
                    throw Exception('product id is missing');
                  }
                  return ProductDetailsView(productID: productID);
                case ProductListView.routeName:
                default:
                  return const ProductListView();
              }
            },
          );
        },
      ),
    );
  }
}
