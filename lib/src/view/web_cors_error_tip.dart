import 'package:flutter/widgets.dart';

import 'link_text_view.dart';

class WebCorsErrorTip extends StatelessWidget {
  const WebCorsErrorTip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('web端会有跨域（CORS）问题，浏览器规范限制，不是代码能解决的，'),
        Text('建议下载客户端版本，'),
        LinkTextView(
          'https://github.com/AoEiuV020/TaikoSongs/releases',
        ),
        Text('chrome可以添加启动参数（--disable-web-security）关闭这个限制，'),
        LinkTextView(
          'https://stackoverflow.com/a/66879350',
        ),
        Text('也可以通过安装拓展解决，'),
        LinkTextView(
          'https://chrome.google.com/webstore/detail/allow-cors-access-control/lhobafahddgcelffkeicbaginigeejlf/related?hl=en-US',
        ),
        Text('安卓chrome也可以通过adb权限设置这个参数，'),
        LinkTextView(
          'https://stackoverflow.com/a/52948221',
        ),
      ],
    );
  }
}
