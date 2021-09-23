
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'home.dart';
import 'instagram_constant.dart';
import 'instagram_model.dart';
class InstagramView extends StatelessWidget {
  const InstagramView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final webview = FlutterWebviewPlugin();
      final InstagramModel instagram = InstagramModel();

      buildRedirectToHome(webview, instagram, context);

      return WebviewScaffold(
        url: InstagramConstant.instance.url,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(title: const Text("Instagram Login", style: TextStyle(color: Colors.black,),), backgroundColor: Colors.transparent, elevation: 0,),
      );
    });
  }

  Future<void> buildRedirectToHome(FlutterWebviewPlugin webview,
      InstagramModel instagram, BuildContext context) async {
    webview.onUrlChanged.listen((String url) async {
      if (url.contains(InstagramConstant.redirectUri)) {
        instagram.getAuthorizationCode(url);
        await instagram.getTokenAndUserID().then((isDone) {
          if (isDone) {
            instagram.getUserProfile().then((isDone) async {
              await webview.close();

              print('${instagram.username} logged in!');

              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => HomeView(
                    token: instagram.authorizationCode.toString(),
                    name: instagram.username.toString(),
                  ),
                ),
              );
            });
          }
        });
      }
    });
  }
}