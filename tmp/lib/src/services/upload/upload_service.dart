/// An abstract class that defines the interface for an upload service.
abstract class UploadService {
  /// Uploads a file to a remote service.
  ///
  /// Returns a [Future] that completes with the download URL of the uploaded
  /// file.
  Future<String> upload(String filePath);
}
