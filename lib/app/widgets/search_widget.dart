import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final Function(String)? onChange;
  final String? hint;
  const SearchWidget({super.key,this.onChange,this.hint});

  @override
  Widget build(BuildContext context) {
    return   Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                        onChanged: onChange,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: hint,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                      
                      
                        ),
                      ),
                    );
  }
}