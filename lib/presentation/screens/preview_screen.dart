// ignore_for_file: must_be_immutable

import 'dart:typed_data';
import 'package:flutter/material.dart';

class PreviewScreen extends StatelessWidget {
  final Uint8List bytes;
  final String title;
  String fileUrl;
  PreviewScreen({super.key,required this.fileUrl ,required this.bytes, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Preview - \$title')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Pinch to zoom", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: InteractiveViewer(
                child: Image.memory(
                  bytes,
                  gaplessPlayback: true,
                  filterQuality: FilterQuality.high,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}