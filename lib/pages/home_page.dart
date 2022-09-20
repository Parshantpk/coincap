import 'dart:convert';

import 'package:coincap/pages/details_page.dart';
import 'package:coincap/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? _deviceHeight, _deviceWidth;
  HttpService? _httpService;
  String coinValue = 'bitcoin';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _httpService = GetIt.instance.get<HttpService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _selectedCoinDropdown(),
            _dataWidget(coinValue),
          ],
        ),
      )),
    );
  }

  Widget _selectedCoinDropdown() {
    List<String> coins = [
      'bitcoin',
      'ethereum',
      'tether',
      'cardano',
      'ripple',
    ];
    List<DropdownMenuItem> items = coins
        .map(
          (String coins) => DropdownMenuItem(
            value: coins,
            child: Text(
              coins,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 40,
              ),
            ),
          ),
        )
        .toList();
    return DropdownButton(
      value: coinValue,
      items: items,
      onChanged: (newCoin) {
        setState(() {
          coinValue = newCoin.toString();
        });
      },
      dropdownColor: const Color.fromRGBO(83, 88, 206, 1.0),
      iconSize: 30,
      icon: const Icon(
        Icons.arrow_drop_down_sharp,
        color: Colors.white,
      ),
      underline: Container(),
    );
  }

  Widget _dataWidget(String coinValue) {
    return FutureBuilder(
      future: _httpService!.get('/coins/$coinValue'),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Map data = jsonDecode(snapshot.data.toString());
          num usdPrice = data['market_data']['current_price']['usd'];
          num change24h = data['market_data']['price_change_percentage_24h'];
          String imgUrl = data['image']['large'];
          String description = data['description']['en'];
          Map rates = data['market_data']['current_price'];
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _coinImageWidget(imgUrl, rates),
              _currentPriceWidget(usdPrice),
              _percentageChangeWidget(change24h),
              _descriptionCardWidget(description),
            ],
          );
        } else {
          return const CircularProgressIndicator(
            color: Colors.white,
          );
        }
      },
    );
  }

  Widget _currentPriceWidget(num rate) {
    return Text(
      '${rate.toStringAsFixed(2)} USD',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _percentageChangeWidget(num change) {
    return Text(
      '${change.toString()} %',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget _coinImageWidget(String imgUrl, Map rates) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return DetailsPage(rates: rates);
            },
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: _deviceHeight! * 0.02,
        ),
        height: _deviceHeight! * 0.15,
        width: _deviceWidth! * 0.15,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(imgUrl),
          ),
        ),
      ),
    );
  }

  Widget _descriptionCardWidget(String description) {
    return Container(
      height: _deviceHeight! * 0.45,
      width: _deviceWidth! * 0.90,
      margin: EdgeInsets.symmetric(
        vertical: _deviceHeight! * 0.05,
      ),
      padding: EdgeInsets.symmetric(
        vertical: _deviceHeight! * 0.01,
        horizontal: _deviceHeight! * 0.01,
      ),
      color: const Color.fromRGBO(83, 88, 206, 0.5),
      child: Text(
        description,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
