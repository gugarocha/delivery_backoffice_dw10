import 'package:flutter/material.dart';

import '../../../../core/extensions/formatter_extension.dart';
import '../../../../core/ui/helpers/size_extensions.dart';
import '../../../../core/ui/styles/text_styles.dart';
import 'widgets/order_bottom_bar.dart';
import 'widgets/order_info_tile.dart';
import 'widgets/order_product_item.dart';

class OrderDetailModal extends StatefulWidget {
  const OrderDetailModal({super.key});

  @override
  State<OrderDetailModal> createState() => _OrderDetailModalState();
}

class _OrderDetailModalState extends State<OrderDetailModal> {
  void closeModal() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.screenWidth;
    final textStyles = context.textStyles;

    return Material(
      color: Colors.black26,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.white,
        elevation: 10,
        child: Container(
          width: screenWidth * (screenWidth > 1200 ? 0.5 : 0.7),
          padding: const EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Detalhe do Pedido',
                        style: textStyles.textTitle,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: closeModal,
                        icon: const Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      'Nome do cliente: ',
                      style: textStyles.textBold,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Gustavo Rocha',
                      style: textStyles.textRegular,
                    ),
                  ],
                ),
                const Divider(),
                ...List.generate(3, (index) => const OrderProductItem()),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total do Pedido',
                        style: textStyles.textExtraBold.copyWith(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        100.0.currencyPTBR,
                        style: textStyles.textExtraBold.copyWith(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                const OrderInfoTile(
                  label: 'Endereço de entrega:',
                  info: 'Avenida Paulista, 200',
                ),
                const Divider(),
                const OrderInfoTile(
                  label: 'Forma de pagamento:',
                  info: 'Cartão de Crédito',
                ),
                const SizedBox(
                  height: 10,
                ),
                const OrderBottomBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
