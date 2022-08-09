import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:playground_app/values/k_colors.dart';
import 'package:playground_app/values/k_values.dart';

// ignore: must_be_immutable
class DrawSignature extends StatefulWidget {
  final String cleanLabel;
  final double borderRadius;
  final double height;
  final Color colorSignature;
  ByteData? result;

  DrawSignature(
      {Key? key,
      required this.cleanLabel,
      this.borderRadius = 30,
      this.height = 150,
      this.colorSignature = KPrimary,
      this.result})
      : super(key: key);

  @override
  _DrawSignatureState createState() => _DrawSignatureState();
}

class _DrawSignatureState extends State<DrawSignature> {
  var strokeWidth = 2.5;
  bool hasClean = false;
  final _sign = GlobalKey<SignatureState>();

  @override
  Widget build(BuildContext context) {
    widget.result = ByteData(0);

    return Stack(
      children: [
        Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.all(Radius.circular(widget.borderRadius)),
            boxShadow: const [
              BoxShadow(
                color: Color(0xFF707070),
                spreadRadius: -5,
                blurRadius: 10,
                offset: Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius:
                BorderRadius.all(Radius.circular(widget.borderRadius)),
            child: Signature(
              color: widget.colorSignature,
              key: _sign,
              onSign: () {
                // ignore: unused_local_variable
                final sign = _sign.currentState;
                setState(() {
                  hasClean = true;
                });
              },
              backgroundPainter: null,
              strokeWidth: strokeWidth,
            ),
          ),
        ),
        Visibility(
          visible: hasClean,
          child: Positioned.fill(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15, right: 25),
                child: GestureDetector(
                  onTap: () {
                    final sign = _sign.currentState;
                    sign!.clear();
                    setState(() {
                      widget.result = ByteData(0);
                      hasClean = false;
                    });
                  },
                  child: Material(
                    type: MaterialType.transparency,
                    child: Text(
                      widget.cleanLabel,
                      style: const TextStyle(
                        color: KPrimary_L1,
                        fontWeight: FontWeight.normal,
                        fontSize: KFontSizeXLarge45,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
