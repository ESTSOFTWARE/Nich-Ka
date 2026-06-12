import 'package:flutter/material.dart';
import '../../data/datasource/local/terms_of_use_content.dart';
import 'legal_document_view.dart';

class TermsOfUseView extends StatelessWidget {
  const TermsOfUseView({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalDocumentView(
      title: 'Términos de Uso',
      intro: termsOfUseIntro,
      lastUpdate: termsOfUseLastUpdate,
      sections: termsOfUseSections,
    );
  }
}
