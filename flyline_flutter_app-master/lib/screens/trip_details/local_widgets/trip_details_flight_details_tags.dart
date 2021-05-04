import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_builder/responsive_builder.dart';

class TripDetailsFlightDetailsTags extends StatelessWidget {
  const TripDetailsFlightDetailsTags({
    Key key,
    @required this.tags,
  }) : super(key: key);

  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: Padding(
        padding: const EdgeInsets.only(top: 20.0, right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: tags
              .map(
                (tag) => Expanded(
                  child: Container(
                    width: 80,
                    height: 27,
                    margin: EdgeInsets.only(right: 10),
                    padding: EdgeInsets.only(top: 6, left: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: const Color(0xfff7f9fc),
                    ),
                    child: // 15h 56m
                        SizedBox(
                      width: 50,
                      height: 16,
                      child: Text(
                        tag,
                        style: const TextStyle(
                          color: const Color(0xff0e3178),
                          fontWeight: FontWeight.w700,
                          fontFamily: "Gilroy",
                          fontStyle: FontStyle.normal,
                          fontSize: 12.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
      desktop: Padding(
        padding: EdgeInsets.only(top: 4.w, right: 22.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: tags
              .map(
                (tag) => Container(
                    margin: EdgeInsets.only(right: 5.w),
                    padding: EdgeInsets.symmetric(vertical: 7.w, horizontal: 17.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.w)),
                      color: const Color(0xfff7f9fc),
                    ),
                    child:
                        Text(
                        tag,
                        style: TextStyle(
                          color: const Color(0xff0e3178),
                          fontWeight: FontWeight.w700,
                          fontFamily: "Gilroy",
                          fontStyle: FontStyle.normal,
                          fontSize: 8.w,
                        ),
                        textAlign: TextAlign.center,
                      ),
                  ),
              )
              .toList(),
        ),
      ),
    );
  }
}
