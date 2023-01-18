import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:stripe_app/bloc/pagar/pagar_bloc.dart';
import 'package:stripe_app/widgets/total_pay_button.dart';

class TarjetaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //
    final tarjeta = BlocProvider.of<PagarBloc>(context).state.tarjeta;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Pagar'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              //* DESACTIVAR TARJETA EN BLOC
              BlocProvider.of<PagarBloc>(context).add(OnDesactivarTarjeta());
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: tarjeta!.cardNumber,
              child: CreditCardWidget(
                cardNumber: tarjeta.cardNumberHidden,
                expiryDate: tarjeta.expiracyDate,
                cardHolderName: tarjeta.cardHolderName,
                cvvCode: tarjeta.cvv,
                showBackView: false,
                cardBgColor: tarjeta.cardColor,
                onCreditCardWidgetChange: (CreditCardBrand) {},
              ),
            ),
            const Positioned(
              bottom: 0,
              child: TotalPayButton(),
            )
          ],
        ));
  }
}
