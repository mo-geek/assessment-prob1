import 'package:codechallengeone/prob_1.dart';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFile extends Mock implements File {}

void main() {
  test('processes input file and creates output CSV files', () async {
    final csvFile = File('lib/input.csv');
    final inputCsv = csvFile.readAsStringSync();
    final expectedAverageQuantityCsv =
        File('lib/ave_output.csv').readAsStringSync();
    final expectedMostPopularBrandCsv =
        File('lib/brand_output.csv').readAsStringSync();
    final inputFile = MockFile();
    final averageQuantityOutputFile = MockFile();
    final mostPopularBrandOutputFile = MockFile();

    when(() => inputFile.readAsStringSync()).thenReturn(inputCsv);
    when(() => inputFile.existsSync()).thenReturn(true);
    when(() => averageQuantityOutputFile.path)
        .thenReturn('average_quantity.csv');
    when(() => mostPopularBrandOutputFile.path)
        .thenReturn('most_popular_brand.csv');
    when(() => averageQuantityOutputFile
        .writeAsStringSync(expectedAverageQuantityCsv)).thenReturn('');
    when(() => mostPopularBrandOutputFile
        .writeAsStringSync(expectedMostPopularBrandCsv)).thenReturn('');

    await prob1(
        inputFile, averageQuantityOutputFile, mostPopularBrandOutputFile);

    verify(() => inputFile.existsSync()).called(1);
    verify(() => inputFile.readAsStringSync()).called(1);
    verify(() => averageQuantityOutputFile
        .writeAsStringSync(expectedAverageQuantityCsv)).called(1);
    verify(() => mostPopularBrandOutputFile
        .writeAsStringSync(expectedMostPopularBrandCsv)).called(1);
  });
}
