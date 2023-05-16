import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';

Future<void> prob1(File inputFile, File averageQuantityOutputFile,
    File mostPopularBrandOutputFile) async {
  if (inputFile.existsSync()) {
    final inputCsv = inputFile.readAsStringSync();
    debugPrint("inputCSV: $inputCsv");
    final List<List<dynamic>> inputList =
        const CsvToListConverter().convert(inputCsv);
    debugPrint("inputList: $inputList");
    final quantityMap = <String, List<int>>{};
    final brandMap = <String, Map<String, int>>{};

    for (final row in inputList) {
      final productName = row[2] as String;
      final productQuantity =
          row[3].runtimeType == int ? row[3] : int.parse(row[3]);
      final productBrand = row[4] as String;
      if (quantityMap.containsKey(productName)) {
        quantityMap[productName]!.add(productQuantity);
      } else {
        quantityMap[productName] = [productQuantity];
      }

      if (brandMap.containsKey(productName)) {
        if (brandMap[productName]!.containsKey(productBrand)) {
          brandMap[productName]![productBrand] =
              brandMap[productName]![productBrand] == null
                  ? 1
                  : brandMap[productName]![productBrand]! + 1;
        } else {
          brandMap[productName]![productBrand] = 1;
        }
      } else {
        brandMap[productName] = {productBrand: 1};
      }
    }

    final averageQuantityCsv = [
      ['Product Name', 'Average Quantity']
    ];
    final mostPopularBrandCsv = [
      ['Product Name', 'Most Popular Brand']
    ];

    for (final productName in quantityMap.keys) {
      final quantities = quantityMap[productName]!;
      final averageQuantity =
          quantities.reduce((a, b) => a + b) / quantities.length;

      averageQuantityCsv.add([productName, averageQuantity.toStringAsFixed(3)]);

      final brands = brandMap[productName]!;
      var mostPopularBrand = brands.keys.first;
      for (final brandName in brands.keys) {
        if (brands[brandName]! > brands[mostPopularBrand]!) {
          mostPopularBrand = brandName;
        }
      }
      mostPopularBrandCsv.add([productName, mostPopularBrand]);
    }
    debugPrint('result');
    debugPrint(const ListToCsvConverter().convert(averageQuantityCsv));
    debugPrint(const ListToCsvConverter().convert(mostPopularBrandCsv));

    averageQuantityOutputFile.writeAsStringSync(
        const ListToCsvConverter().convert(averageQuantityCsv));
    mostPopularBrandOutputFile.writeAsStringSync(
        const ListToCsvConverter().convert(mostPopularBrandCsv));
  } else {
    debugPrint('this file does not exist');
  }
}
