import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/data.dart';

part 'lang_event.dart';
part 'lang_state.dart';

class LangBloc extends Bloc<LangEvent, LangState> {
  LangBloc() : super(LangInitial()) {
    on<ChangeLang>(_mapChangeLang);
  }
  void _mapChangeLang(ChangeLang event, emit) async {
    try {
      switch (event.langChange) {
        case LanguageHelper.en:
          emit(const LangChangeLoadSuccess(lang: LanguageHelper.en));
          break;
        case LanguageHelper.vi:
          emit(const LangChangeLoadSuccess(lang: LanguageHelper.vi));
          break;
        default:
          emit(const LangChangeLoadSuccess(lang: LanguageHelper.en));
          break;
      }
    } catch (e) {
      emit();
    }
  }
}
