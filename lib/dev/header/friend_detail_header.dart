import 'package:flutter/material.dart';
import 'package:msu_chat_app/constants/myconstants.dart';
import 'package:msu_chat_app/dev/header/diagonally_cut_colored_image.dart';

class FriendDetailHeader extends StatelessWidget {
  static const BACKGROUND_IMAGE = SportsConstants.BACKGROUND_IMAGE;

  Widget _buildDiagonalImageBackground(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return new DiagonallyCutColoredImage(
      new Image.asset(
        BACKGROUND_IMAGE,
        width: screenWidth,
        height: 280.0,
        fit: BoxFit.cover,
      ),
      color: const Color(0xBB8338f4),
    );
  }

  Widget _buildAvatar() {
    return new Hero(
      tag: 'hero',
      child: new CircleAvatar(
        backgroundImage: new AssetImage(SportsConstants.DEV_WEB),
        radius: 50.0,
      ),
    );
  }

  Widget _buildFollowerInfo(TextTheme textTheme) {
    var followerStyle =
        textTheme.subhead.copyWith(color: const Color(0xBBFFFFFF));

    return new Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text('+5 years Experience', style: followerStyle),
          new Text(
            ' | ',
            style: followerStyle.copyWith(
                fontSize: 24.0, fontWeight: FontWeight.normal),
          ),
          new Text('+100 Projects Finished', style: followerStyle),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return new Padding(
      padding: const EdgeInsets.only(
        top: 16.0,
        left: 16.0,
        right: 16.0,
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _createPillButton(
            'HIRE ME',
            backgroundColor: Colors.blue,
          ),
          new DecoratedBox(
            decoration: new BoxDecoration(
              border: new Border.all(color: Colors.white30),
              borderRadius: new BorderRadius.circular(30.0),
            ),
            child: _createPillButton(
              'FOLLOW',
              textColor: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _createPillButton(
    String text, {
    Color backgroundColor = Colors.transparent,
    Color textColor = Colors.white70,
  }) {
    return new ClipRRect(
      borderRadius: new BorderRadius.circular(30.0),
      child: new MaterialButton(
        minWidth: 140.0,
        color: backgroundColor,
        textColor: textColor,
        onPressed: () {},
        child: new Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    return new Stack(
      children: <Widget>[
        _buildDiagonalImageBackground(context),
        new Align(
          alignment: FractionalOffset.center,
          heightFactor: 1.4,
          child: new Column(
            children: <Widget>[
              _buildAvatar(),
              _buildFollowerInfo(textTheme),
              _buildActionButtons(theme),
            ],
          ),
        ),
//        new Positioned(
//          top: 26.0,
//          left: 4.0,
//          child: new BackButton(color: Colors.white),
//        ),
      ],
    );
  }
}
