import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mpi_new/presentations/presentations.dart';

import '../../../businesses_logics/bloc/setting/setting/setting_bloc.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  final ValueNotifier<bool> _isAllowBiometrics = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(context, title: "setting"),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(MyAssets.bg),
            fit: BoxFit.fill,
          ),
        ),
        child: BlocListener<SettingBloc, SettingState>(
          listener: (context, state) {},
          child: BlocBuilder<SettingBloc, SettingState>(
            builder: (context, state) {
              if (state is SettingLoadSuccess) {
                _isAllowBiometrics.value = state.isAllowBiometrics;
                return Padding(
                  padding: LayoutCustom.paddingItemView,
                  child: ListView(
                    children: [
                      state.isBiometrics == false
                          ? const SizedBox()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Title 2"),
                                CardCustom(
                                    child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text("biometrics".tr()),
                                          Switch(
                                              value: _isAllowBiometrics.value,
                                              onChanged: (value) {
                                                BlocProvider.of<SettingBloc>(
                                                        context)
                                                    .add(SwitchBiometrics(
                                                  isAllowBiometrics: value,
                                                ));
                                              }),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                              ],
                            ),
                    ],
                  ),
                );
              }
              return const Column();
            },
          ),
        ),
      ),
    );
  }
}
