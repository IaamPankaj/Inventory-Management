import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:im/Screens/scanner.dart';
import 'package:im/models/data.dart';
import 'package:im/widget/bottom_sheet.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<QRRequest> list = [];
  @override
  void initState() {
    super.initState();
    getList();
  }

  getList() async {
    var box = await Hive.openBox('product');

    // final body = json.decode(scanData.code!);
    if (box.get('products') == null) {
      await box.put('products', []);
    }

    final data = box.get('products');

    List<QRRequest> _list = [];
    data.forEach((e) {
      final body = json.decode(e);

      _list.add(QRRequest(
          productId: body['productId'],
          productName: body['productName'],
          status: false,
          createdAt: ""));
    });

    setState(() {
      list = _list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f6fb),
      body: Padding(
          padding: EdgeInsets.only(top: 20),
          child: ListView.builder(
            itemBuilder: (context, i) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: ListTile(
                  onTap: () {
                    YYBottomSheetDialog(context, bottom(list[i]));
                  },
                  trailing: Icon(
                    list[i].status == true ? Icons.check_circle : Icons.cancel,
                    color: list[i].status == true ? Colors.green : Colors.red,
                    size: 28,
                  ),
                  shape: const RoundedRectangleBorder(
                    side: BorderSide(color: Colors.purpleAccent),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                  title: Text(list[i].productId!),
                  // subtitle: Text(DateFormat('yyyy-MM-dd - hh:mm a')
                  //  .format(DateTime.parse(list[i].createdAt!)),
                ),
              );
              // );
            },
            itemCount: list.length,
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.purple,
          child: const Icon(
            Icons.camera_alt,
            color: Colors.white,
          ),
          onPressed: () async {
            Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Scanner()))
                .then((value) => getList());
          }),
    );
  }

  Widget bottom(QRRequest history) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          bottomTextTile("ProductId", history.productId),
          bottomTextTile("ProductName", history.productName),
          Center(
            child: ElevatedButton(
              onPressed: () {},
              child: Text(
                "Back",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomTextTile(key, value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        '$key: $value',
        textAlign: TextAlign.start,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
