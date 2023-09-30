import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ssmis_tz/app/screens/declaration/add_packaging.dart';

class PackagingStep extends StatefulWidget {
  final List<Map<String, dynamic>> requestPremises;
  final Function onPackageStepComplete;

  const PackagingStep(
      {Key? key,
      required this.requestPremises,
      required this.onPackageStepComplete})
      : super(key: key);

  @override
  State<PackagingStep> createState() => _PackagingStepState();
}

class _PackagingStepState extends State<PackagingStep> {
  int _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      key: Key(Random().nextInt(4).toString()),
        elevation: 0,
        children: widget.requestPremises
            .asMap()
            .entries
            .map((e) => ExpansionPanel(

                isExpanded: e.key == _activeIndex,
                headerBuilder: (BuildContext context, bool isExpanded) =>
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(e.value['premiseName']),
                    ),
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AddPackaging(
                    index: e.key,
                    declarationPremise: e.value,
                    onPackageStepSaved: (index) => {
                      if (index < widget.requestPremises.length - 1)
                        {setState(() => _activeIndex++)}
                      else
                        {widget.onPackageStepComplete(true)}
                    },
                  ),
                )))
            .toList());
  }
}
