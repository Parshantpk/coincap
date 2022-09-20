import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final Map rates;

  const DetailsPage({super.key, required this.rates});

  @override
  Widget build(BuildContext context) {
    List currencies = rates.keys.toList();
    List exchangeRates = rates.values.toList();
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          shrinkWrap: true,
            itemCount: currencies.length,
            itemBuilder: (context, index) {
              String currency = currencies[index].toString().toUpperCase();
              String exchangeRate = exchangeRates[index].toString();
              return ListTile(
                title: Text(
                  '$currency: $exchangeRate',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.arrow_back,
          color: Color.fromRGBO(83, 88, 206, 1.0),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
