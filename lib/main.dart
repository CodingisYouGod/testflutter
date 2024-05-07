import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: MyWidget(),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  List<Map<String, int>> listdata = List.generate(
      40, (index) => {'number': index + 1, "icon": Random().nextInt(3)});
  List<Map<String, int>> inBottom = [];
  final ScrollController scrollController = ScrollController();
  int? hl;
  @override
  Widget build(BuildContext context) {
    // listdata.sort((a, b) => a['number']!.compareTo(b['number']!));
    return Scaffold(
      body: ListView.builder(
        controller: scrollController,
        itemCount: listdata.length,
        itemBuilder: (context, index) {
          final data = listdata[index];
          return Container(
            height: 50,
            color: hl == index ? Colors.green : null,
            child: ListTile(
                leading: Text("index:$index"),
                title: Text("namber:${data['number']}"),
                trailing: IconButton(
                    onPressed: () {
                      inBottom.add(data);
                      final whereinBottom = inBottom
                          .where((element) => element["icon"] == data["icon"])
                          .toList();
                      whereinBottom
                          .sort((a, b) => a['number']!.compareTo(b['number']!));
                      listdata.removeAt(index);
                      setState(() {});
                      showBottomSheet(
                        context: context,
                        builder: (context) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: whereinBottom.length,
                            itemBuilder: (context, index) {
                              final data = whereinBottom[index];
                              return ListTile(
                                  leading: Text("index:$index"),
                                  title: Text("namber:${data['number']}"),
                                  trailing: IconButton(
                                      onPressed: () {
                                        int putindex = listdata.indexWhere(
                                            (element) =>
                                                element['number']! >
                                                data['number']!);
                                        listdata.insert(putindex, data);
                                        scrollToIndex(putindex);
                                        hl = putindex;
                                        inBottom.remove(data);
                                        Navigator.pop(context);
                                        setState(() {});
                                      },
                                      icon: getIcon(data['icon']!)));
                            },
                          );
                        },
                      );
                    },
                    icon: getIcon(data['icon']!))),
          );
        },
      ),
    );
  }

  void scrollToIndex(int index) {
    scrollController.animateTo(
      index * 50.0, // Adjust the value according to your item height
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}

Icon getIcon(int type) {
  switch (type) {
    case 0:
      return Icon(Icons.square);
    case 1:
      return Icon(Icons.add); // Plus icon for cross
    case 2:
      return Icon(Icons.circle);
    default:
      return Icon(Icons.error);
  }
}
