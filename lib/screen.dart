// ignore_for_file: unnecessary_null_comparison, non_constant_identifier_names
import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_barometer/flutter_barometer.dart';

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  List<double> pressureData = [];
  double bottomPressure = 0.0;
  double surfacePressure = 0.0;

  Future<void> MeasureSurfacePressure() async {
    await for (final event in flutterBarometerEvents) {
      if (event.pressure != null) {
        setState(() {
          surfacePressure = event.pressure;
        });
        pressureData.add(surfacePressure);
        break;
      }
    }
  }

  Future<void> MeasureBottomPressure() async {
    await for (final event in flutterBarometerEvents) {
      if (event.pressure != null) {
        setState(() {
          bottomPressure = event.pressure;
        });
        pressureData.add(bottomPressure);
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barometer Example'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const SizedBox(height: 16),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 160,
                          height: 50,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) => const Color.fromARGB(
                                        255, 47, 129, 224))),
                            onPressed: MeasureSurfacePressure,
                            child: const Text(
                              'Measure Surface Pressure',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.home,
                          size: 140,
                        ),
                        SizedBox(
                          width: 160,
                          height: 50,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) => const Color.fromARGB(
                                        255, 47, 129, 224))),
                            onPressed: MeasureBottomPressure,
                            child: const Text(
                              'Measure Bottom Pressure',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const VerticalDivider(
                      thickness: 4,
                      color: Colors.black,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 160,
                          height: 50,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) => const Color.fromARGB(
                                        255, 47, 129, 224))),
                            onPressed: () => calculateHeight(context),
                            child: const Text(
                              'Calculate Building Height',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        surfacePressure != 0.0
                            ? Text(
                                'Surface pressure: \n ${surfacePressure.toStringAsFixed(10)}')
                            : const Text('Surface pressure: \n 0'),
                        bottomPressure != 0.0
                            ? Text(
                                'Bottom pressure: \n ${bottomPressure.toStringAsFixed(10)}')
                            : const Text('Bottom pressure: \n 0'),
                        SizedBox(
                          width: 160,
                          height: 50,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateColor.resolveWith(
                                    (states) => const Color.fromARGB(
                                        255, 47, 129, 224))),
                            onPressed: _comparePress,
                            child: const Text(
                              'Compare Bottom Pressure',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: SizedBox(
                width: 160,
                height: 50,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => const Color.fromARGB(255, 47, 129, 224))),
                  onPressed: () => ShowOutliers(context),
                  child: const Text(
                    'Show Outliers',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void calculateHeight(BuildContext context) {
    if (pressureData.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: const Text(
            'No pressure data available',
            style: TextStyle(
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }
    double T = 273.15; // Absolute temperature in Kelvin
    double L = 0.0065; // Temperature lapse rate in K/m
    double P = 1013.25; // Pressure at sea level in hPa
    double surfaceHeight = surfacePressure == 0.0
        ? 0.0
        : (((T + 37) / L) * log(P / surfacePressure));
    double bottomHeight = bottomPressure == 0.0
        ? 0.0
        : (((T + 37) / L) * log(P / bottomPressure));
    print('Surface Height: ${surfaceHeight.toString()}');
    print('Bottom Height: ${bottomHeight.toString()}');

    double height = ((surfaceHeight - bottomHeight).abs());
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(
          'Building height is \n ${height.toStringAsFixed(4)} meters\n\n',
          style: const TextStyle(
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void ShowOutliers(BuildContext context) {
    if (pressureData.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: const Text(
            'No pressure data available',
            style: TextStyle(
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

// Remove outliers from pressureData
    List<double> pressureDataBeforeRemoveOutliers = List.from(pressureData);
    List<double> pressureDataAfterRemoveOutliers = List.from(pressureData);
    print(
        'Pressure Data Before Remove outliers : $pressureDataBeforeRemoveOutliers');
    const double outlierThreshold = 1013.25; // Adjust this threshold as needed
    final double mean =
        pressureData.reduce((a, b) => a + b) / pressureData.length;
    final double standardDeviation = sqrt(
        pressureData.map((x) => pow(x - mean, 2)).reduce((a, b) => a + b) /
            pressureData.length);
    pressureDataAfterRemoveOutliers.removeWhere(
        (x) => (x - mean).abs() > outlierThreshold * standardDeviation);

    print(
        'Pressure Data After Remove outliers : $pressureDataAfterRemoveOutliers');

    if (pressureDataBeforeRemoveOutliers.length.toDouble() ==
        pressureDataAfterRemoveOutliers.length.toDouble()) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: const Text(
            'There Are No pressure data outliers',
            style: TextStyle(
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(
          'Number of Pressure Data Before Remove outliers : ${pressureDataBeforeRemoveOutliers.length.toDouble()}\n'
          'Pressure Data Before Remove outliers \n $pressureDataBeforeRemoveOutliers \n\n'
          'Number of Pressure Data After Remove outliers : ${pressureDataAfterRemoveOutliers.length.toDouble()}\n'
          'Pressure Data After Remove outliers \n $pressureDataAfterRemoveOutliers \n\n',
          style: const TextStyle(
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _comparePress() {
    const double fciPress = 1008.5; // replace with actual value

    String message;
    message = bottomPressure > fciPress
        ? 'FCAI building has lower Pressure'
        : bottomPressure < fciPress
            ? 'FCAI building has higher Pressure'
            : 'Both buildings have the same Pressure';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
