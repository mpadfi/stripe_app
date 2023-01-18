part of 'pagar_bloc.dart';

@immutable
class PagarState {
  final double cantidadPagar;
  final String moneda;
  final bool tarjetaActiva;
  final TarjetaCredito? tarjeta;

  String get cantidadPagarString => '${(cantidadPagar * 100).floor()}';

  const PagarState({
    this.cantidadPagar = 350.00,
    this.moneda = 'EUR',
    this.tarjetaActiva = false,
    this.tarjeta,
  });

  PagarState copyWith({
    double? cantidadPagar,
    String? moneda,
    bool? tarjetaActiva,
    TarjetaCredito? tarjeta,
  }) =>
      PagarState(
        cantidadPagar: cantidadPagar ?? this.cantidadPagar,
        moneda: moneda ?? this.moneda,
        tarjetaActiva: tarjetaActiva ?? this.tarjetaActiva,
        tarjeta: tarjeta ?? this.tarjeta,
      );
}
