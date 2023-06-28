import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../models/data.dart';

class Scanner extends StatefulWidget {
  const Scanner({super.key});

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Scanner'),
          centerTitle: true,
        ),
        body: Stack(
          children: <Widget>[
            _buildQrView(context),
            Positioned(
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  height: 100,
                  color: Colors.grey.shade900.withOpacity(0.4),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await controller!.flipCamera();
                        },
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey.shade300,
                          child: const Icon(
                            Icons.flip_camera_ios,
                            size: 30,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await controller!.toggleFlash();
                          // model.toggleFlash(await controller!.getFlashStatus());
                        },
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey.shade300,
                          child: Icon(
                            Icons.flash_on,
                            size: 30,
                          ),
                        ),
                      )
                    ],
                  ),
                ))
          ],
        ));
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 400.0;

    return QRView(
      key: qrKey,
      onQRViewCreated: (ctr) => _onQRViewCreated(ctr, context),
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
      Navigator.pop(context);
    }
  }

  void _onQRViewCreated(QRViewController controller, BuildContext context) {
    this.controller = controller;
    controller.scannedDataStream.first.then((scanData) async {
      print("test");
      print(scanData.code);

      var box = await Hive.openBox('product');

      await box.put("products", [...box.get('products'), scanData.code!]);

      Navigator.pop(context);
    });
  }
}
