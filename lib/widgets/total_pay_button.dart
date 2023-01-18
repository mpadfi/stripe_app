import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stripe_app/bloc/pagar/pagar_bloc.dart';
import 'package:stripe_app/helpers/helpers.dart';
import 'package:stripe_app/services/stripe_service.dart';
import 'package:stripe_payment/stripe_payment.dart';

class TotalPayButton extends StatelessWidget {
  const TotalPayButton({super.key});

  @override
  Widget build(BuildContext context) {
    //
    final width = MediaQuery.of(context).size.width;
    final pagarBloc = BlocProvider.of<PagarBloc>(context);
    final cantidadPagar = pagarBloc.state.cantidadPagar;
    final moneda = pagarBloc.state.moneda;

    return Container(
      width: width,
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Total', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text('$cantidadPagar $moneda', style: const TextStyle(fontSize: 20)),
            ],
          ),
          //* BLOCK BUILDER
          BlocBuilder<PagarBloc, PagarState>(
            builder: (context, state) {
              return _BtnPay(state);
            },
          )
        ],
      ),
    );
  }
}

class _BtnPay extends StatelessWidget {
  //
  final PagarState state;

  const _BtnPay(this.state);

  @override
  Widget build(BuildContext context) {
    return state.tarjetaActiva ? buildBotonTarjeta(context) : buildAppleAndGooglePay(context);
  }

  Widget buildBotonTarjeta(BuildContext context, [bool mounted = true]) {
    return MaterialButton(
      height: 45,
      minWidth: 170,
      shape: const StadiumBorder(),
      color: Colors.black,
      onPressed: () async {
        //
        mostrarLoading(context);

        final stripeService = StripeService();
        final state = BlocProvider.of<PagarBloc>(context).state;
        final tarjeta = state.tarjeta;
        final monthYear = tarjeta!.expiracyDate.split('/');

        final resp = await stripeService.pagarConTarjetaExistente(
          amount: state.cantidadPagarString,
          currency: state.moneda,
          card: CreditCard(
            number: tarjeta.cardNumber,
            expMonth: int.parse(monthYear[0]),
            expYear: int.parse(monthYear[1]),
          ),
        );

        // ocultar loading
        if (!mounted) return;
        Navigator.pop(context);

        if (resp.ok) {
          if (!mounted) return;
          mostrarAlerta(context, 'Tarjeta Añadida', 'Todo correcto!');
        } else {
          if (!mounted) return;
          mostrarAlerta(context, 'Algo salió mal', resp.msg!);
        }
      },
      child: Row(children: const [
        Icon(
          FontAwesomeIcons.solidCreditCard,
          color: Colors.white,
        ),
        SizedBox(width: 10),
        Text('Tarjeta', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ]),
    );
  }

  Widget buildAppleAndGooglePay(BuildContext context) {
    return MaterialButton(
      height: 45,
      minWidth: 150,
      shape: const StadiumBorder(),
      color: Colors.black,
      onPressed: () async {
        //
        //* PAGAR CON APPLE/GOOGLE PAY
        final state = BlocProvider.of<PagarBloc>(context).state;
        final stripeService = StripeService();
        final resp = await stripeService.pagarConAppleAndGooglePay(
          amount: state.cantidadPagarString,
          currency: state.moneda,
        );
      },
      child: Row(children: [
        Icon(
          Platform.isAndroid ? FontAwesomeIcons.google : FontAwesomeIcons.apple,
          color: Colors.white,
        ),
        const SizedBox(width: 5),
        const Text('Pay', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
      ]),
    );
  }
}
