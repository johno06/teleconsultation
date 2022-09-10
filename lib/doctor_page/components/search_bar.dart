import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constant.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            color: kSearchBackgroundColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: const TextField(
            decoration: InputDecoration.collapsed(
              hintText: 'Search',
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: MaterialButton(
            onPressed: () {},
            color: kOrangeColor,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 15,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: SvgPicture.asset('assets/icons/search.svg'),
          ),
        ),
      ],
    );
  }
}
