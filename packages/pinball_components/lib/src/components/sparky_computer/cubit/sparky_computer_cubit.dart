// ignore_for_file: public_member_api_docs

import 'package:bloc/bloc.dart';

part 'sparky_computer_state.dart';

class SparkyComputerCubit extends Cubit<SparkyComputerState> {
  SparkyComputerCubit() : super(SparkyComputerState.withoutBall);

  void onBallEntered() {
    emit(SparkyComputerState.withBall);
  }

  void onBallTurboCharged() {
    emit(SparkyComputerState.withoutBall);
  }
}
