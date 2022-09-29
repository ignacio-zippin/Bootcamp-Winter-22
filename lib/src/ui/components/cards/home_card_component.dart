import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:playground_app/values/k_colors.dart';
import 'package:playground_app/values/k_values.dart';

class HomeCardComponent extends StatefulWidget {
  final double width;
  final double height;
  final String? title;
  final int? titleMaxLines;
  final TextStyle? titleStyle;
  final RichText? titleRich;
  final String? subtitle1;
  final int? subtitle1MaxLines;
  final TextStyle? subtitle1Style;
  final String? imagePath;
  final void Function()? onCardTap;

  const HomeCardComponent({
    Key? key,
    this.width = 0,
    this.height = 0,
    this.title,
    this.titleStyle,
    this.titleRich,
    this.titleMaxLines,
    this.subtitle1,
    this.subtitle1Style,
    this.subtitle1MaxLines,
    this.imagePath,
    this.onCardTap,
  }) : super(key: key);

  @override
  _HomeCardComponentState createState() => _HomeCardComponentState();
}

class _HomeCardComponentState extends State<HomeCardComponent> {
  double? _width;
  double? _height;
  GlobalKey stickyKey = GlobalKey();
  Size? containerSize;
  bool isFavorite = false;
  double borderRadius = 20;
  Color arrowIconBorderColor = KPrimary;

  void postFrameCallback(_) {
    var context = stickyKey.currentContext;
    if (context == null) return;

    var newSize = context.size;
    if (containerSize == newSize) return;

    setState(() {
      containerSize = newSize;
    });
  }

  @override
  void initState() {
    super.initState();
    containerSize = null;
    SchedulerBinding.instance!.addPostFrameCallback(postFrameCallback);
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    SchedulerBinding.instance!.addPostFrameCallback(postFrameCallback);
  }

  @override
  Widget build(BuildContext context) {
    _width =
        widget.width != 0 ? widget.width : MediaQuery.of(context).size.width;
    _height = widget.height != 0.0
        ? widget.height
        : MediaQuery.of(context).size.width * 0.36;

    return GestureDetector(
      onTap: () {
        if (widget.onCardTap != null) {
          widget.onCardTap!();
        }
      },
      child: Material(
        elevation: 2.5,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          constraints: BoxConstraints(minHeight: _height!, maxWidth: _width!),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Expanded(
              flex: 4,
              child: _cardBody(),
            ),
            Expanded(
              child: _image(),
              flex: 3,
            )
          ]),
        ),
      ),
    );
  }

  _image() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius)),
      child: Container(
        child: widget.imagePath != null
            ? Image.asset(
                widget.imagePath!,
                height: _height,
                fit: BoxFit.cover,
              )
            : null,
      ),
    );
  }

  _cardBody() {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _title(),
          _subtitle1(),
        ],
      ),
    );
  }

  _title() {
    return Visibility(
      visible: widget.title != null || widget.titleRich != null,
      child: widget.titleRich ?? _labelTitle(widget.title!, widget.titleStyle),
    );
  }

  _subtitle1() {
    return Visibility(
      visible: widget.subtitle1 != null,
      child: Column(
        children: [
          const SizedBox(height: 5),
          Row(
            children: [
              _label(widget.subtitle1, widget.subtitle1Style,
                  widget.subtitle1MaxLines),
            ],
          ),
        ],
      ),
    );
  }

  _labelTitle(String label, TextStyle? style) {
    return Text(
      label,
      textAlign: TextAlign.start,
      softWrap: true,
      maxLines: widget.titleMaxLines ?? 1,
      overflow: TextOverflow.ellipsis,
      style: style != null
          ? TextStyle(
              color: style.color ?? KGrey,
              fontWeight: style.fontWeight ?? FontWeight.w500,
              fontSize: style.fontSize ?? KFontSizeXLarge45,
            )
          : const TextStyle(
              color: KGrey,
              fontWeight: FontWeight.w500,
              fontSize: KFontSizeXLarge45,
            ),
    );
  }

  _label(String? label, TextStyle? style, int? maxLines) {
    return Flexible(
      child: Text(
        label?? "",
        textAlign: TextAlign.start,
        softWrap: true,
        maxLines: maxLines ?? 1,
        overflow: TextOverflow.ellipsis,
        style: style != null
            ? TextStyle(
                color: style.color ?? KGrey,
                fontFamily: style.fontFamily ?? 'Sans',
                fontWeight: style.fontWeight ?? FontWeight.normal,
                fontSize: style.fontSize ?? KFontSizeMedium35,
              )
            : const TextStyle(
                color: KGrey,
                fontWeight: FontWeight.normal,
                fontSize: KFontSizeMedium35,
              ),
      ),
    );
  }
}
