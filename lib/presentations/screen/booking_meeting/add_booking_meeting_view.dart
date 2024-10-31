import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mpi_new/presentations/widgets/components/dropdown_custom.dart'
    as dropdown_custom;
import '../../../data/data.dart';

class AddBookingMeetingView extends StatefulWidget {
  const AddBookingMeetingView({super.key});

  @override
  State<AddBookingMeetingView> createState() => _AddBookingMeetingViewState();
}

class _AddBookingMeetingViewState extends State<AddBookingMeetingView> {
  FacilitiesResponse? facilitiesSelected;
  ValueNotifier<String> _facilitiesNotifier = ValueNotifier('');
  ValueNotifier _fullDayNotifier = ValueNotifier(false);
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _memoController = TextEditingController();

  final ValueNotifier<DateTime> _dateNotifier = ValueNotifier(DateTime.now());

  final ValueNotifier<int> _hourStartNotifier =
      ValueNotifier<int>(DateTime.now().hour);
  final ValueNotifier<int> _hourEndNotifier =
      ValueNotifier<int>(DateTime.now().hour + 1);
  final ValueNotifier<int> _minuteStartNotifier = ValueNotifier<int>(00);
  final ValueNotifier<int> _minuteEndNotifier = ValueNotifier<int>(00);

  TimeOfDay time = const TimeOfDay(hour: 7, minute: 45);

  int? hourStartSelected;
  int? hourEndSelected;
  int? minuteStartSelected;
  int? minuteEndSelected;

  List<int> hourStart = List.generate(10, (index) => index + 8);
  List<int> hourEnd = List.generate(11, (index) => index + 8);

  List<int> minuteStart = [00, 15, 30, 45];
  List<int> minuteEnd = [00, 15, 30, 45];

  final _formKey = GlobalKey<FormState>();

  Widget? selectedMenu;

  Color backgroundPanel = Colors.black;
  Color colorPanel = MyColor.defaultColor;
  @override
  Widget build(BuildContext context) {
    backgroundPanel = Theme.of(context).colorScheme.onPrimaryContainer;
    colorPanel =
        Theme.of(context).textTheme.titleSmall?.color ?? MyColor.defaultColor;
    return PopScope(
      canPop: false,
      child: Form(
        key: _formKey,
        child: Scaffold(
          appBar:
              AppBarCustom(context, title: 'newbooking'.tr(), onPressBack: () {
            Navigator.pop(context, _dateNotifier.value);
          }),
          body: BlocListener<AddBookingMeetingBloc, AddBookingMeetingState>(
            listener: (context, state) {
              if (state is AddBookingMeetingFailure) {
                if (state.errorCode == MyError.errCodeNoInternet) {
                  MyDialog.showError(
                      context: context,
                      text: "close".tr(),
                      messageError: state.message,
                      pressTryAgain: () {
                        Navigator.pop(context);
                        BlocProvider.of<AddBookingMeetingBloc>(context)
                            .add(AddBookingMeetingViewLoaded());
                      });
                  reset();
                } else {
                  MyDialog.showError(
                      context: context,
                      text: "close".tr(),
                      messageError: state.message,
                      pressTryAgain: () {
                        Navigator.pop(context);
                        BlocProvider.of<AddBookingMeetingBloc>(context)
                            .add(AddBookingMeetingViewLoaded());
                      });
                  reset();
                }
              } else if (state is AddBookingMeetingSuccess) {
                if (state.saveSuccess == true) {
                  MyDialog.showSuccess(
                      context: context, message: 'addsuccess'.tr());
                } else if (state.saveSuccess == false) {
                  MyDialog.showError(
                      context: context,
                      text: "close".tr(),
                      messageError: 'Error',
                      pressTryAgain: () {
                        Navigator.pop(context);
                      });
                }
              }
            },
            child: BlocBuilder<AddBookingMeetingBloc, AddBookingMeetingState>(
              builder: (context, state) {
                if (state is AddBookingMeetingSuccess) {
                  _facilitiesNotifier.value =
                      state.facilitiesList[0].facilityCode ?? '';

                  hourStartSelected = _hourStartNotifier.value;
                  hourEndSelected = _hourEndNotifier.value;
                  minuteStartSelected = _minuteStartNotifier.value;
                  minuteEndSelected = _minuteEndNotifier.value;
                  return ListView(
                    padding: EdgeInsets.all(16.w),
                    children: <Widget>[
                      Column(
                        children: [
                          _buildCard(),
                          _buildFacilities(
                              facilitiesList: state.facilitiesList),
                          _buildTextField(
                              controller: _subjectController,
                              isRequired: true,
                              hint: 'subject',
                              label: 'subject'),
                          _buildTextField(
                              controller: _memoController,
                              hint: 'remark',
                              label: 'remark')
                        ],
                      ),
                    ],
                  );
                }
                return const ItemLoading();
              },
            ),
          ),
          bottomNavigationBar: _buildBtnSave(),
        ),
      ),
    );
  }

  Widget _buildCard() {
    return Card(
      elevation: 10,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        child: Column(
          children: [
            Padding(
              padding: LayoutCustom.paddingItemView,
              child: Row(
                children: [
                  _buildDate(),
                  _buildCheckBoxFullDay(),
                ],
              ),
            ),
            Padding(
              padding: LayoutCustom.paddingItemView,
              child: ValueListenableBuilder(
                valueListenable: _fullDayNotifier,
                builder: (context, value, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildFromTo(text: 'from'),
                    _fullDayNotifier.value
                        ? _buildTextFullDay(
                            text: _hourStartNotifier.value, isHour: true)
                        : _buildDropdown(
                            list: hourStart,
                            valueNotifier: _hourStartNotifier,
                            valueSelected: hourStartSelected,
                            isHour: true),
                    SizedBox(
                      width: 10.w,
                    ),
                    _fullDayNotifier.value
                        ? _buildTextFullDay(
                            text: _minuteStartNotifier.value, isHour: false)
                        : _buildDropdown(
                            list: minuteStart,
                            valueNotifier: _minuteStartNotifier,
                            valueSelected: minuteStartSelected,
                            isHour: false),
                  ],
                ),
              ),
            ),
            Padding(
              padding: LayoutCustom.paddingItemView,
              child: ValueListenableBuilder(
                valueListenable: _fullDayNotifier,
                builder: (context, value, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildFromTo(text: 'to'),
                    _fullDayNotifier.value
                        ? _buildTextFullDay(
                            text: _hourEndNotifier.value, isHour: true)
                        : _buildDropdown(
                            list: hourEnd,
                            valueNotifier: _hourEndNotifier,
                            valueSelected: hourEndSelected,
                            isHour: true),
                    SizedBox(
                      width: 10.w,
                    ),
                    _fullDayNotifier.value
                        ? _buildTextFullDay(
                            text: _minuteEndNotifier.value, isHour: false)
                        : _buildDropdown(
                            list: minuteEnd,
                            valueNotifier: _minuteEndNotifier,
                            valueSelected: minuteEndSelected,
                            isHour: false),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void reset() {
    facilitiesSelected = null;
    _facilitiesNotifier = ValueNotifier('');
    _fullDayNotifier = ValueNotifier(false);
    _subjectController = TextEditingController();
    _memoController = TextEditingController();
  }

  Widget _buildBtnSave() {
    return DefaultButton(
      buttonText: "submit".tr(),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          if ((_hourEndNotifier.value < _hourStartNotifier.value) ||
              (_hourEndNotifier.value == _hourStartNotifier.value &&
                  _minuteEndNotifier.value <= _minuteStartNotifier.value)) {
            MyDialog.showError(
                context: context,
                text: "close".tr(),
                messageError: 'startmustbelessthanend'.tr(),
                pressTryAgain: () {
                  Navigator.pop(context);
                });
          } else {
            BlocProvider.of<AddBookingMeetingBloc>(context).add(
                AddBookingMeetingPressed(
                    date: _dateNotifier.value,
                    startDate: TimeOfDay(
                        hour: _hourStartNotifier.value,
                        minute: _minuteStartNotifier.value),
                    endDate: TimeOfDay(
                        hour: _hourEndNotifier.value,
                        minute: _minuteEndNotifier.value),
                    facilities: facilitiesSelected!,
                    subject: _subjectController.text,
                    memo: _memoController.text));
          }
        }
      },
    );
  }

  Widget _buildCheckBoxFullDay() {
    return Expanded(
      flex: 3,
      child: ValueListenableBuilder(
        valueListenable: _fullDayNotifier,
        builder: (context, value, child) => CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            value: _fullDayNotifier.value,
            onChanged: (value) {
              _fullDayNotifier.value = value;
              if (value == true) {
                _hourStartNotifier.value = 8;
                _hourEndNotifier.value = 18;
                _minuteStartNotifier.value = minuteStart[0];
                _minuteEndNotifier.value = minuteEnd[0];
              }
            },
            title: Text('fullday'.tr(),
                style: const TextStyle(fontWeight: FontWeight.bold))),
      ),
    );
  }

  Widget _buildDate() {
    return Expanded(
        flex: 5,
        child: Row(children: [
          _buildDateText(text: 'date'),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: ValueListenableBuilder(
                      valueListenable: _dateNotifier,
                      builder: (context, value, child) => InkWell(
                          onTap: () => pickDate(
                              context: context,
                              firstDate: DateTime.now(),
                              date: _dateNotifier.value,
                              function: (selectedDate) =>
                                  _dateNotifier.value = selectedDate),
                          child: DecoratedBox(
                              decoration: BoxDecoration(
                                  color: backgroundPanel,
                                  borderRadius: BorderRadius.circular(32.r)),
                              child: Padding(
                                  padding: EdgeInsets.all(8.w),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.w),
                                          child: Text(
                                              FormatDateConstants
                                                  .convertddMMyyyy(_dateNotifier
                                                      .value
                                                      .toString()
                                                      .split(' ')
                                                      .first),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: colorPanel)),
                                        ),
                                        Icon(Icons.calendar_month,
                                            weight: 1, color: colorPanel)
                                      ])))))))
        ]));
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required String hint,
      bool? isRequired,
      required String label}) {
    return InputTextFieldNew(
        controller: controller,
        labelText: hint,
        isRequired: isRequired ?? false,
        validator: isRequired ?? false
            ? (value) {
                if (value!.isEmpty) {
                  return 'notempty'.tr();
                }
                return null;
              }
            : null);
  }

  Widget _buildFacilities({required List<FacilitiesResponse> facilitiesList}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 6, top: 6),
              child: TextRichRequired(label: "facilities".tr()),
            ),
            ValueListenableBuilder(
              valueListenable: _facilitiesNotifier,
              builder: (context, value, child) => DropdownButtonFormField2(
                validator: (value) {
                  if (value == null) {
                    return 'notempty'.tr();
                  }
                  return null;
                },
                isDense: true,
                isExpanded: true,
                hint: Text(
                  'facilities'.tr(),
                  style: LayoutCustom.hintStyle,
                ),
                items: facilitiesList
                    .map((item) => DropdownMenuItem<FacilitiesResponse>(
                        value: item,
                        child: Row(children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            height: 20,
                            width: 20,
                            color: item.colorCode == 'gray'
                                ? Colors.grey
                                : MyColor.getColor(item.colorCode ?? ''),
                          ),
                          Text(item.facilityDesc ?? '',
                              overflow: TextOverflow.ellipsis)
                        ])))
                    .toList(),
                value: facilitiesSelected,
                onChanged: (value) {
                  _facilitiesNotifier.value = value!.facilityCode!;
                  facilitiesSelected = value;
                },
                buttonStyleData: dropdown_custom.buttonStyleData,
                dropdownStyleData: dropdown_custom.dropdownStyleData,
                menuItemStyleData: dropdown_custom.menuItemStyleData,
              ),
            ),
          ],
        ),
      );

  Widget _buildFromTo({required String text}) => Expanded(
        flex: 1,
        child: Text(
          text.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
  Widget _buildDateText({required String text}) => Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Text(
          text.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
  Widget _buildDropdown(
      {required List<int> list,
      required ValueNotifier<int> valueNotifier,
      int? valueSelected,
      required bool isHour}) {
    return Expanded(
      flex: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
        ),
        child: ValueListenableBuilder(
          valueListenable: valueNotifier,
          builder: (context, value, child) => DropdownButton2(
              iconStyleData: const IconStyleData(
                  icon: Icon(Icons.arrow_drop_down_rounded)),
              isExpanded: true,
              hint: Row(
                children: [
                  Expanded(
                    child: Text(
                      valueSelected != null ? valueSelected.toString() : '',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              items: list
                  .map((item) => DropdownMenuItem<int>(
                        value: item,
                        child: Center(
                          child: Text(
                            item < 10 ? '0$item' : item.toString(),
                          ),
                        ),
                      ))
                  .toList(),
              selectedItemBuilder: (context) {
                return list.map(
                  (item) {
                    return Container(
                      alignment: AlignmentDirectional.center,
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: (valueSelected ?? hourStart[0]) < 10
                                ? '0$valueSelected'
                                : valueSelected.toString(),
                            style: _textStyle(),
                          ),
                          TextSpan(
                              text:
                                  '    ${isHour ? 'hours'.tr() : 'minutes'.tr()}',
                              style: const TextStyle(color: Colors.black))
                        ]),
                      ),
                    );
                  },
                ).toList();
              },
              value: valueSelected,
              onChanged: (value) {
                valueNotifier.value = value!;
                valueSelected = value;
              },
              dropdownStyleData: dropdown_custom.dropdownStyleData,
              menuItemStyleData: dropdown_custom.menuItemStyleData),
        ),
      ),
    );
  }

  Widget _buildTextFullDay({required int text, required bool isHour}) {
    return Expanded(
        flex: 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Center(
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: text < 10 ? '0$text' : text.toString(),
                  style: _textStyle(),
                ),
                TextSpan(
                    text: '    ${isHour ? 'hours'.tr() : 'minutes'.tr()}',
                    style: const TextStyle(color: Colors.black))
              ]),
            ),
          ),
        ));
  }

  TextStyle _textStyle() {
    return const TextStyle(
        color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold);
  }
}
