mixin AssetParse {
  String imageParse(String data) {
    return data.replaceAll('assets/images/', '');
  }
}
