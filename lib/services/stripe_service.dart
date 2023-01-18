import 'package:dio/dio.dart';
import 'package:stripe_app/models/payment_intent_response.dart';
import 'package:stripe_app/models/stripe_custom_response.dart';
import 'package:stripe_payment/stripe_payment.dart';

class StripeService {
  // Singleton
  StripeService._privateConstructor();
  static final StripeService _instance = StripeService._privateConstructor();
  factory StripeService() => _instance;

  final String _paymentApiUrl = 'https://api.stripe.com/v1/payment_intents';
  static const String _secretKey = 'sk_test_51MRFavCJmS86TGNA1qv84tdvw8oFA9WB84Pf1IXezFZ6IJNbvxaaQEm2nm9QPdUsqFtlmWHpuDlqSHyQ3aSwVCAL00BUrjAJ0b';
  final String _apiKey = 'pk_test_51MRFavCJmS86TGNA5LpQ9krcuACTxXFSEaFK9LYSxNlWRQwtR1OyFsDQwi7BZqCeqm7WNVQdGMyxfKOmFbV7z4cA00Ev2barYL';

  final headerOptions = Options(contentType: Headers.formUrlEncodedContentType, headers: {'Authorization': 'Bearer ${StripeService._secretKey}'});

  void init() {
    StripePayment.setOptions(StripeOptions(
      publishableKey: _apiKey,
      androidPayMode: 'test',
      merchantId: 'test',
    ));
  }

  Future<StripeCustomResponse> pagarConTarjetaExistente({required String amount, required String currency, required CreditCard card}) async {
    try {
      final paymentMethod = await StripePayment.createPaymentMethod(
        PaymentMethodRequest(card: card),
      );
      final resp = await _realizarPago(
        amount: amount,
        currency: currency,
        paymentMethod: paymentMethod,
      );
      return resp;
    } catch (e) {
      return StripeCustomResponse(
        ok: false,
        msg: e.toString(),
      );
    }
  }

  Future<StripeCustomResponse> pagarConNuevaTarjeta({required String amount, required String currency}) async {
    try {
      final paymentMethod = await StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest());
      final resp = await _realizarPago(
        amount: amount,
        currency: currency,
        paymentMethod: paymentMethod,
      );
      return resp;
    } catch (e) {
      return StripeCustomResponse(
        ok: false,
        msg: e.toString(),
      );
    }
  }

  Future<StripeCustomResponse> pagarConAppleAndGooglePay({
    required String amount,
    required String currency,
  }) async {
    //
    try {
      final newAmount = double.parse(amount) / 100;
      final token = await StripePayment.paymentRequestWithNativePay(
        androidPayOptions: AndroidPayPaymentRequest(
          currencyCode: currency,
          totalPrice: amount,
        ),
        applePayOptions: ApplePayPaymentOptions(currencyCode: currency, countryCode: 'ES', items: [
          ApplePayItem(
            amount: '$newAmount',
            label: 'Producto chulo',
          )
        ]),
      );

      final paymentMethod = await StripePayment.createPaymentMethod(PaymentMethodRequest(
        card: CreditCard(token: token.tokenId),
      ));

      final resp = await _realizarPago(
        amount: amount,
        currency: currency,
        paymentMethod: paymentMethod,
      );

      await StripePayment.completeNativePayRequest();

      return resp;
      //
    } catch (e) {
      print('Error en el intento: ${e.toString()}');
      return StripeCustomResponse(ok: false, msg: e.toString());
    }
  }

  Future<PaymentIntentResponse> _crearPaymentIntent({required String amount, required String currency}) async {
    try {
      final dio = Dio();
      final data = {
        'amount': amount,
        'currency': currency,
      };
      final resp = await dio.post(
        _paymentApiUrl,
        data: data,
        options: headerOptions,
      );
      return PaymentIntentResponse.fromJson(resp.data);
    } catch (e) {
      print('Error en el intento: ${e.toString()}');
      return PaymentIntentResponse(status: '400');
    }
  }

  Future<StripeCustomResponse> _realizarPago({required String amount, required String currency, required PaymentMethod paymentMethod}) async {
    try {
      // CREAR EL INTENT
      final paymentIntent = await _crearPaymentIntent(
        amount: amount,
        currency: currency,
      );
      final paymentResult = await StripePayment.confirmPaymentIntent(PaymentIntent(
        clientSecret: paymentIntent.clientSecret,
        paymentMethodId: paymentMethod.id,
      ));
      if (paymentResult.status == 'succeeded') {
        return StripeCustomResponse(ok: true);
      } else {
        return StripeCustomResponse(ok: false, msg: 'Fallo: ${paymentResult.status}');
      }
    } catch (e) {
      print(e.toString());
      return StripeCustomResponse(ok: false, msg: e.toString());
    }
  }
}
