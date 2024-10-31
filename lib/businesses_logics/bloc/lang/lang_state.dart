part of 'lang_bloc.dart';

abstract class LangState extends Equatable {
  const LangState();

  @override
  List<Object> get props => [];
}

class LangInitial extends LangState {}

class LangChangeLoadSuccess extends LangState {
  final String lang;
  const LangChangeLoadSuccess({
    required this.lang,
  });
  @override
  List<Object> get props => [lang];
}
