import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:edubot/clickable_link.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  String getFormattedTime() {
    DateTime now = DateTime.now();
    String formattedTime = DateFormat.Hms().format(now);
    return formattedTime;
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
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      // Reach the end of the list, perform any desired action here
    }
  }

  @override
  Widget build(BuildContext context) {
    String getFormattedDate() {
      DateTime now = DateTime.now();
      DateTime formattedDate =
          now; // Remove the time portion
      DateTime tomorrowDate =
          now.add(const Duration(days: 1));// Get tomorrow's date

      if (formattedDate == now) {
        return 'Today';
      } else if (formattedDate == tomorrowDate) {
        return 'Tomorrow';
      } else {
        String formattedDate = DateFormat.yMMMMd().format(now);
        return formattedDate;
      }
    }

    DateTime now = DateTime.now();
    String formattedTime = DateFormat('h:mm a').format(now);
    String time = getFormattedTime();
    String formattedDate = DateFormat.yMMMMd().format(now);

    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 10),

          Text(getFormattedDate(),
              style:
                  TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),

          // Text(formattedDate,style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),
          //           ),

          Flexible(
            child: ListView.builder(
                controller: listScrollController,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  controller:
                  listScrollController;
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
                            padding: EdgeInsets.symmetric(
                                vertical: widget.messages[index]
                                        ['isUserMessage']
                                    ? 10
                                    : 14,
                                horizontal: 14),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: const Radius.circular(
                                    20,
                                  ),
                                  topRight: const Radius.circular(20),
                                  bottomRight: Radius.circular(
                                      widget.messages[index]['isUserMessage']
                                          ? 0
                                          : 20),
                                  topLeft: Radius.circular(
                                      widget.messages[index]['isUserMessage']
                                          ? 20
                                          : 0),
                                ),
                                color: widget.messages[index]['isUserMessage']
                                    ? const Color(0xff9DB2BF)
                                    : const Color(0xffDDE6ED)),
                            constraints: widget.messages[index]['isUserMessage']
                                ? null
                                : BoxConstraints(maxWidth: w * 2 / 3),
                            //   constraints: widget.messages[index]['isUserMessage']
                            //  ? BoxConstraints(maxWidth: w * 2 / 3,)
                            //  : BoxConstraints(maxWidth: w * 2 / 3,),
                            child: widget.messages[index]['message']?.text
                                        ?.text[0] ==
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
                                              width: widget
                                                          .messages[index]
                                                              ['message']
                                                          ?.text
                                                          ?.text[0] ==
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
                                                      '${msg.payload?['richContent'][0][0]['title']}',style: const TextStyle(
                                                         
                                                          color: Color(0xff27374D), fontWeight: FontWeight.w600,)),
                                                  Text(
                                                      '${msg.payload?['richContent'][0][0]['enrollment']}',style: const TextStyle(
                                                          
                                                          color: Color(0xff27374D), fontWeight: FontWeight.w600,)),
                                                  Text(
                                                      '${msg.payload?['richContent'][0][0]['duration']}',style: const TextStyle(
                                                          
                                                          color: Color(0xff27374D), fontWeight: FontWeight.w600,)),
                                                  Text(
                                                      style: const TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                                   fontWeight: FontWeight.w600,
            
                                                    color: Color(0xff576CBC),),
                                                         
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      '${msg.payload?['richContent'][0][0]['rawUrl']}'),
                                                  // Text(
                                                  //     '${msg.payload?['richContent'][0][2]['options'][0]['text']}')
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text(formattedTime,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey)),
                                                    ],
                                                  )
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

                                // : ClickableLink(
                                //     text:
                                //         '${widget.messages[index]['message'].text.text[0]}',
                                //     time: '${formattedTime}',
                                //     isUserMessage: widget.messages[index]
                                //         ['isUserMessage'],
                                //   ),
                                // child: Text('${msg.payload}')
                                // child: Text('${widget.messages[index]['message']?.text?.text[0]}')

                                : ClickableTextWidget(
                                    text:
                                        '${widget.messages[index]['message'].text.text[0]}')),
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
  final String time;
  final bool isUserMessage;

  const ClickableLink(
      {Key? key,
      required this.text,
      required this.isUserMessage,
      required this.time})
      : super(key: key);

  void openLink(String url) {
    if (!url.startsWith("http://") && !url.startsWith("https://")) {
      url = "http://$url";
      print('url is hel;lo $url');
    }
    //  launchUrl(Uri.parse(url));

    launch(url);
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
              ..onTap = () =>
                  openLink(linkText.replaceAll(')', '').replaceAll('(', '')),
          ),
        );

        start = linkEnd;
      }
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }
    //     spans.add(

    //   TextSpan(
    //     text: ' $time', // Include the formatted time here
    //     style: TextStyle(
    //       fontSize: 12,
    //       // fontStyle: FontStyle.italic,
    //     ),
    //   ),
    // );

// Text.rich(
//   TextSpan(
//     children: [
//       TextSpan(text: 'Hello '),
//       TextSpan(
//         text: 'bold',
//         style: TextStyle(fontWeight: FontWeight.bold),
//       ),
//       TextSpan(text: ' world!'),
//     ],
//   ),
// );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isUserMessage)
          Text(
            'Edulyst Venture',
          ),
        const SizedBox(height: 10),
        RichText(
          text: TextSpan(children: spans),
        ),
        const SizedBox(width: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              time,
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
            SizedBox(width: 5),
            if (isUserMessage)
              Icon(
                Icons.done_all,
                color: Colors.blue,
                size: 18,
              ),
          ],
        ),
      ],
    );
  }
}
