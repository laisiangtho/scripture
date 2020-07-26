part of 'main.dart';

mixin _Gesture on _State {
  double setChapterDrag;
  double initialX;
  double initialY;
  double dragDistance;

  Widget chapterGesture({Widget child}) {
    return Stack(
      children: <Widget>[
        chapterGestureDetector(
          child: child
        )
      ],
    );
  }

  Widget chapterGestureDetector({Widget child}) {
    return GestureDetector(
      child: child,
      onHorizontalDragStart:(e){
        initialX = e.globalPosition.dx;
      },
      onHorizontalDragUpdate:(e){
        dragDistance = e.localPosition.dx - initialX;
        if (e.delta.dx < 0) dragDistance = initialX - e.localPosition.dx;
        if (dragDistance >= 50.0){
          // initialX = e.localPosition.dx;
          setChapterDrag = e.delta.dx;
        }
      },
      // onHorizontalDragCancel: (){},
      onHorizontalDragEnd:(e){
        if (dragDistance >= 50.0){
          if (setChapterDrag > 0) setChapterPrevious(); else setChapterNext();
        }
      }
    );
  }
}