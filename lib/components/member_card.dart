import 'package:etcd_manage_app/models/member_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

// 课程详情问答
class MemberCard extends StatefulWidget {
  MemberCard({
    Key key,
    GestureTapCallback this.onTap,
    MemberInfo this.memberInfo,
  }) : super(key: key);
  GestureTapCallback onTap;
  MemberInfo memberInfo;

  @override
  _MemberCardState createState() => _MemberCardState();
}

class _MemberCardState extends State<MemberCard> {
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
    return GestureDetector(
      onTap: widget.onTap ?? null,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              ListTile(
                title: RichText(
                  text: TextSpan(
                    text: 'Name: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyText1.color,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: widget.memberInfo.name ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).textTheme.bodyText1.color,
                        ),
                      ),
                    ],
                  ),
                ),
                subtitle: RichText(
                  text: TextSpan(
                    text: 'ID: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.caption.color,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: widget.memberInfo.iD ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).textTheme.caption.color,
                        ),
                      ),
                      TextSpan(
                        text: "\nRole: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.caption.color,
                        ),
                      ),
                      TextSpan(
                        text: widget.memberInfo.role ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).textTheme.caption.color,
                        ),
                      ),
                    ],
                  ),
                ),
                trailing: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: 66,
                    height: 30,
                    color: widget.memberInfo.status == 'healthy'
                        ? Colors.green[300]
                        : Colors.red[400],
                    child: Center(
                      child: Text(
                        widget.memberInfo.status ?? 'None',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1.color,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
