import 'package:flutter/material.dart';

class TarjetaCredito {
  final String cardNumberHidden;
  final String cardNumber;
  final String brand;
  final String cvv;
  final String expiracyDate;
  final String cardHolderName;
  final Color cardColor;

  TarjetaCredito({
    required this.cardNumberHidden,
    required this.cardNumber,
    required this.brand,
    required this.cvv,
    required this.expiracyDate,
    required this.cardHolderName,
    required this.cardColor,
  });
}
