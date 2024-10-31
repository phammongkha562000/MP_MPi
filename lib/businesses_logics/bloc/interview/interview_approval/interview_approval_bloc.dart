import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpi_new/data/services/result/api_result.dart';

import '../../../../data/data.dart';
import '../../../application_bloc/app_bloc.dart';

part 'interview_approval_event.dart';
part 'interview_approval_state.dart';

class InterviewApprovalBloc
    extends Bloc<InterviewApprovalEvent, InterviewApprovalState> {
  final _interviewRepo = getIt<InterviewRepository>();

  int pageNumber = 1;
  bool endPage = false;
  int quantity = 0;
  List<InterviewApprovalResult> interviewLst = [];
  InterviewApprovalBloc() : super(InterviewApprovalInitial()) {
    on<InterviewApprovalLoaded>(_mapViewToState);
    on<InterviewApprovalPaging>(_mapPagingToState);
  }
  void _mapViewToState(InterviewApprovalLoaded event, emit) async {
    try {
      emit(InterviewApprovalLoading());
      interviewLst.clear();
      pageNumber = 1;
      endPage = false;
      quantity = 0;
      final content = await _getContentInterview();
      ApiResult apiResult =
          await _interviewRepo.getInterviewAppr(content: content);
      if (apiResult.isFailure) {
        emit(InterviewApprovalFailure(message: apiResult.getErrorMessage()));
        return;
      }
      ApiResponse apiResponse = apiResult.data;
      if (apiResponse.success == false) {
        emit(InterviewApprovalFailure(message: apiResponse.error.errorMessage));
        return;
      }
      InterviewApprovalResponse interviewRes = apiResponse.payload;
      List<InterviewApprovalResult> listInterView = interviewRes.result ?? [];
      interviewLst.addAll(listInterView);
      quantity = interviewRes.totalRecord ?? 0;
      emit(InterviewApprovalLoadSuccess(
        listInterview: listInterView,
        quantity: quantity,
      ));
    } catch (e) {
      emit(InterviewApprovalFailure(message: e.toString()));
    }
  }

  Future<void> _mapPagingToState(InterviewApprovalPaging event, emit) async {
    try {
      if (quantity == interviewLst.length) {
        endPage = true;
        return;
      }
      if (endPage == false) {
        emit(InterviewApprovalPagingLoading());
        pageNumber++;
        final content = await _getContentInterview();

        ApiResult apiResult =
            await _interviewRepo.getInterviewAppr(content: content);
        if (apiResult.isFailure) {
          emit(InterviewApprovalFailure(message: apiResult.getErrorMessage()));
          return;
        }
        ApiResponse apiResponse = apiResult.data;
        if (apiResponse.success == false) {
          emit(InterviewApprovalFailure(
              message: apiResponse.error.errorMessage));
          return;
        }
        InterviewApprovalResponse interviewRes = apiResponse.payload;
        List<InterviewApprovalResult> listInterView = interviewRes.result ?? [];
        if (listInterView.isNotEmpty && listInterView != []) {
          interviewLst.addAll(listInterView);
        } else {
          endPage = true;
        }

        emit(InterviewApprovalPagingSuccess(
          listInterview: interviewLst,
        ));
      }
    } catch (e) {
      emit(InterviewApprovalFailure(message: e.toString()));
    }
  }

  Future<InterviewApprovalRequest> _getContentInterview() async {
    final sharedPref = await SharedPreferencesService.instance;

    return InterviewApprovalRequest(
        employeeId: globalUser.getEmployeeId.toString(),
        susidiaryId: sharedPref.subsidiaryId ?? '',
        dateF: DateFormat(MyConstants.yyyyMMdd)
            .format(DateTime.now().subtract(const Duration(days: 5))),
        dateT: DateFormat(MyConstants.yyyyMMdd)
            .format(DateTime.now().add(const Duration(days: 5))),
        pageNumber: pageNumber,
        rowNumber: MyConstants.pagingSize);
  }
}
