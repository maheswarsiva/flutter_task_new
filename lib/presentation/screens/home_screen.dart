// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_task_new/presentation/screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../presentation/providers/auth_provider.dart';
import '../../presentation/providers/file_provider.dart';
import 'preview_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final fileProv = Provider.of<FileProvider>(context, listen: false);
    fileProv.fetchFiles();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final fileProv = Provider.of<FileProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await auth.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (fileProv.uploadProgress > 0)
              LinearProgressIndicator(value: fileProv.uploadProgress),
            Expanded(
              child: fileProv.loading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: fileProv.files.length,
                      itemBuilder: (c, i) {
                        final f = fileProv.files[i];
                        return Card(
                          child: ListTile(
                            title: Text(f.name),
                            subtitle: Text('${f.contentType} • ${f.size} bytes'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
  icon: Icon(Icons.visibility),
  onPressed: () async {
    try {
      // Show a loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Center(child: CircularProgressIndicator()),
      );

      // Download the full image
      final fullBytes = await fileProv.download(f.url);

      // Close the loader
      Navigator.of(context).pop();

      // Navigate to PreviewScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PreviewScreen(
            title: f.name,
            bytes: fullBytes,
            fileUrl: f.url,
          ),
        ),
      );
    } catch (e) {
      Navigator.of(context).pop(); // Ensure loader is removed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preview failed: $e')),
      );
    }
  },
),

                                IconButton(
                                  icon: Icon(Icons.download),
                                  onPressed: () async {
                                    try {
                                      final bytes = await fileProv.download(f.url);
                                      downloadToDownloads(f.url, f.name);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Downloaded ${bytes.length} bytes',
                                          ),
                                        ),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Download failed: \$e'),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.upload_file),
        onPressed: () async {
          final result = await FilePicker.platform.pickFiles(withData: true);
          if (result != null && result.files.isNotEmpty) {
            final file = result.files.first;
            final bytes = file.bytes!;
            final filename = file.name;
            final contentType = (file.extension ?? '').toLowerCase() == 'pdf'
                ? 'application/pdf'
                : 'image/jpeg';
            final fileProv = Provider.of<FileProvider>(context, listen: false);
            try {
              await fileProv.upload(bytes, filename, contentType);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Upload completed')));
            } catch (e) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Upload failed: \$e')));
            }
          }
        },
      ),
    );
  }

  Future<String> downloadToDownloads(String url, String filename) async {
    // Request permission (handle Android 11+ properly)
    if (Platform.isAndroid) {
      if (await Permission.manageExternalStorage.request().isGranted ||
          await Permission.storage.request().isGranted) {
        debugPrint("Storage permission granted");
      } else {
        throw Exception("Storage permission denied");
      }
    }

    // Get the downloads directory
    Directory? downloadsDir;
    if (Platform.isAndroid) {
      downloadsDir = Directory('/storage/emulated/0/Download');
      // ⚠️ Works on many devices, but not future-proof
    } else {
      downloadsDir = await getDownloadsDirectory(); // iOS/macOS
    }

    if (downloadsDir == null) {
      throw Exception("Unable to access downloads directory");
    }

    // Download the file
    final response = await http.get(Uri.parse(url));
    final file = File('${downloadsDir.path}/$filename');
    await file.writeAsBytes(response.bodyBytes);

    return file.path;
  }
}
