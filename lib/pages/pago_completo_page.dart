import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PagoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pago Realizado')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(FontAwesomeIcons.handsClapping, color: Colors.white, size: 100),
            SizedBox(height: 20),
            Text('Pago realizado correctamente', style: TextStyle(color: Colors.white, fontSize: 22)),
          ],
        ),
      ),
    );
  }
}
