sealed class AppSectionState {}

class AppSectionInitial extends AppSectionState {}

class AppSectionChanged extends AppSectionState {
  final int currentIndex;

  AppSectionChanged(this.currentIndex);
}