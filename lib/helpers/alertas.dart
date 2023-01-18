part of 'helpers.dart';

mostrarLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const CupertinoAlertDialog(
      title: Text('Espere...'),
      content: CupertinoActivityIndicator(),
    ),
  );
}

mostrarAlerta(BuildContext context, String titulo, String mensaje) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => CupertinoAlertDialog(
      title: Text(titulo),
      content: Text(mensaje),
      actions: [
        MaterialButton(
          child: const Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    ),
  );
}
