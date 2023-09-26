import 'package:flutter/material.dart';

class NoItemFound extends StatelessWidget {
  final String name;
  final Function? onReload;

  const NoItemFound({Key? key, required this.name, this.onReload}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if(onReload != null)
          IconButton(
              onPressed: () => onReload!(),
              icon: const Icon(
                Icons.sync,
                size: 48,
              )),
          const SizedBox(
            height: 12,
          ),
          Text('No $name found!',
              style: TextStyle(
                  color: Colors.black.withOpacity(0.6),
                  fontSize: 16))
        ],
      ),
    );
  }
}
