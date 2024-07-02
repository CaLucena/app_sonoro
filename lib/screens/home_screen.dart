import 'dart:async';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:app_sonoro/services/decibel_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DecibelService _decibelService = DecibelService();
  List<dynamic>? _decibelData;
  bool _isLoading = true;
  String _errorMessage = '';
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _fetchDecibelData();
    _startAutoRefresh();
  }

  Future<void> _fetchDecibelData() async {
    try {
      final data = await _decibelService.getDados();
      setState(() {
        _decibelData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Falha ao carregar dados';
        _isLoading = false;
      });
    }
  }

  void _startAutoRefresh() {
    Timer.periodic(Duration(minutes: 5), (timer) {
      _fetchDecibelData();
    });
  }

  List<charts.Series<dynamic, DateTime>> _createSeriesData() {
    return [
      charts.Series<dynamic, DateTime>(
        id: 'Decibéis',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (dynamic decibel, _) => DateTime.parse(decibel['datahora']),
        measureFn: (dynamic decibel, _) => double.parse(decibel['decibeis']),
        data: _filteredData(),
      )
    ];
  }

  List<dynamic> _filteredData() {
    if (_startDate == null || _endDate == null) return _decibelData ?? [];
    return _decibelData!.where((item) {
      DateTime date = DateTime.parse(item['datahora']);
      return date.isAfter(_startDate!) && date.isBefore(_endDate!);
    }).toList();
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dados de Decibéis'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.blueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: _fetchDecibelData,
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.blue,
                ),
                child: Text('Atualizar Dados'),
              ),
              ElevatedButton(
                onPressed: () => _selectDateRange(context),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.blue,
                ),
                child: Text('Selecionar Intervalo de Datas'),
              ),
              SizedBox(height: 10),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _decibelData != null
                  ? Expanded(
                child: charts.TimeSeriesChart(
                  _createSeriesData(),
                  animate: true,
                  dateTimeFactory: const charts.LocalDateTimeFactory(),
                ),
              )
                  : Center(child: Text(_errorMessage)),
              if (!_isLoading && _decibelData != null)
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredData().take(10).length, // Limita a 10 itens
                    itemBuilder: (context, index) {
                      var item = _filteredData()[index];
                      return Card(
                        elevation: 5,
                        child: ListTile(
                          leading: Icon(
                            Icons.hearing, // Adicionando um ícone relevante
                            color: Colors.blue,
                          ),
                          title: Text(
                            'Decibéis: ${item['decibeis']}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Data: ${item['datahora']}'),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
