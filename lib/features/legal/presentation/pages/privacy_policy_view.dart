import 'package:flutter/material.dart';
import '../models/privacy_policy_content.dart';
import 'legal_document_view.dart';

/// Pantalla de la Política de Privacidad. Solo aporta el contenido a
/// [LegalDocumentView].
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
