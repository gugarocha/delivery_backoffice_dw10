import 'package:flutter/material.dart';

import '../../../../../core/extensions/formatter_extension.dart';
import '../../../../../core/ui/styles/text_styles.dart';
import '../../../../../dto/order/order_product_dto.dart';

class OrderProductItem extends StatelessWidget {
  final OrderProductDto orderProduct;

  const OrderProductItem({
    super.key,
    required this.orderProduct,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = context.textStyles;

    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Text(
              orderProduct.product.name,
              style: textStyles.textRegular,
            ),
          ),
          Text(
            '${orderProduct.amount}',
            style: textStyles.textRegular,
          ),
          Expanded(
            child: Text(
              orderProduct.totalPrice.currencyPTBR,
              textAlign: TextAlign.end,
              style: textStyles.textRegular,
            ),
          ),
        ],
      ),
    );
  }
}
