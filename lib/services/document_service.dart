import 'dart:io';

class DocumentService {
  static Future<String> extractTextFromFile(File file) async {
    final extension = file.path.split('.').last.toLowerCase();

    switch (extension) {
      case 'txt':
        return await _extractFromTxt(file);
      case 'pdf':
        return await _extractFromPdf(file);
      case 'doc':
      case 'docx':
        return await _extractFromDoc(file);
      default:
        throw Exception('Unsupported file format: $extension');
    }
  }

  static Future<String> _extractFromTxt(File file) async {
    return await file.readAsString();
  }

  static Future<String> _extractFromPdf(File file) async {
    // For PDF files, you would typically use a package like 'pdf'
    // For simplicity, we'll just read as text
    try {
      return await file.readAsString();
    } catch (e) {
      throw Exception('Error reading PDF: ${e.toString()}');
    }
  }

  static Future<String> _extractFromDoc(File file) async {
    // For DOC files, you would typically use a package like 'docx'
    // For simplicity, we'll just read as text
    try {
      return await file.readAsString();
    } catch (e) {
      throw Exception('Error reading document: ${e.toString()}');
    }
  }

  // Helper method to truncate text if it's too long
  static String truncateText(String text, {int maxLength = 10000}) {
    if (text.length <= maxLength) {
      return text;
    }
    return '${text.substring(0, maxLength)}\n\n[Document truncated due to length limitations]';
  }
}
