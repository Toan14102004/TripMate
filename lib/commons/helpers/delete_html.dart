String removeHtmlTags(String htmlString) {
  RegExp htmlTagRegExp = RegExp(r"<[^>]*>");
  String cleanString = htmlString.replaceAll(htmlTagRegExp, '');
  return cleanString;
}