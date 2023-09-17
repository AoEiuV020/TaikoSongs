import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'link_text_view.dart';

class WebCorsErrorTip extends StatelessWidget {
  const WebCorsErrorTip({
    super.key,
    required this.originUrl,
  });

  final String originUrl;

  void openOriginUrl() {
    launchUrlString(originUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('web端会有跨域（CORS）问题，浏览器规范限制，不是代码能解决的，'),
        const Text('建议下载客户端版本，'),
        const LinkTextView(
          'https://github.com/AoEiuV020/TaikoSongs/releases',
        ),
        const Text('chrome可以添加启动参数（--disable-web-security）关闭这个限制，'),
        const LinkTextView(
          'https://stackoverflow.com/a/66879350',
        ),
        const Text('也可以通过安装拓展解决，'),
        const LinkTextView(
          'https://chrome.google.com/webstore/detail/allow-cors-access-control/lhobafahddgcelffkeicbaginigeejlf/related?hl=en-US',
        ),
        const Text('安卓chrome也可以通过adb权限设置这个参数，'),
        const LinkTextView(
          'https://stackoverflow.com/a/52948221',
        ),
        ElevatedButton(
          onPressed: openOriginUrl,
          child: const Text('源网站'),
        ),
      ],
    );
  }
}
