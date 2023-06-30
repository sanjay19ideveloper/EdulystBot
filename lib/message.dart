import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MessagesScreen extends StatefulWidget {
  final List messages;
  const MessagesScreen({Key? key, required this.messages}) : super(key: key);

  @override
  MessagesScreenState createState() => MessagesScreenState();
}

class MessagesScreenState extends State<MessagesScreen> {
  late ScrollController listScrollController = ScrollController();
  scrollToBottom() {
    listScrollController.jumpTo(listScrollController.position.maxScrollExtent);
  }

  Future<void> scrollListToEND() async {
    await Future.delayed(const Duration(milliseconds: 700));
    listScrollController.animateTo(
      listScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 700),
      curve: Curves.ease,
    );

    print('scrolled list to end');
  }
  @override
void initState() {
  super.initState();
  listScrollController.addListener(_scrollListener);
}
@override
  void dispose() {
    listScrollController.dispose();
    super.dispose();
  }
  void _scrollListener() {
  if ( listScrollController.offset >=
      listScrollController.position.maxScrollExtent &&
      !listScrollController.position.outOfRange) {
    // Reach the end of the list, perform any desired action here
  }
}


  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Column(
        children: [
          Flexible(
            child: ListView.builder(
                controller: listScrollController,
                  shrinkWrap: true,

                itemBuilder: (context, index) {
                   controller: listScrollController;
                  Message msg = widget.messages[index]['message'];
                  // scrollListToEND();
                  if (index == widget.messages.length - 1) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                   scrollListToEND();
                  });
                }
                  
                  
                  return Container(
                    margin: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: widget.messages[index]['isUserMessage']
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          widget.messages[index]['isUserMessage']
                              ? 'assets/user.png'
                              : 'assets/edubot.png',
                          height: 30,
                          width: 30,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Container(
                            // height:
                            //     widget.messages[index]['isUserMessage']
                            //         ? 50
                            //         : 60,
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 14),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: const Radius.circular(
                                    20,
                                  ),
                                  topRight: const Radius.circular(20),
                                  bottomRight: Radius.circular(
                                      widget.messages[index]['isUserMessage'] ? 0 : 20),
                                  topLeft: Radius.circular(
                                      widget.messages[index]['isUserMessage'] ? 20 : 0),
                                ),
                                color: widget.messages[index]['isUserMessage']
                                    ? const Color(0xff7062e3)
                                    : Color.fromRGBO(157, 210, 167, 1)
                                        .withOpacity(0.8)),
                            constraints: BoxConstraints(maxWidth: w * 2/3),
                          //   constraints: widget.messages[index]['isUserMessage']
                          //  ? BoxConstraints(maxWidth: w * 2 / 3,maxHeight: h * 3/2)
                          //  : BoxConstraints(maxWidth: w * 2 / 3,maxHeight: h * 6/2),
                            child: widget.messages[index]['message']?.text?.text[0] ==
                                    null
                                ? InkWell(
                                    onTap: () {
                                      launchUrl(Uri.parse(
                                          '${msg.payload?['richContent'][0][0]['actionLink']}'));
                                    },
                                    child: SingleChildScrollView(
                                       
                                      child: Column(
                                        children: [
                                          Image.network(
                                              '${msg.payload?['richContent'][0][0]['rawUrl']}',
                                              width: widget.messages[index]['message']
                                                          ?.text?.text[0] ==
                                                      null
                                                  ? 400
                                                  : 100,
                                              height: 170,
                                              fit: BoxFit.cover),
                                          const SizedBox(height: 10),
                                          SizedBox(
                                            height: 100,
                                            width: 600,
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // Text(
                                                  //     'widget.messages[index]['message']?.text?.text[0]'),
                                                  Text(
                                                      '${msg.payload?['richContent'][0][0]['title']}'),
                                                  Text(
                                                      '${msg.payload?['richContent'][0][0]['enrollment']}'),
                                                      Text(
                                                      '${msg.payload?['richContent'][0][0]['duration']}'),
                                                  Text(
                                                      style: const TextStyle(
                                                          decoration:
                                                              TextDecoration.underline,
                                                          color: Colors.white),
                                                      maxLines: 3,
                                                      overflow: TextOverflow.ellipsis,
                                                      '${msg.payload?['richContent'][0][0]['rawUrl']}'),
                                                  // Text(
                                                  //     '${msg.payload?['richContent'][0][2]['options'][0]['text']}')
                                                ]),
                                          ),
                                        ],
                                      ),
                                    ))
            
                                //show playload
                                // ? InkWell(
                                //     onTap: () {
                                //       print('dddd${widget.messages[index]['message']}');
                                //       launchUrl(Uri.parse('${msg.payload?['richContent'][0][2]['options'][0]['link']}'));
                                //     },
                                //     child: Row(children: [
                                //       Image.network(
                                //           '${msg.payload?['richContent'][0][0]['rawUrl']}',
                                //           width: 100,
                                //           height: 100,
                                //           fit: BoxFit.cover),
                                //           SizedBox(width:10),
            
                                //           Container(
                                //             height:100,
                                //             width: 130,
                                //             child: Column(
            
                                //               crossAxisAlignment: CrossAxisAlignment.start,
                                //               children:[
                                //                 Text('${msg.payload?['richContent'][0][2]['options'][0]['text']}')
            
                                //                 // Text('${msg.payload?['richContent'][0][1]['options'][0]['text']}'),
                                //                 // Text('${msg.payload?['richContent'][0][1]['options'][0]['link']}'),
                                //                 // Text('${msg.payload?['richContent'][0][0]['options'][0]['rawUrl']}'),
            
                                //             ]),
                                //           )
                                //     ]))
            
                                : 
                                
                                ClickableLink(
                                    text:
                                        '${widget.messages[index]['message'].text.text[0]}')
                            // child: Text('${msg.payload}')
                            // child: Text('${widget.messages[index]['message']?.text?.text[0]}')
            
                            ),
                      ],
                    ),
                  );
                },
                
                itemCount: widget.messages.length),
          ),
        ],
      ),
    );
  }
}

// chipList() {
//   return Wrap(
//     spacing: 6.0,
//     runSpacing: 6.0,
//     children: <Widget>[
//       _buildChip('Gamer', const Color(0xFFff6666)),
//       _buildChip('Hacker', const Color(0xFF007f5c)),
//       _buildChip('Developer', const Color(0xFF5f65d3)),
//       _buildChip('Racer', const Color(0xFF19ca21)),
//       _buildChip('Traveller', const Color(0xFF60230b)),
//     ],
//   );
// }

// Widget _buildChip(String label, Color color) {
//   return Chip(
//     labelPadding: const EdgeInsets.all(2.0),
//     avatar: CircleAvatar(
//       backgroundColor: Colors.white70,
//       child: Text(label[0].toUpperCase()),
//     ),
//     label: Text(
//       label,
//       style: const TextStyle(
//         color: Colors.white,
//       ),
//     ),
//     backgroundColor: color,
//     elevation: 6.0,
//     shadowColor: Colors.grey[60],
//     padding: const EdgeInsets.all(8.0),
//   );
// }

class ClickableLink extends StatelessWidget {
  final String text;

  const ClickableLink({Key? key, required this.text}) : super(key: key);

  void openLink(String url) {
    print('url is $url');
    //  launchUrl(Uri.parse(url));
    launch(
        "https://pcsupport.lenovo.com/in/en/products/laptops-and-netbooks/100-series/110-15isk/downloads/ds118020");
  }

  @override
  Widget build(BuildContext context) {
    final pattern = RegExp(r'https?://\S+');
    final matches = pattern.allMatches(text);
    final List<TextSpan> spans = [];

    int start = 0;

    for (final match in matches) {
      final linkText = match.group(0);
      if (linkText != null) {
        final linkStart = match.start;
        final linkEnd = match.end;

        if (start < linkStart) {
          spans.add(TextSpan(text: text.substring(start, linkStart)));
        }

        spans.add(
          TextSpan(
            text: linkText,
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => openLink(linkText),
          ),
        );

        start = linkEnd;
      }
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }
}
