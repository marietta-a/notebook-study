import 'package:notebook_study/models/document_upload.dart';

class DocumentCollection {
  final String ownerId; // For example, the user who owns the collection
  final List<DocumentUpload> documents;

  DocumentCollection({
    required this.ownerId,
    this.documents = const [],
  });

  void addDocument(DocumentUpload document) {
    documents.add(document);
  }

  void removeDocument(DocumentUpload document) {
    documents.remove(document);
  }
}