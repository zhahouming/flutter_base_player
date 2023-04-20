part of '../extension_widget.dart';

class BlurDiv extends StatelessWidget {
  final bool animate;
  final double blur;
  final Widget? child;
  final DivStyle? style;
  const BlurDiv({
    Key? key,
    this.child,
    this.blur = 14,
    this.style,
    this.animate = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DivStyle divStyle = style ?? DivStyle();
    if (animate) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 1000),
        constraints: BoxConstraints(
          maxHeight: divStyle.maxHeight!,
          minHeight: divStyle.minHeight!,
          maxWidth: divStyle.maxWidth!,
          minWidth: divStyle.minWidth!,
        ),
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular(divStyle.radiusAll ?? 0)),
          border: style?.border ??
              Border.all(
                width: .5,
                color: const Color.fromRGBO(255, 255, 255, 0.3),
              ),
        ),
        margin: EdgeInsets.only(
          top: divStyle.marginTop!,
          bottom: divStyle.marginBottom!,
          left: divStyle.marginLeft!,
          right: divStyle.marginRight!,
        ),
        height: divStyle.height,
        width: divStyle.width,
        child: Container(
          decoration: BoxDecoration(
            color: style?.backgroundColor,
            boxShadow: style?.boxShadow,
          ),
          alignment: style?.alignment,
          padding: EdgeInsets.only(
            top: divStyle.paddingTop!,
            bottom: divStyle.paddingBottom!,
            left: divStyle.paddingLeft!,
            right: divStyle.paddingRight!,
          ),
          child: child,
        ).backgroundBlur(blur).clipRRect(all: divStyle.radiusAll),
      );
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.all(Radius.circular(divStyle.radiusAll ?? 0)),
        border: style?.border ??
            Border.all(
              width: .5,
              color: const Color.fromRGBO(255, 255, 255, 0.3),
            ),
      ),
      constraints: BoxConstraints(
        maxHeight: divStyle.maxHeight!,
        minHeight: divStyle.minHeight!,
        maxWidth: divStyle.maxWidth!,
        minWidth: divStyle.minWidth!,
      ),
      margin: EdgeInsets.only(
        top: divStyle.marginTop!,
        bottom: divStyle.marginBottom!,
        left: divStyle.marginLeft!,
        right: divStyle.marginRight!,
      ),
      height: divStyle.height,
      width: divStyle.width,
      child: Container(
        decoration: BoxDecoration(
          color: style?.backgroundColor,
          boxShadow: style?.boxShadow,
        ),
        alignment: style?.alignment,
        padding: EdgeInsets.only(
          top: divStyle.paddingTop!,
          bottom: divStyle.paddingBottom!,
          left: divStyle.paddingLeft!,
          right: divStyle.paddingRight!,
        ),
        child: child,
      ).backgroundBlur(blur).clipRRect(all: divStyle.radiusAll),
    );
  }
}
