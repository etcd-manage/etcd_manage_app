import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

// 课程详情问答
class HelpQuestion extends StatefulWidget {
  HelpQuestion({
    Key key,
    this.question,
    this.content,
  }) : super(key: key);
  String question;
  String content;

  @override
  _HelpQuestionState createState() => _HelpQuestionState();
}

class _HelpQuestionState extends State<HelpQuestion> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 20,
            margin: const EdgeInsets.only(top: 20),
            child: Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width - 80,
                  child: Text(
                    '' + widget.question,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              '    '+widget.content,
              style: TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
