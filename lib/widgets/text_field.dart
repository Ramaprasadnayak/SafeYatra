import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final double height, width;
  final TextEditingController controller;
  final String hintText;
  final bool eyebutton, hideText;
  final Widget prefixicon;
  const MyTextField({
    super.key,
    required this.hintText, 
    required this.height,
    required this.width,
    required this.prefixicon,
    required this.controller,
    required this.eyebutton,
    required this.hideText,
  });

  @override
  State<MyTextField> createState() => _TextFieldState();
}

class _TextFieldState extends State<MyTextField> {
  late bool isvisible;
  @override
  void initState() {
    super.initState();
    isvisible = widget.hideText;
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).textTheme.bodyMedium?.color,
        ),
        obscureText: isvisible,
        controller: widget.controller,
        decoration: InputDecoration(
          prefixIcon: widget.prefixicon,
          hintText: widget.hintText,
          hintStyle: Theme.of(context).inputDecorationTheme.hintStyle?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: Theme.of(
              context,
            ).inputDecorationTheme.enabledBorder!.borderSide,
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: Theme.of(
              context,
            ).inputDecorationTheme.focusedBorder!.borderSide,
          ),
          suffixIcon: widget.eyebutton
              ? IconButton(
                  icon: Icon(
                    isvisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 22,
                    color: Theme.of(context).inputDecorationTheme.suffixIconColor,
                  ),
                  onPressed: () {
                    setState(() {
                      isvisible = !isvisible;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}