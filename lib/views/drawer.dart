import 'package:flutter/material.dart';

// 左侧抽屉栏
class DrawerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var drawer = Drawer( // 左侧抽屉
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('测试账户', style: TextStyle(fontWeight: FontWeight.bold),),
            accountEmail: Text('test@test.com'),
            currentAccountPicture: CircleAvatar( // 个人头像
              radius: 36,
              backgroundImage: AssetImage('assets/avatar.jpg')
            ),
//                decoration: BoxDecoration( //背景图
//                    color:Colors.red[400],
//                    image: DecorationImage(
//                        image: NetworkImage('https://img.zcool.cn/community/03881fe588de672a8012060c8ffb823.gif'),
//                        fit: BoxFit.cover,
//                        colorFilter: ColorFilter.mode( //背景图加颜色滤镜
//                            Colors.yellow[400].withOpacity(0.6),
//                            BlendMode.hardLight
//                        )
//                    )
//                ),
          ),
          ListTile(
            title: Text('我的消息', textAlign: TextAlign.left,),
            leading: Icon(Icons.message, color:Colors.black12, size: 22.0,),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            title: Text('我的收藏', textAlign: TextAlign.left,),
            leading: Icon(Icons.favorite, color:Colors.black12, size: 22.0,),
          ),
          ListTile(
            title: Text('设置', textAlign: TextAlign.left,),
            leading: Icon(Icons.settings, color:Colors.black12, size: 22.0,),
          ),
        ],
      ),
    );
    return Container(
      color: Colors.brown,
        child: drawer
    );
  }
}
