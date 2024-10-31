import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../../businesses_logics/bloc/forgot_password/forgot_password_bloc.dart';
import '../../../data/data.dart';

class WebViewPluginView extends StatefulWidget {
  final String username;
  const WebViewPluginView({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  State<WebViewPluginView> createState() => _WebViewPluginViewState();
}

class _WebViewPluginViewState extends State<WebViewPluginView> {
  InAppWebViewController? webView;
  String url = "";

  double progress = 0;

  late ForgotPasswordBloc _bloc;
  @override
  void initState() {
    _bloc = BlocProvider.of<ForgotPasswordBloc>(context);
    _bloc.add(ForgotPasswordViewLoaded(username: widget.username));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(context, title: 'forgotpassword'),
      body: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ForgotPasswordFailure) {
            MyDialog.showError(
                context: context,
                messageError: state.message,
                pressTryAgain: () {
                  Navigator.pop(context);
                },
                whenComplete: () {
                  BlocProvider.of<ForgotPasswordBloc>(context)
                      .add(ForgotPasswordViewLoaded(username: widget.username));
                });
          }
        },
        builder: (context, state) {
          if (state is ForgotPasswordSuccess) {
            url = state.url;
            log(url);
            return Column(
              children: [
                Container(
                    child: progress < 1.0
                        ? Column(
                            children: [
                              LinearProgressIndicator(
                                value: progress,
                                color: MyColor.darkLiver,
                              ),
                              Text(
                                "${"loading".tr()} ${progress * 100}"
                                "%",
                              ),
                            ],
                          )
                        : Container()),
                Expanded(
                  child: InAppWebView(
                    initialUrlRequest: URLRequest(url: Uri.parse(url)),
                    onWebViewCreated: (InAppWebViewController controller) {
                      webView = controller;
                    },
                    onReceivedServerTrustAuthRequest:
                        (controller, challenge) async {
                      return ServerTrustAuthResponse(
                          action: ServerTrustAuthResponseAction.PROCEED);
                    },
                    onLoadStart: (controller, url) {
                      setState(() {
                        this.url = url?.toString() ?? '';
                      });
                    },
                    onLoadStop: (controller, url) async {
                      setState(() {
                        this.url = url?.toString() ?? '';
                      });
                    },
                    onProgressChanged: (controller, progress) {
                      setState(() {
                        this.progress = progress / 100;
                      });
                    },
                  ),
                ),
              ],
            );
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
