import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:notebook_study/core/configuration.dart';
import 'package:notebook_study/models/document_collection.dart';
import 'package:notebook_study/models/document_upload.dart';
import 'package:notebook_study/screens/controls/dropdown.dart';
import 'package:notebook_study/services/base_service.dart';
import 'package:notebook_study/services/category_service.dart';
import 'package:notebook_study/services/document_upload_service.dart';
import 'package:provider/provider.dart';

class DocumentUploadScreen extends StatefulWidget {
  @override
  _DocumentUploadScreenState createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {

  final DocumentCollection _documentCollection = DocumentCollection(ownerId: BaseService.currentUser!.uid);
  DocumentUploadService _service = DocumentUploadService();
  bool _isUploading = false;
  late String docName = "";
  late FilePickerResult? filePickerResult;
  final ValueNotifier<String> fileNameNotifier = ValueNotifier("");

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose(){
    fileNameNotifier.dispose();
    super.dispose();
  }

  Future<void> pickFile() async {
    // Let user pick a file
    filePickerResult = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions, // Supported types
    );
    fileNameNotifier.value = filePickerResult!.files.single.name;
  }

  Future<void> uploadFile() async {
    if (filePickerResult != null) {
      try {
        setState(() => _isUploading = true);

        // Use bytes for web, or path for other platforms
        final bytes = filePickerResult!.files.single.bytes;
        final fileName = filePickerResult!.files.single.name;
        docName = fileName;
        final fileSize = filePickerResult!.files.single.size; // Size in bytes
        final fileType = filePickerResult!.files.single.extension ?? 'unknown';

        // Upload the file to Firebase Storage
        TaskSnapshot snapshot;
        if (bytes != null) {
          snapshot = await _service.uploadDocumentFromBytes(bytes, fileName);
        } else {
          final filePath = filePickerResult!.files.single.path!;
          snapshot = await _service.uploadDocument(File(filePath), fileName);
        }

        String downloadURL = await snapshot.ref.getDownloadURL();

        // Create an UploadedDocument object
        DocumentUpload document = DocumentUpload(
          name: fileName,
          url: downloadURL,
          type: fileType,
          size: fileSize,
          user: _service.getUserProfile(),
        );

        // Save the document details to the database
        await _service.addDocument(document);

        // Add the document to the collection
        setState(() {
          _documentCollection.addDocument(document);
          _isUploading = false;
        });

        // Success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload successful!')),
        );
      } catch (e) {
        setState(() => _isUploading = false);

        print(e);

        // Error handling
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload: $e')),
        );
      }
    } else {
      // User canceled file picking
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No file selected')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(title: Text('Upload Documents')),

      body: Center(
        child: _isUploading
            ? CircularProgressIndicator()
            : Consumer<CategoryService>(
              builder: (context, service, child){
               return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if(service.categories.isNotEmpty)
                    DropdownScreen(
                      title: "Select Category",
                      items: service.categories.map((item) => item.description).toList(), 
                      valueSelected: (value){
                          return; 
                      },
                    ),
                   Align(
                      alignment: Alignment.centerLeft,
                      child: ValueListenableBuilder<String>(
                          valueListenable: fileNameNotifier, 
                          builder: (context,value, Widget? child) { 
                              // return Text("file: $value");
                              return Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: pickFile,
                                    child: const Text("Pick a file"),
                                  ),
                                  if(value.isNotEmpty)
                                   Text(value)
                                ],
                              );
                          },
                      )   // 
                    ),
                    if (_documentCollection.documents.isNotEmpty)
                      Expanded(
                        child: ListView.builder(
                          itemCount: _documentCollection.documents.length,
                          itemBuilder: (context, index) {
                            final doc = _documentCollection.documents[index];
                            return ListTile(
                              title: Text(doc.name),
                              subtitle: Text(
                                  'Type: ${doc.type}, Size: ${doc.size} bytes'),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    _documentCollection.removeDocument(doc);
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                );
              } ,
            )
      ),

      floatingActionButton: ElevatedButton(
        onPressed: uploadFile, 
        child: const Text("Upload Document")
        ),
    
    );
  }
}