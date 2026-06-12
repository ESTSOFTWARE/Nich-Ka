import '../../../domain/entities/legal_section.dart';

const String privacyPolicyIntro =
    'Nos comprometemos a proteger su privacidad y a ser transparentes sobre '
    'cómo manejamos sus datos personales en la plataforma Nich-Ká.';

const String privacyPolicyLastUpdate =
    'Última actualización: 9 de mayo de 2026';

const List<LegalSection> privacyPolicySections = [
  LegalSection(
    number: '01',
    title: 'Información que recopilamos',
    body:
        'Recopilamos información que usted nos proporciona directamente al '
        'registrarse en nuestra plataforma, como nombre, correo electrónico e '
        'institución académica. También recopilamos automáticamente datos de '
        'uso, parámetros de los experimentos de fermentación y preferencias de '
        'configuración del sistema.',
  ),
  LegalSection(
    number: '02',
    title: 'Cómo utilizamos su información',
    body:
        'Utilizamos sus datos para operar y mejorar la plataforma Nich-Ká, '
        'personalizar su experiencia, enviar notificaciones relacionadas con '
        'sus experimentos y garantizar la seguridad de su cuenta. No utilizamos '
        'sus datos con fines publicitarios ni los vendemos a terceros.',
  ),
  LegalSection(
    number: '03',
    title: 'Compartición de datos',
    body:
        'Sus datos solo se comparten con proveedores de servicios que nos '
        'ayudan a operar la plataforma (servidores, análisis técnico) y que '
        'están obligados contractualmente a mantener la confidencialidad. '
        'Podemos divulgar información si es requerida por ley o para proteger '
        'los derechos de la plataforma y sus usuarios.',
  ),
  LegalSection(
    number: '04',
    title: 'Almacenamiento y seguridad',
    body:
        'Sus datos se almacenan en servidores seguros con cifrado en tránsito '
        '(TLS) y en reposo. Aplicamos controles de acceso estrictos y revisamos '
        'periódicamente nuestras medidas de seguridad para proteger su '
        'información contra acceso no autorizado.',
  ),
  LegalSection(
    number: '05',
    title: 'Sus derechos',
    body:
        'Usted tiene derecho a acceder, corregir o eliminar sus datos '
        'personales en cualquier momento. Puede ejercer estos derechos desde la '
        'configuración de su cuenta o contactándonos directamente. También '
        'puede solicitar la portabilidad de sus datos en un formato legible por '
        'máquina.',
  ),
  LegalSection(
    number: '06',
    title: 'Retención de datos',
    body:
        'Conservamos sus datos mientras su cuenta esté activa o según sea '
        'necesario para prestar nuestros servicios. Al eliminar su cuenta, sus '
        'datos personales serán eliminados en un plazo de 30 días, salvo que la '
        'ley nos obligue a conservarlos por más tiempo.',
  ),
  LegalSection(
    number: '07',
    title: 'Cambios a esta política',
    body:
        'Podemos actualizar esta política de privacidad ocasionalmente. Le '
        'notificaremos de cambios significativos a través del correo '
        'electrónico registrado o mediante un aviso visible en la plataforma. '
        'Le recomendamos revisar esta página periódicamente.',
  ),
];
