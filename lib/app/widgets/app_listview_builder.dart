import 'package:flutter/material.dart';

class AppListviewBuilder extends StatelessWidget {
  final String title;
  final Function onTap;
  final bool disabled;
  final int itemnumber;
  const AppListviewBuilder({Key? key, required this.title, required this.onTap,this.disabled = false, required this.itemnumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
    shrinkWrap: true,
    itemBuilder: (context, index) {
          return Column(
            children: [
              Card(
                elevation: 2,
                child: ListTile(
                  onTap: disabled ? null : () => onTap(),
                  title: Text(title),
          ),
              ),
            ],
          );
    },
    itemCount: itemnumber != 0 ? itemnumber : null,
    );
  }
}
