import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ClickableTextWidget extends StatelessWidget {
  final String text;

  const ClickableTextWidget({required this.text});

  @override
  Widget build(BuildContext context) {
    List<String> finalLinks = text.split('~').toList();
    finalLinks.removeAt(0);

    RegExp regex = RegExp(r"#([^#]+)#");

    Iterable<Match> matches = regex.allMatches(text);

    List<String> hashtags = matches.map((match) => match.group(1)!).toList();

    return RichText(
      text: TextSpan(
        children: _buildTextSpans(hashtags, finalLinks,),
      ),
    );
  }
  

  List<TextSpan> _buildTextSpans(List<String> hashtags, List<String> links) {
    List<TextSpan> textSpans = [];

    List<String> words = text.split(RegExp(r"#[^#]+#|~[^~]+"));

    for (int i = 0; i < words.length; i++) {
      textSpans.add(TextSpan(text: words[i], style: const TextStyle(color:  Color(0xff27374D), fontWeight: FontWeight.w400)));
      if (i < hashtags.length) {
        textSpans.add(
          TextSpan(
            text: hashtags[i],
            style: const TextStyle(
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w600,
            
              color: Color(0xff576CBC),
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                _launchURL(links[i]);
              },
          ),
        );
      }
    }

    

   return textSpans;
    
  }
  

  Future<void> _launchURL(String url) async {
    if (!url.startsWith("http://") && !url.startsWith("https://")) {
      url = "http://$url";
    }
    launch(url.trim());
  }
}
