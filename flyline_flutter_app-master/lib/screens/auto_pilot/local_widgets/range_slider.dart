import 'dart:math';

import 'package:flutter/material.dart';
import 'package:motel/theme/appTheme.dart';

import 'slider.dart';

/// Author: Ali Dali
/// Last Updated: 28-07-2020

class RangeValue {
  final double start;
  final double end;

  RangeValue({@required this.start, @required this.end});
}

class BarRangeSlider extends StatefulWidget {
  final double sliderWidth;
  final double sliderHeight;
  final ValueChanged<RangeValue> onChanged;
  final int minValue;
  final int maxValue;

  const BarRangeSlider(
      {Key key,
      @required this.sliderWidth,
      this.sliderHeight,
      @required this.onChanged,
      @required this.minValue,
      @required this.maxValue})
      : super(key: key);

  @override
  _BarRangeSliderState createState() => _BarRangeSliderState();
}

class _BarRangeSliderState extends State<BarRangeSlider> {
  static double barWidth = 20.0;
  double _dragPositionStart = 0.0;
  double _dragPositionEnd = barWidth + 4;
  double _dragPercentageStart = 0.0;
  double _dragPercentageEnd = 0.0;

  int _minRange = 0;
  int _maxRange = 0;

  int _numberOfBars = 0;

  List<int> bars = [];

  @override
  void initState() {
    super.initState();

    Random r = Random(20);
    _numberOfBars = ((widget.sliderWidth) / barWidth).round() - 2;

    print(_numberOfBars);
    for (var i = 0; i <= _numberOfBars; i++) {
      bars.add(10 + r.nextInt(200));
    }

    _dragPercentageEnd = _dragPositionEnd / (widget.sliderWidth - barWidth);
    _dragPercentageStart = _dragPositionStart / (widget.sliderWidth - barWidth);

    if (mounted) {
      _calculateMin();
      _calculateMax();
    }
  }

  void _calculateMin() {
    int total = widget.maxValue - widget.minValue;

    setState(() {
      _minRange = (_dragPercentageStart * total).round();
      _minRange = _minRange + widget.minValue;
    });
  }

  void _calculateMax() {
    int total = widget.maxValue - widget.minValue;

    setState(() {
      _maxRange = (_dragPercentageEnd * total).round();
      _maxRange = _maxRange + widget.minValue;
    });
  }

  void _updateDragPositionStart(Offset val) {
    double newDragPosition = 0.0;
    if (val.dx <= 0.0) {
      newDragPosition = 0.0;
    } else if (val.dx >= widget.sliderWidth - barWidth) {
      newDragPosition = widget.sliderWidth - barWidth;
    } else if (val.dx >= _dragPositionEnd - barWidth) {
      newDragPosition = _dragPositionEnd - barWidth;
    } else {
      newDragPosition = val.dx;
    }

    setState(() {
      _dragPositionStart = newDragPosition;
      _dragPercentageStart =
          _dragPositionStart / (widget.sliderWidth - barWidth);
    });
  }

  void _updateDragPositionEnd(Offset val) {
    double newDragPosition = 0.0;
    if (val.dx <= 0.0) {
      newDragPosition = 0.0;
    } else if (val.dx >= widget.sliderWidth - barWidth) {
      newDragPosition = widget.sliderWidth - barWidth;
    } else if (val.dx <= _dragPositionStart + barWidth) {
      newDragPosition = _dragPositionStart + barWidth;
    } else {
      newDragPosition = val.dx;
    }

    setState(() {
      _dragPositionEnd = newDragPosition;
      _dragPercentageEnd = _dragPositionEnd / (widget.sliderWidth - barWidth);
    });
    //  print('drag position: ' + _dragPositionEnd.toString());
  }

  _handleChanged(RangeValue val) {
    assert(widget.onChanged != null);
    widget.onChanged(val);
  }

  void _onDragUpdateStart(BuildContext context, DragUpdateDetails update) {
    RenderBox box = context.findRenderObject();
    Offset localOffset = box.globalToLocal(update.globalPosition);

    _updateDragPositionStart(localOffset);
    _calculateMin();

    _handleChanged(
        RangeValue(start: _minRange.toDouble(), end: _maxRange.toDouble()));
  }

  void _onDragUpdateEnd(BuildContext context, DragUpdateDetails update) {
    RenderBox box = context.findRenderObject();
    Offset localOffset = box.globalToLocal(update.globalPosition);

    _updateDragPositionEnd(localOffset);
    _calculateMax();
    _handleChanged(
        RangeValue(start: _dragPercentageStart, end: _dragPercentageEnd));
  }

  @override
  Widget build(BuildContext context) {
    int i = 0;
    _numberOfBars++;

    return Container(
      width: widget.sliderWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 16),
          Text(
            'Range : \$$_minRange - \$$_maxRange',
            style: Theme.of(context).textTheme.caption.copyWith(
                color: Color.fromRGBO(0, 174, 239, 1),
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: bars.map((int height) {
                Color color =
                    i >= _dragPositionStart / 20 && i <= _dragPositionEnd / 20
                        ? HexColor('#00aeef')
                        : HexColor('#00aeef').withOpacity(0.3);
                i++;

                print(
                    ((barWidth / widget.sliderWidth) / 3) * widget.sliderWidth);

                return Container(
                    margin: EdgeInsets.only(
                        bottom: 8,
                        left: ((barWidth / widget.sliderWidth) / 3) *
                            widget.sliderWidth,
                        right: ((barWidth / widget.sliderWidth) / 3) *
                            widget.sliderWidth),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    height: height.toDouble() / 5,
                    width: ((barWidth / widget.sliderWidth) / 3) *
                        widget.sliderWidth);
              }).toList(),
            ),
          ),
          Container(
            height: 20,
            width: widget.sliderWidth,
            child: Stack(children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: HexColor('#00aeef').withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10)),
                  height: 6,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              SliderCircle(
                width: barWidth,
                position: _dragPositionStart,
                callback: (DragUpdateDetails update) {
                  _onDragUpdateStart(context, update);
                },
              ),
              SliderCircle(
                width: barWidth,
                position: _dragPositionEnd,
                callback: (DragUpdateDetails update) {
                  _onDragUpdateEnd(context, update);
                },
              ),
            ]),
          )
        ],
      ),
    );
  }
}
