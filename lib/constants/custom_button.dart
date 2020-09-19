import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String image;
  final Color color;
  final Color textcolor;
  final Icon icon;
  final VoidCallback onPressed;
  final String text;
  final double borderRadius;
  final TextStyle textStyle;
  final double width;

  CustomButton(
      {@required this.text,
        this.image,
        this.color,
        this.textcolor,
        this.icon,
        this.onPressed,
        this.borderRadius,
      this.textStyle,
      this.width,});
  Widget decider(){
    if(image==null&&icon==null)
      return SizedBox(height:0,);
    else if(image!=null)
      return Image.asset(image);
    else
      return icon;
  }
  @override
  Widget build(BuildContext context) {
    //print(icon);
    return SizedBox(
      height: 50,
      width: width,
      child: RaisedButton(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              decider(),
              Text(text, style:textStyle==null?TextStyle():textStyle),
              Opacity(
                opacity: 0.0,
                child: decider(),
              ),
            ],
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 0.0)),
        ),
        onPressed: onPressed ,
        color: color ?? Colors.white,
        //textColor: textcolor ?? Colors.black,
        padding: EdgeInsets.all(5),
      ),
    );
  }
}
