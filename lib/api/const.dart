/* api请求相关常量 */

// 生产
class ApiConfig {
  // api基本地址
  static const BaseAddress = 'http://140.143.234.132:11280';
  // 连接超时
  static const ConnectTimeout = 5000; // 5s
  // 接收超时
  static const ReceiveTimeout = 15000; // 5s
  // app版本
  static const Version = "1.0.0";
}

String manageBaseAddress = '';