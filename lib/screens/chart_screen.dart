import 'package:flutter/material.dart';

class ChartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String chartType = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('Gráfico $chartType'),
      ),
      body: Center(
        child: Text('Mostrando gráfico $chartType...'),
      ),
    );
  }
}
