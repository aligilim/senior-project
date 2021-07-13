extension StringExtension on String? {
  String get inCaps =>
      this!.length > 0 ? '${this![0].toUpperCase()}${this!.substring(1)}' : '';
  String capitalize() {
    return this == null
        ? ''
        : this!
            .replaceAll(RegExp(' +'), ' ')
            .split(" ")
            .map((str) => str.inCaps)
            .join(" ");
  }
}
