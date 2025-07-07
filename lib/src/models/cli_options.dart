/// A data class for command-line options.
class CliOptions {
  final String? token;
  final String? path;
  final bool isRelease;
  final String provider;

  CliOptions({
    this.token,
    this.path,
    this.isRelease = true,
    this.provider = 'diawi',
  });
}
