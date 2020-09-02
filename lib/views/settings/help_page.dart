import 'package:etcd_manage_app/components/app_bar.dart';
import 'package:etcd_manage_app/components/help_question.dart';
import 'package:etcd_manage_app/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:etcd_manage_app/i18n/i18n.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<ZState>(builder: (context, store) {
      I18N lang = StoreProvider.of<ZState>(context).state.lang;
      return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: ZAppBar(
          preferredSize: Size.fromHeight(40),
          appBar: AppBar(
            elevation: 0,
            title: Text(
              lang.get('setings.help'),
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            centerTitle: true,
          ),
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
          child: ListView(
            children: <Widget>[
              HelpQuestion(
                question: lang.get('setings_help.question1'),
                content: lang.get('setings_help.answer1'),
              ),
              HelpQuestion(
                question: lang.get('setings_help.question2'),
                content: lang.get('setings_help.answer2'),
              ),
              HelpQuestion(
                question: lang.get('setings_help.question3'),
                content: lang.get('setings_help.answer3'),
              ),
              HelpQuestion(
                question: lang.get('setings_help.question5'),
                content: lang.get('setings_help.answer5'),
              ),
              HelpQuestion(
                question: lang.get('setings_help.question6'),
                content: lang.get('setings_help.answer6'),
              ),
              HelpQuestion(
                question: lang.get('setings_help.question6'),
                content: lang.get('setings_help.answer6'),
              ),
            ],
          ),
        ),
      );
    });
  }
}
