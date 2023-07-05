void main() {
  String str =
      "Hello how are you? Please #click here# and then click on #like button#  ~google.com ~fb.com ~pho.co.in";
  List<String> finalLinks = str.split('~').toList();
  finalLinks.removeAt(0);

  RegExp regex = RegExp(r"#([^#]+)#");

  Iterable<Match> matches = regex.allMatches(str);

  List<String> hashtags = matches.map((match) => match.group(1)!).toList();

  print(finalLinks);
  print(hashtags);
}
