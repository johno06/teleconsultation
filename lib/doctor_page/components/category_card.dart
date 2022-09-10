import 'package:flutter/material.dart';
import '../../constant.dart';

//ignore: must_be_immutable
class DoctorCategoryCard extends StatelessWidget {
  dynamic _title;
  dynamic _imageUrl;
  dynamic _bgColor;
  // dynamic _pemail;

  DoctorCategoryCard(this._title, this._imageUrl, this._bgColor, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      height: 160,
      child: Stack(
        children: <Widget>[
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: 110,
              height: 137,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  _title,
                  style: TextStyle(
                    color: kTitleTextColor,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: Container(
              height: 84,
              width: 84,
              decoration: BoxDecoration(
                color: _bgColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Image.asset(
                _imageUrl,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
