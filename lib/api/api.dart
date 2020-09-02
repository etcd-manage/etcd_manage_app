import 'dart:convert';
import 'dart:io';
import 'package:etcd_manage_app/models/server_info.dart';
import 'package:etcd_manage_app/models/userinfo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:etcd_manage_app/api/const.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

// dio 公共请求
class DioUtil {
  static DioUtil _instance = DioUtil._internal();
  // dio http请求对象
  Dio ajax;
  BaseOptions options;
  CookieManager cookieManager;
  DefaultCookieJar cookieJar;
  PersistCookieJar cookieJarFile;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  factory DioUtil() {
    return DioUtil._internal();
  }

  // 删除所以cookie
  deleteAllCookie() {
    if (cookieJarFile != null) {
      cookieJarFile.deleteAll();
    } else if (cookieJar != null) {
      cookieJar.deleteAll();
    }
  }

  // 做一些初始化grpc连接的事
  DioUtil._internal() {
    String baseAddress = ApiConfig.BaseAddress;
    if (manageBaseAddress != null && manageBaseAddress != "") {
      print("manageBaseAddress" + manageBaseAddress);
      baseAddress = manageBaseAddress;
    }
    options = BaseOptions(
        validateStatus: (int status) => true,
        baseUrl: baseAddress,
        connectTimeout: ApiConfig.ConnectTimeout,
        receiveTimeout: ApiConfig.ReceiveTimeout,
        contentType: Headers.jsonContentType,
        headers: {
          "version": ApiConfig.Version,
        });

    ajax = new Dio(options); // 使用默认配置
    // Cookie管理
    getTemporaryDirectory().then((Directory tempDir) {
      // print('磁盘存储cookie ' + tempDir.path);
      cookieJarFile =
          new PersistCookieJar(dir: tempDir.path, ignoreExpires: true);
      cookieManager = CookieManager(cookieJarFile);
      ajax.interceptors.add(cookieManager);
    }, onError: (e) {
      // print('内存存储cookie');
      cookieJar = DefaultCookieJar();
      cookieManager = CookieManager(cookieJar);
      ajax.interceptors.add(cookieManager);
    });

    // 请求拦截器
    if (!kReleaseMode) {
      ajax.interceptors
          .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
        print("\n================== 请求数据 ==========================");
        print("url = ${options.uri.toString()}");
        print("headers = ${options.headers}");
        print("params = ${options.data}");
        final SharedPreferences prefs = await _prefs;
        String userStr = prefs.getString("userinfo");

        Fluttertoast.showToast(
          msg: userStr,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );

        if (userStr != null && userStr != "") {
          try {
            var userinfo = UserInfo.fromJson(json.decode(userStr));
            options.headers["Token"] = userinfo.token;
          } catch (e) {}
        }
        // 选择的etcd id
        String serverInfoStr = prefs.getString("server_info");
        if (serverInfoStr != null && serverInfoStr != "") {
          try {
            var serverInfo = ServerInfo.fromJson(json.decode(serverInfoStr));
            options.headers["EtcdID"] = serverInfo.id;
          } catch (e) {
            options.headers["EtcdID"] = "0";
          }
        }

        return options;
      }, onResponse: (Response response) {
        print("\n================== 响应数据 ==========================");
        print("code = ${response.statusCode}");
        print("data = ${response.data}");
        return response;
      }, onError: (DioError e) {
        print("\n================== 错误响应数据 ======================");
        print("type = ${e.type}");
        print("message = ${e.message}");
        return e;
      }));
    } else {
      ajax.interceptors
          .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {

        final SharedPreferences prefs = await _prefs;
        String userStr = prefs.getString("userinfo");
        if (userStr != null && userStr != "") {
          try {
            var userinfo = UserInfo.fromJson(json.decode(userStr));
            options.headers["Token"] = userinfo.token;
          } catch (e) {}
        }
        // 选择的etcd id
        String serverInfoStr = prefs.getString("server_info");
        if (serverInfoStr != null && serverInfoStr != "") {
          try {
            var serverInfo = ServerInfo.fromJson(json.decode(serverInfoStr));
            options.headers["EtcdID"] = serverInfo.id;
          } catch (e) {
            options.headers["EtcdID"] = "0";
          }
        }

        return options;
      }, onResponse: (Response response) {
        return response;
      }, onError: (DioError e) {
        return e;
      }));
    }
  }

  /*
   * get 请求
   */
  get(url, {data, options, cancelToken}) async {
    Response response;
    try {
      response = await ajax.get(url,
          queryParameters: data, options: options, cancelToken: cancelToken);
    } on DioError catch (e) {
      print("请求错误" + e.message);
      // 提示错误
      Fluttertoast.showToast(
          msg: "Please check the network or log in again",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    return response;
  }

  /*
   * post 请求
   */
  post(url,
      {data,
      options,
      Map<String, dynamic> queryParameters,
      cancelToken}) async {
    Response response;
    try {
      response = await ajax.post(url,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken);
    } on DioError catch (e) {
      print("请求错误" + e.message);
      // 提示错误
      Fluttertoast.showToast(
          msg: "Please check the network or log in again",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    return response;
  }

  /*
   * 取消请求
   *
   * 同一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消。
   * 所以参数可选
   */
  void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }
}
