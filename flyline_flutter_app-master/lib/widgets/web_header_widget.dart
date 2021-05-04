import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:motel/widgets/svg_image_widget.dart';

class WebHeaderWidget extends StatefulWidget {

  WebHeaderWidget({
    Key key, 
    this.leftButton,
    this.rightButton}) : super(key: key);

  final Widget leftButton;
  final Widget rightButton;

  @override
  State<StatefulWidget> createState() {
    return _WebHeaderWidgetState();
  }
}

class _WebHeaderWidgetState extends State<WebHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72.h,
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                    left: 43.w,
                  ),
                  child: widget.leftButton
                ),
                SizedBox(
                  width: 26.w
                ),
                Container(
                  child: WebAppIcon()
                ),
                Spacer(),
                widget.rightButton,
                SizedBox(
                  width: 46
                )
              ],
            ),
          ),
          Container(
            height: 1,
            color: Color.fromRGBO(229, 229, 229, 0.5)
          )
        ],
      ),
    );
  }
}

class WebAppIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return buildWebAppIconWidget();
  }

  Widget buildWebAppIconWidget() {
    return Container(
      width: 47.h,
      height: 47.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(6.w)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0),
            blurRadius: 1.0,
          ),
        ]
      ),
      child: Container(
        child: SvgImageWidget.asset(
          'assets/svg/email_icon.svg',
          width: 28.h,
        ),
      ),
    );
  }
}