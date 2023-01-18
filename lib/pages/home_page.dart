import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:stripe_app/bloc/pagar/pagar_bloc.dart';
import 'package:stripe_app/data/tarjetas.dart';
import 'package:stripe_app/helpers/helpers.dart';
import 'package:stripe_app/pages/tarjeta_page.dart';
import 'package:stripe_app/services/stripe_service.dart';
import 'package:stripe_app/widgets/total_pay_button.dart';

class HomePage extends StatelessWidget {
  //
  final stripeService = StripeService();

  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    //
    final size = MediaQuery.of(context).size;
    final pagarBloc = BlocProvider.of<PagarBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xff5BBDFF)),
            onPressed: () async {
              //
              mostrarLoading(context);

              final amount = pagarBloc.state.cantidadPagarString;
              final currency = pagarBloc.state.moneda;
              final resp = await stripeService.pagarConNuevaTarjeta(
                amount: amount,
                currency: currency,
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
          )
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            width: size.width,
            height: size.height,
            top: 200,
            child: PageView.builder(
              controller: PageController(
                viewportFraction: 0.9,
              ),
              physics: const BouncingScrollPhysics(),
              itemCount: tarjetas.length,
              itemBuilder: (_, i) {
                final tarjeta = tarjetas[i];
                return GestureDetector(
                  onTap: () {
                    //* SELECCIONAR TARJETA EN BLOC
                    BlocProvider.of<PagarBloc>(context).add(OnSeleccionarTarjeta(tarjeta));
                    Navigator.push(context, navegarFadeIn(context, TarjetaPage()));
                  },
                  child: Hero(
                    tag: tarjeta.cardNumber,
                    child: CreditCardWidget(
                      cardNumber: tarjeta.cardNumberHidden,
                      expiryDate: tarjeta.expiracyDate,
                      cardHolderName: tarjeta.cardHolderName,
                      isHolderNameVisible: true,
                      cvvCode: tarjeta.cvv,
                      showBackView: false,
                      cardBgColor: tarjeta.cardColor,
                      onCreditCardWidgetChange: (CreditCardBrand) {},
                    ),
                  ),
                );
              },
            ),
          ),
          const Positioned(
            bottom: 0,
            child: TotalPayButton(),
          )
        ],
      ),
    );
  }
}
