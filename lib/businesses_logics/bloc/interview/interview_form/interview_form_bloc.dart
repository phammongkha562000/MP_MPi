import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpi_new/data/data.dart';

part 'interview_form_event.dart';
part 'interview_form_state.dart';

class InterviewFormBloc extends Bloc<InterviewFormEvent, InterviewFormState> {
  InterviewFormBloc() : super(InterviewFormInitial()) {
    on<InterviewFormLoaded>(_mapViewToState);
  }

  Future<void> _mapViewToState(InterviewFormLoaded event, emit) async {
    try {
      emit(InterviewFormLoading());
      emit(InterviewFormLoadSuccess(
          form: event.form, interviewApproval: event.interviewApproval));
    } catch (e) {
      emit(InterviewFormLoadFailure(message: e.toString()));
    }
  }
}
