import 'package:etcd_manage_app/components/app_bar.dart';
import 'package:etcd_manage_app/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:etcd_manage_app/i18n/i18n.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:url_launcher/url_launcher.dart';

class DonationPage extends StatefulWidget {
  @override
  _DonationPageState createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  @override
  void initState() {
    super.initState();
  }

  I18N lang; // 语言

  // 保存图片 打开支付宝或微信
  void donation(int index) {
    print(index);
    YYDialog().build()
      ..width = 260
      ..borderRadius = 4.0
      ..text(
        padding: EdgeInsets.all(25.0),
        alignment: Alignment.center,
        text: lang.get('setings_donation.message'),
        color: Colors.black,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      )
      ..divider()
      ..doubleButton(
        padding: EdgeInsets.only(top: 10.0),
        gravity: Gravity.center,
        withDivider: true,
        text1: lang.get('public.cancel'),
        color1: Colors.blue,
        fontSize1: 14.0,
        fontWeight1: FontWeight.bold,
        onTap1: () {},
        text2: lang.get('public.confirm'),
        color2: Colors.green,
        fontSize2: 14.0,
        fontWeight2: FontWeight.bold,
        onTap2: () async {
          print("确定");
          String app = 'weixin://';
          if (index == 0) {
            app = 'alipay://';
          }
          await launch(app);
        },
      )
      ..show();
  }

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);
    return StoreBuilder<ZState>(builder: (context, store) {
      lang = StoreProvider.of<ZState>(context).state.lang;
      return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: ZAppBar(
          preferredSize: Size.fromHeight(40),
          appBar: AppBar(
            elevation: 0,
            title: Text(
              lang.get('setings.donation'),
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            centerTitle: true,
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: Swiper(
            autoplay: false,
            itemCount: 2,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Image(
                        height: MediaQuery.of(context).size.height * 3 /5,
                        image: AssetImage(index == 0
                            ? 'assets/images/alipay.jpg'
                            : 'assets/images/wechatpay.jpg'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Center(
                        child: Text('先截图，点击二维码会打开对应APP'),
                      ),
                    ),
                  ],
                ),
              );
            },
            pagination: new SwiperPagination(
              builder: new DotSwiperPaginationBuilder(
                  color: Colors.green,
                  activeColor: Colors.blue,
                  size: 20.0,
                  activeSize: 20.0),
            ),
            onTap: (int index) {
              donation(index);
            },
          ),
        ),
      );
    });
  }
}
