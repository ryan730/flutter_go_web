import 'dart:async';

import 'package:flutter_web/material.dart';
import '../../utils/shared_preferences.dart';

import 'package:flutter_go/components/list_view_item.dart';
import 'package:flutter_go/components/list_refresh.dart' as listComp;
import 'package:flutter_go/components/pagination.dart';
import 'package:flutter_go/views/first_page/first_page_item.dart';
import 'package:flutter_go/components/disclaimer_msg.dart';
import 'package:flutter_go/utils/net_utils.dart';

// ValueKey<String> key;
class FirstPage1 extends StatefulWidget {
  @override
  FirstPageState1 createState() => new FirstPageState1();
}

class FirstPageState1 extends State<FirstPage1>{
  Future<bool> _unKnow;
  GlobalKey<DisclaimerMsgState> key;

  @override
  void initState() {
    super.initState();
    if (key == null) {
      key = GlobalKey<DisclaimerMsgState>();
      // key = const Key('__RIKEY1__');
      //获取sharePre
//      _unKnow = _prefs.then((SharedPreferences prefs) {
//        return (prefs.getBool('disclaimer::Boolean') ?? false);
//      });

      /// 判断是否需要弹出免责声明,已经勾选过不在显示,就不会主动弹
//      _unKnow.then((bool value) {
//        new Future.delayed(const Duration(seconds: 1),(){
//          if (!value && key.currentState is DisclaimerMsgState && key.currentState.showAlertDialog is Function) {
//            key.currentState.showAlertDialog(context);
//          }
//        });
//      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: Text('12312312312313'));
  }
}


class FirstPage extends StatefulWidget {
  @override
  FirstPageState createState() => new FirstPageState();
}

class FirstPageState extends State<FirstPage> with AutomaticKeepAliveClientMixin{
  ///Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<bool> _unKnow;
  GlobalKey<DisclaimerMsgState> key;

  @override
  bool get wantKeepAlive => true;


  @override
  void initState() {
    super.initState();
    if (key == null) {
      key = GlobalKey<DisclaimerMsgState>();
      // key = const Key('__RIKEY1__');
      //获取sharePre
//      _unKnow = _prefs.then((SharedPreferences prefs) {
//        return (prefs.getBool('disclaimer::Boolean') ?? false);
//      });

      /// 判断是否需要弹出免责声明,已经勾选过不在显示,就不会主动弹
//      _unKnow.then((bool value) {
//        new Future.delayed(const Duration(seconds: 1),(){
//          if (!value && key.currentState is DisclaimerMsgState && key.currentState.showAlertDialog is Function) {
//            key.currentState.showAlertDialog(context);
//          }
//        });
//      });
    }
  }


  Future<Map> getIndexListData([Map<String, dynamic> params]) async {
    ///const juejin_flutter = 'https://timeline-merger-ms.juejin.im/v1/get_tag_entry?src=web&tagId=5a96291f6fb9a0535b535438';
    ////const juejin_flutter = 'http://127.0.0.1:3000/juejin.im/v1/get_tag_entry?src=web&tagId=5a96291f6fb9a0535b535438';
    const juejin_flutter = 'https://106.12.54.248:9527/juejin.im/v1/get_tag_entry?src=web&tagId=5a96291f6fb9a0535b535438';
    
    var pageIndex = (params is Map) ? params['pageIndex'] : 0;
    final _param  = {'page':pageIndex,'pageSize':20,'sort':'rankIndex'};
    var responseList = [];
    var  pageTotal = 0;
    
   try{
      var response = await NetUtils.get(juejin_flutter, _param);
     print(response['d']['total']);
     responseList = response['d']['entrylist'];
     pageTotal = response['d']['total'] as int;
     if (!(pageTotal is int) || pageTotal <= 0) {
       pageTotal = 0;
     }
   }catch(e){
      throw(e);
     //print('first_page_error:${e}');
   }

    pageIndex += 1;
    List resultList = new List();
    for (int i = 0; i < responseList.length; i++) {
      try {
        FirstPageItem cellData = new FirstPageItem.fromJson(responseList[i]);
        resultList.add(cellData);
      } catch (e) {
        // No specified type, handles all
      }
    }
    Map<String, dynamic> result = {"list":resultList, 'total':pageTotal, 'pageIndex':pageIndex};
    return result;
  }

  /// 每个item的样式
  Widget makeCard(index,item){
    var myTitle = '${item.title}';
    var myUsername = '${'👲'}: ${item.username} ';
    var codeUrl = '${item.detailUrl}';
    return new ListViewItem(itemUrl:codeUrl,itemTitle: myTitle,data: myUsername,);
  }

  headerView(){
    return
      Column(
        children: <Widget>[
          Stack(
            //alignment: const FractionalOffset(0.9, 0.1),//方法一
              children: <Widget>[
                Pagination(),
                Positioned(//方法二
                    top: 10.0,
                    left: 0.0,
                    child: DisclaimerMsg(key:key,pWidget:this)
                ),
              ]),
          SizedBox(height: 1, child:Container(color: Theme.of(context).primaryColor)),
          SizedBox(height: 10),
        ],
      );

  }

  @override
  Widget build(BuildContext context) {
    /// super.build(context);
    return new Column(
        children: <Widget>[
          // new Stack(
          //   //alignment: const FractionalOffset(0.9, 0.1),//方法一
          //   children: <Widget>[
          //   Pagination(),
          //   Positioned(//方法二
          //     top: 10.0,
          //     left: 0.0,
          //     child: DisclaimerMsg(key:key,pWidget:this)
          //   ),
          // ]),
          // SizedBox(height: 2, child:Container(color: Theme.of(context).primaryColor)),
          new Expanded(
            //child: new List(),
              child: listComp.ListRefresh(getIndexListData,makeCard,headerView)
          )
        ]

    );
  }
}


