import 'package:cbfapp/services/Qrcode_service.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'QRScannerOverlayPainter.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen>
    with SingleTickerProviderStateMixin {
  String? scannedCode;
  bool isFlashOn = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  final MobileScannerController cameraController = MobileScannerController();
  final QrCheckinService qrcodeService = QrCheckinService();

  @override
  void initState() {
    super.initState();
    _animationController =
    AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);

    _animation =
        Tween<double>(begin: 0.1, end: 0.9).animate(CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
        ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    cameraController.dispose();
    super.dispose();
  }

  void toggleFlash() async {
    await cameraController.toggleTorch();
    setState(() {
      isFlashOn = !isFlashOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan QR Code")),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (BarcodeCapture capture) async {
              final barcode = capture.barcodes.first;

              if (scannedCode == null) {
                final raw = barcode.rawValue;

                if (raw != null && raw.contains("CARISCA:")) {
                  final type = raw.split(":").last.trim();
                  setState(() => scannedCode = type);
                  SharedPreferences pref = await SharedPreferences.getInstance();
                  final userId = pref.getInt("userId");
                  final response = await qrcodeService.checkinUserByQr(
                    userId: userId!,
                    checkinType: type,
                  );

                  await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(response.status),
                      content: Text(response.message),
                      backgroundColor: response.status == "Success" ? Colors.green[100] : Colors.red[100],
                      titleTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: response.status == "Success" ? Colors.green[900] : Colors.red[900],
                        fontSize: 18,
                      ),
                      contentTextStyle: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                      actions: [
                        TextButton(
                          child: const Text("OK"),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        TextButton(
                          child: const Text("Home"),
                          onPressed: () => Navigator.pushNamed(context, "/dashboard"),
                        ),
                      ],
                    ),
                  );

                  await Future.delayed(const Duration(seconds: 3));
                  setState(() => scannedCode = null);
                } else {
                  await showDialog(
                    context: context,
                    builder: (context) => const AlertDialog(
                      title: Text("Invalid QR"),
                      content: Text("Invalid QR format"),
                      actions: [
                        TextButton(
                          child: Text("OK"),
                          onPressed: null,
                        ),
                      ],
                    ),
                  );
                }
              }
            },
          ),


          _buildScannerOverlay(),
          if (scannedCode != null)
            Positioned(
              bottom: 80,
              left: 20,
              right: 20,
              child: Center(
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Checkin Type: $scannedCode',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: IconButton(
              icon: Icon(
                isFlashOn ? Icons.flash_on : Icons.flash_off,
                color: Colors.white,
                size: 32,
              ),
              onPressed: toggleFlash,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerOverlay() {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth * 0.7;
      final height = constraints.maxHeight * 0.4;

      return Center(
        child: SizedBox(
          width: width,
          height: height,
          child: Stack(
            children: [
              CustomPaint(
                painter: QRScannerOverlayPainter(),
                child: const SizedBox.expand(),
              ),
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Positioned(
                    top: _animation.value * height,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      color: Colors.white.withOpacity(0.8),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
