import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sorted/common/widgets/about_section.dart';
import 'package:sorted/common/widgets/snack_bar.dart';
import 'package:sorted/constants.dart';
import 'package:sorted/models/bubble_sort.dart';
import 'package:sorted/models/insertion_sort.dart';
import 'package:sorted/models/merge_sort.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controller = TextEditingController();
  final FocusNode f1 = FocusNode();
  String _popupMenuTitle = 'Select Algorithm';
  String selectedAlgorithm = '';
  String result = '';
  String time = '';
  List<dynamic> floatNumbers = [];
  List<String> listNumbers = [];
  bool isSnackbar = false;

  @override
  void dispose() {
    controller.dispose();
    f1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width.toInt();
    final height = MediaQuery.of(context).size.height.toInt();
    Orientation orientation = MediaQuery.of(context).orientation;
    final double fontSize;
    if (width >= 1100) {
      fontSize = 24;
    } else if (width >= 800 && width < 1100) {
      fontSize = 22;
    } else if (width >= 600 && width < 800) {
      fontSize = 18;
    } else {
      fontSize = 15;
    }

    return Scaffold(
      appBar: Platform.isAndroid || Platform.isIOS
          ? AppBar(
              title: const Text('Sorted'),
              actions: const [AboutSection()],
            )
          : const YaruWindowTitleBar(
              title: Text('Sorted'),
              leading: AboutSection(),
            ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 40,
                  right: 40,
                  top: 20,
                  bottom: 20,
                ),
                child: TextField(
                  focusNode: f1,
                  autofocus: true,
                  controller: controller,
                  decoration: InputDecoration(
                    suffixIcon: YaruIconButton(
                      icon: const Icon(YaruIcons.edit_clear),
                      tooltip: 'Clear',
                      onPressed: () {
                        setState(() {
                          controller.clear();
                          result = '';
                          time = '';
                          _popupMenuTitle = 'Select Algorithm';
                          floatNumbers = [];
                          time = '';
                        });
                      },
                    ),
                    hintText: 'Enter the values to sort, separated by commas',
                    filled: true,
                  ),
                ),
              ),
              TextFieldTapRegion(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 20,
                        bottom: 40,
                      ),
                      child: YaruPopupMenuButton(
                        tooltip: 'Select the Algorithm',
                        enableFeedback: true,
                        child: Text(
                          _popupMenuTitle,
                          style: TextStyle(
                            fontSize: width < 600 ? 13 : fontSize - 5,
                          ),
                        ),
                        itemBuilder: (BuildContext context) {
                          return List.generate(algorithms.length, (index) {
                            return PopupMenuItem<String>(
                              value: algorithms[index],
                              child: Text(
                                algorithms[index],
                                style: TextStyle(
                                    fontSize: width < 600 ? 15 : fontSize - 5),
                              ),
                              onTap: () =>
                                  selectedAlgorithm = algorithms[index],
                            );
                          });
                        },
                        onSelected: (value) {
                          // Update the selected option and trigger a rebuild
                          setState(() {
                            _popupMenuTitle = value;
                          });
                        },
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        String t1 = controller.text;
                        try {
                          if (t1.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              snackBar(
                                'Dataset is empty!!',
                                5,
                                fontSize,
                                width,
                              ),
                            );
                            return;
                          }
                          listNumbers =
                              t1.split(',').map((s) => s.trim()).toList();
                          floatNumbers = listNumbers
                              .map((s) => int.tryParse(s) ?? double.parse(s))
                              .toList();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              snackBar(e.toString(), 5, fontSize, width));
                          return;
                        }
                        if (selectedAlgorithm == '') {
                          ScaffoldMessenger.of(context).showSnackBar(snackBar(
                              'Select an Algorithm', 5, fontSize, width));
                          return;
                        }
                        if (selectedAlgorithm == 'Insertion') {
                          Stopwatch stopwatch = Stopwatch()..start();
                          InsertionSort insertionSort =
                              InsertionSort(floatNumbers);
                          setState(() {
                            result = insertionSort.sort().toString();
                            time = 'Time taken ${stopwatch.elapsed.toString()}';
                          });
                          stopwatch.stop();
                        }
                        if (selectedAlgorithm == 'Bubble') {
                          Stopwatch stopwatch = Stopwatch()..start();
                          BubbleSort bubbleSort = BubbleSort(floatNumbers);
                          setState(() {
                            result = bubbleSort.sort().toString();
                            time = 'Time taken ${stopwatch.elapsed.toString()}';
                          });
                          stopwatch.stop();
                        }
                        if (selectedAlgorithm == 'Merge') {
                          Stopwatch stopwatch = Stopwatch()..start();
                          MergeSort mergeSort = MergeSort(floatNumbers);
                          setState(() {
                            result = mergeSort.sort().toString();
                            time = 'Time taken ${stopwatch.elapsed.toString()}';
                          });
                          stopwatch.stop();
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          Theme.of(context).primaryColor,
                        ),
                        shape: const MaterialStatePropertyAll<
                            RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                        padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(
                          EdgeInsets.only(
                            top: 20,
                            bottom: 20,
                            left: width / 7,
                            right: width / 7,
                          ),
                        ),
                      ),
                      child: Tooltip(
                        message: 'click to sort',
                        child: Text(
                          'Sort',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: fontSize,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: SizedBox(
                        height: (orientation == Orientation.landscape) &&
                                (Platform.isAndroid || Platform.isIOS)
                            ? height - 100
                            : (Platform.isAndroid || Platform.isIOS) &&
                                    (orientation == Orientation.portrait)
                                ? height - 500
                                : height - 350,
                        width: width - 50,
                        child: Stack(
                          children: [
                            YaruBanner(
                              child: Column(
                                children: [
                                  Flexible(
                                    child: SingleChildScrollView(
                                      child: SelectableText(
                                        result,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: SelectionArea(
                                      child: SelectableText(
                                        time,
                                        style: TextStyle(
                                          fontSize: fontSize,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 10, // Adjust the top position as needed
                              right: 10, // Adjust the right position as needed
                              child: YaruIconButton(
                                tooltip: 'Copy the result',
                                icon: Icon(
                                  isSnackbar
                                      ? YaruIcons.copy_filled
                                      : YaruIcons.copy,
                                  size: fontSize + 5,
                                ),
                                onPressed: () async {
                                  result.isNotEmpty
                                      ? await Clipboard.setData(ClipboardData(
                                          text: result.toString()))
                                      : null;
                                  setState(() {
                                    isSnackbar = !isSnackbar;
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                          snackBar(
                                            result.isNotEmpty
                                                ? 'Copied to clipboard'
                                                : 'Nothing to copy',
                                            5,
                                            fontSize,
                                            width,
                                          ),
                                        )
                                        .closed
                                        .then((value) {
                                      setState(() {
                                        isSnackbar = !isSnackbar;
                                      });
                                    });
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
