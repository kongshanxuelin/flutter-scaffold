import 'package:flutter/material.dart';

enum ENV {
  PRODUCTION,
  DEV,
}
class Application {
  /// 通过Application设计环境变量
  static ENV env = ENV.DEV;

  static TabController controller;

  static bool pageIsOpen = false;

  /// 所有获取配置的唯一入口
  Map<String, String> get config {
    if (Application.env == ENV.PRODUCTION) {
      return {};
    }
    if (Application.env == ENV.DEV) {
      return {};
    }
    return {};
  }

}
