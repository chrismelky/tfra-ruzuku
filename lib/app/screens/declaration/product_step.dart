import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:ssmis_tz/app/api/api.dart';
import 'package:ssmis_tz/app/providers/stock_declaration_provider.dart';
import 'package:ssmis_tz/app/widgets/app_button.dart';
import 'package:ssmis_tz/app/widgets/app_fetcher.dart';
import 'package:ssmis_tz/app/widgets/app_form.dart';
import 'package:ssmis_tz/app/widgets/app_input_dropdown.dart';
import 'package:ssmis_tz/app/widgets/app_input_number.dart';

class ProductStep extends StatefulWidget {
  final Map<String, dynamic> formValues;
  final Function? onNextStep;

  const ProductStep({Key? key, required this.formValues, this.onNextStep})
      : super(key: key);

  @override
  State<ProductStep> createState() => _ProductStepState();
}

class _ProductStepState extends State<ProductStep> {
  final _productForm = GlobalKey<FormBuilderState>();
  List<Map<String, dynamic>> products = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
  }

  loadProduct(int cropId) async {
    var resp = await Api().dio.get("/crop-products?cropId=$cropId");
    if (resp.statusCode == 200) {
      setState(() => products = (resp.data['data'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList());
    } else {
      if (mounted) {
        context
            .read<StockDeclarationProvider>()
            .notifyError(resp.data['message']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StockDeclarationProvider>(
      builder: (context, provider, child) {
        return AppForm(
            formKey: _productForm,
            initialValue: widget.formValues,
            controls: [
              AppFetcher(
                  api: '/subsidy-declarations/declaration-types',
                  builder: (items, isLoading) => AppInputDropDown(
                        items: items,
                        name: 'declarationType',
                        label: isLoading ? 'Loading..' : 'Declaration Type',
                      )),
              AppFetcher(
                  api: '/crops',
                  builder: (items, isLoading) => AppInputDropDown(
                      onChange: (cropId) {
                        _productForm.currentState!.fields['productId']!
                            .didChange(null);
                        loadProduct(cropId);
                      },
                      items: items,
                      name: 'cropId',
                      label: 'Crop')),
              AppInputDropDown(
                items: products,
                name: 'productId',
                valueColumn: 'productId',
                label: 'Product',
                displayValue: 'productName',
              ),
              const AppInputNumber(
                  noDecimal: true, name: 'quantity', label: 'Quantity'),
              AppButton(onPress: () => _validateAndNext(), label: 'NEXT')
            ]);
      },
    );
  }

  _validateAndNext() {
    if (_productForm.currentState?.saveAndValidate() == true) {
      widget.onNextStep!(_productForm.currentState?.value);
    }
  }
}
