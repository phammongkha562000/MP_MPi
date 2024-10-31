part of 'lang_bloc.dart';

abstract class LangEvent extends Equatable {
  const LangEvent();

  @override
  List<Object> get props => [];
}

class ChangeLang extends LangEvent {
  final String langChange;
  const ChangeLang({
    required this.langChange,
  });
}
