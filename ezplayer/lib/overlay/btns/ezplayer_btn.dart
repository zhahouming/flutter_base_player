part of '../../ezplayer.dart';

class EzplayerBtn extends StatelessWidget {
  final EzPlayer ezplayer;
  final String btnText;
  final String? title;
  final List<OverlaySelectItem> options;
  const EzplayerBtn({
    Key? key,
    required this.ezplayer,
    required this.btnText,
    required this.options,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EzplayerTextBtn(
      text: btnText,
      onPressed: () {
        ezplayer.showOverlay(
          alignment: Alignment.centerRight,
          builder: (context) => OverlaySelect(
            title: title,
            width: 280,
            list: options,
          ),
        );
      },
    );
  }
}
