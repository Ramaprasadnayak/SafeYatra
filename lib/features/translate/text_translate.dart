import 'package:flutter/material.dart';

class TextTranslate extends StatefulWidget {
  final String text;
  final Function(String) onChange;
  const TextTranslate({super.key,required this.text,required this.onChange});

  @override
  State<TextTranslate> createState() => _TextTranslateState();
}

class _TextTranslateState extends State<TextTranslate> {
  TextEditingController input = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        height: 300, 
        child:  Padding(
          padding: EdgeInsets.all(12.0),
          child: TextField(
            onChanged:widget.onChange,
            expands: true,
            maxLines: null,
            minLines: null,
            textAlignVertical: TextAlignVertical.top,
            decoration: InputDecoration(
              border: InputBorder.none, 
              hintText: "Text..",
              hintStyle: TextStyle(color: Colors.white54),
            ),
          ),
        ),
      ),
    );
  }
}
