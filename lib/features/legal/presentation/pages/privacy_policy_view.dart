import 'package:flutter/material.dart';
import '../../data/datasource/local/privacy_policy_content.dart';
import 'legal_document_view.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalDocumentView(
      title: 'Política de Privacidad',
      intro: privacyPolicyIntro,
      lastUpdate: privacyPolicyLastUpdate,
      sections: privacyPolicySections,
    );
  }
}
