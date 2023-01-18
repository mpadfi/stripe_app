import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stripe_app/bloc/pagar/pagar_bloc.dart';
import 'package:stripe_app/pages/home_page.dart';
import 'package:stripe_app/pages/pago_completo_page.dart';
import 'package:stripe_app/services/stripe_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //
    //* Inicializar StripeService
    StripeService().init();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => PagarBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'StripeApp',
        initialRoute: 'home',
        routes: {
          'home': (_) => HomePage(),
          'pago': (_) => PagoPage(),
        },
        theme: ThemeData(
          colorScheme: const ColorScheme.light().copyWith(
            primary: const Color(0xff023261),
          ),
        ).copyWith(
          scaffoldBackgroundColor: const Color(0xff072147),
        ),
      ),
    );
  }
}
