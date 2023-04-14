part of '../extension_widget.dart';

/// 通用盒模型样式定义
/// [marginAll]
///
class DivStyle {
  // required:
  double? minWidth;
  double? maxWidth;

  double? minHeight;
  double? maxHeight;

  double? marginAll;
  double? marginLR; // 左右
  double? marginTB; // 上下
  double? marginTop;
  double? marginBottom;
  double? marginLeft;
  double? marginRight;

  double? paddingAll;
  double? paddingLR;
  double? paddingTB;
  double? paddingTop;
  double? paddingBottom;
  double? paddingLeft;
  double? paddingRight;

  double? radiusAll; // 全部角
  double? radiusTL; // 左上
  double? radiusTR; // 右上
  double? radiusBL; // 左下
  double? radiusBR; // 右下

  // not required:
  double? height;
  double? width;

  Color? backgroundColor;
  Gradient? gradient;
  Border? border;
  List<BoxShadow>? boxShadow;
  Alignment? alignment;

  DivStyle({
    // 内容区域大小
    this.height,
    this.width,
    this.minWidth = 0.0,
    this.maxWidth = double.infinity,
    this.minHeight = 0.0,
    this.maxHeight = double.infinity,
    // 外边距
    this.marginAll,
    this.marginLR,
    this.marginTB,
    this.marginTop,
    this.marginBottom,
    this.marginLeft,
    this.marginRight,
    // 内边距
    this.paddingAll,
    this.paddingLR,
    this.paddingTB,
    this.paddingTop,
    this.paddingBottom,
    this.paddingLeft,
    this.paddingRight,
    // radius
    this.radiusAll,
    this.radiusTL,
    this.radiusTR,
    this.radiusBL,
    this.radiusBR,
    // 背景颜色
    this.backgroundColor,
    this.border,
    this.boxShadow,
    this.gradient,
    this.alignment,
  }) {
    getCalculatedStyle();
  }

  getCalculatedStyle() {
    marginLeft = getMarginAndPadding(marginAll, marginLR, marginLeft);
    marginRight = getMarginAndPadding(marginAll, marginLR, marginRight);
    marginTop = getMarginAndPadding(marginAll, marginTB, marginTop);
    marginBottom = getMarginAndPadding(marginAll, marginTB, marginBottom);

    paddingLeft = getMarginAndPadding(paddingAll, paddingLR, paddingLeft);
    paddingRight = getMarginAndPadding(paddingAll, paddingLR, paddingRight);
    paddingTop = getMarginAndPadding(paddingAll, paddingTB, paddingTop);
    paddingBottom = getMarginAndPadding(paddingAll, paddingTB, paddingBottom);

    radiusTL = getRadius(radiusAll, radiusTL);
    radiusTR = getRadius(radiusAll, radiusTR);
    radiusBL = getRadius(radiusAll, radiusBL);
    radiusBR = getRadius(radiusAll, radiusBR);
  }

  double getMarginAndPadding(all, lrtb, edge) {
    if (edge != null) return edge;
    if (lrtb != null) return lrtb;
    if (all != null) return all;
    return 0.0;
  }

  double getRadius(all, edge) {
    if (edge != null) return edge;
    if (all != null) return all;
    return 0.0;
  }
}

class Div extends StatelessWidget {
  final bool animate;
  final Widget? child;
  final DivStyle? style;
  const Div({
    Key? key,
    this.child,
    this.style,
    this.animate = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DivStyle divStyle = style ?? DivStyle();
    if (animate) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        alignment: style?.alignment,
        decoration: BoxDecoration(
          gradient: style?.gradient,
          borderRadius: (style?.border == null || divStyle.border!.isUniform)
              ? BorderRadius.only(
                  topLeft: Radius.circular(divStyle.radiusTL!),
                  topRight: Radius.circular(divStyle.radiusTR!),
                  bottomLeft: Radius.circular(divStyle.radiusBL!),
                  bottomRight: Radius.circular(divStyle.radiusBR!),
                )
              : null,
          // borderRadius: BorderRadius.all(Radius.circular(radius)),
          border: style?.border,
          color: style?.backgroundColor,
          boxShadow: style?.boxShadow,
        ),
        margin: EdgeInsets.only(
          top: divStyle.marginTop!,
          bottom: divStyle.marginBottom!,
          left: divStyle.marginLeft!,
          right: divStyle.marginRight!,
        ),
        padding: EdgeInsets.only(
          top: divStyle.paddingTop!,
          bottom: divStyle.paddingBottom!,
          left: divStyle.paddingLeft!,
          right: divStyle.paddingRight!,
        ),
        height: style?.height,
        width: style?.width,
        constraints: BoxConstraints(
          minWidth: divStyle.minWidth!,
          maxWidth: divStyle.maxWidth!,
          minHeight: divStyle.minHeight!,
          maxHeight: divStyle.maxHeight!,
        ),
        child: child,
      );
    }

    Decoration decoration = BoxDecoration(
      gradient: style?.gradient,
      borderRadius: (style?.border == null || divStyle.border!.isUniform)
          ? BorderRadius.only(
              topLeft: Radius.circular(divStyle.radiusTL!),
              topRight: Radius.circular(divStyle.radiusTR!),
              bottomLeft: Radius.circular(divStyle.radiusBL!),
              bottomRight: Radius.circular(divStyle.radiusBR!),
            )
          : null,
      border: style?.border,
      color: style?.backgroundColor,
      boxShadow: style?.boxShadow,
    );

    return Container(
      alignment: style?.alignment,
      decoration: decoration,
      margin: EdgeInsets.only(
        top: divStyle.marginTop!,
        bottom: divStyle.marginBottom!,
        left: divStyle.marginLeft!,
        right: divStyle.marginRight!,
      ),
      padding: EdgeInsets.only(
        top: divStyle.paddingTop!,
        bottom: divStyle.paddingBottom!,
        left: divStyle.paddingLeft!,
        right: divStyle.paddingRight!,
      ),
      height: style?.height,
      width: style?.width,
      constraints: BoxConstraints(
        minWidth: divStyle.minWidth!,
        maxWidth: divStyle.maxWidth!,
        minHeight: divStyle.minHeight!,
        maxHeight: divStyle.maxHeight!,
      ),
      child: child,
    );
  }
}
