import 'package:brasil_fields/brasil_fields.dart';
import 'package:delivery_backoffice_dw10/src/modules/products/detail/product_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/env/env.dart';
import '../../../core/ui/helpers/loader.dart';
import '../../../core/ui/helpers/messages.dart';
import '../../../core/ui/helpers/size_extensions.dart';
import '../../../core/ui/helpers/upload_html_helper.dart';
import '../../../core/ui/styles/text_styles.dart';

class ProductDetailPage extends StatefulWidget {
  final int? productId;

  const ProductDetailPage({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with Loader, Messages {
  final controller = Modular.get<ProductDetailController>();
  final formKey = GlobalKey<FormState>();
  final nameEC = TextEditingController();
  final priceEC = TextEditingController();
  final descriptionEC = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      reaction((_) => controller.status, (status) {
        switch (status) {
          case ProductDetailStateStatus.initial:
            break;
          case ProductDetailStateStatus.loading:
            showLoader();
            break;
          case ProductDetailStateStatus.loaded:
            hideLoader();
            break;
          case ProductDetailStateStatus.error:
            hideLoader();
            showError(controller.errorMessage!);
            break;
          case ProductDetailStateStatus.errorLoadProduct:
            break;
          case ProductDetailStateStatus.deleted:
            break;
          case ProductDetailStateStatus.uploaded:
            hideLoader();
            break;
          case ProductDetailStateStatus.saved:
            hideLoader();
            Navigator.pop(context);
            break;
        }
      });
    });
  }

  @override
  void dispose() {
    nameEC.dispose();
    priceEC.dispose();
    descriptionEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final widthButtonAction = context.percentWidth(0.4);

    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.all(40),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${widget.productId != null ? 'Alterar' : 'Adicionar'} Produto',
                      textAlign: TextAlign.center,
                      style: context.textStyles.textTitle.copyWith(
                        decoration: TextDecoration.underline,
                        decorationThickness: 2,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Observer(
                        builder: (_) {
                          if (controller.imagePath != null) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                '${Env.instance.get('backend_base_url')}${controller.imagePath}',
                                width: 200,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.all(10),
                        child: TextButton(
                          onPressed: () {
                            UploadHtmlHelper().startUpload(
                              controller.uploadImageProduct,
                            );
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.9),
                          ),
                          child: Observer(
                            builder: (_) {
                              return Text(
                                '${controller.imagePath == null ? 'Adicionar' : 'Alterar'} foto',
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: nameEC,
                          validator: Validatorless.required('Nome Obrigatório'),
                          decoration:
                              const InputDecoration(label: Text('Nome')),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: priceEC,
                          validator:
                              Validatorless.required('Preço Obrigatório'),
                          decoration:
                              const InputDecoration(label: Text('Preço')),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CentavosInputFormatter(moeda: true),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: descriptionEC,
                validator: Validatorless.required('Descrição Obrigatória'),
                maxLines: null,
                minLines: context.screenHeight > 720 ? 10 : 7,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  label: Text('Descrição'),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: widthButtonAction,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: widthButtonAction / 2,
                        height: 60,
                        padding: const EdgeInsets.all(5),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                          ),
                          onPressed: () {},
                          child: Text(
                            'Deletar',
                            style: context.textStyles.textBold.copyWith(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: widthButtonAction / 2,
                        height: 60,
                        padding: const EdgeInsets.all(5),
                        child: ElevatedButton(
                          onPressed: () {
                            final valid =
                                formKey.currentState?.validate() ?? false;
                            if (valid) {
                              if (controller.imagePath == null) {
                                showWarnig(
                                  'Imagem obrigatória. Por favor, clique em adicionar foto',
                                );
                                return;
                              }

                              controller.save(
                                name: nameEC.text,
                                price:
                                    UtilBrasilFields.converterMoedaParaDouble(
                                  priceEC.text,
                                ),
                                description: descriptionEC.text,
                              );
                            }
                          },
                          child: Text(
                            'Salvar',
                            style: context.textStyles.textBold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
