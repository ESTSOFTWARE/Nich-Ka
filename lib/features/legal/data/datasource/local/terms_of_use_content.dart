import '../../../domain/entities/legal_section.dart';

const String termsOfUseIntro =
    'Estos términos rigen el uso de la plataforma Nich-Ká. Léalos detenidamente '
    'antes de utilizar nuestros servicios.';

const String termsOfUseLastUpdate = 'Última actualización: 9 de mayo de 2026';

const List<LegalSection> termsOfUseSections = [
  LegalSection(
    number: '01',
    title: 'Aceptación de los términos',
    body:
        'Al acceder y utilizar la plataforma Nich-Ká, usted acepta estar sujeto '
        'a estos términos de uso. Si no está de acuerdo con alguna parte de '
        'estos términos, no podrá utilizar nuestros servicios. El uso continuado '
        'de la plataforma constituye la aceptación de cualquier modificación '
        'futura.',
  ),
  LegalSection(
    number: '02',
    title: 'Descripción del servicio',
    body:
        'Nich-Ká es una plataforma de software para el monitoreo, control y '
        'optimización de procesos de fermentación de café. La plataforma está '
        'diseñada para uso académico e investigativo, y permite gestionar '
        'experimentos, visualizar datos de sensores y ejecutar simulaciones '
        'algorítmicas.',
  ),
  LegalSection(
    number: '03',
    title: 'Registro y cuenta de usuario',
    body:
        'Para acceder a las funciones completas, debe crear una cuenta con '
        'información veraz y actualizada. Usted es responsable de mantener la '
        'confidencialidad de su contraseña y de todas las actividades que '
        'ocurran bajo su cuenta. Notifíquenos inmediatamente ante cualquier uso '
        'no autorizado.',
  ),
  LegalSection(
    number: '04',
    title: 'Uso aceptable',
    body:
        'Usted se compromete a usar la plataforma únicamente con fines legales, '
        'académicos o de investigación. Está prohibido: intentar acceder no '
        'autorizado a otros sistemas, cargar contenido malicioso, interferir '
        'con el funcionamiento de la plataforma o compartir credenciales de '
        'acceso con terceros.',
  ),
  LegalSection(
    number: '05',
    title: 'Propiedad intelectual',
    body:
        'Todo el contenido, código, algoritmos, diseños y marcas de la '
        'plataforma Nich-Ká son propiedad exclusiva de sus desarrolladores y '
        'están protegidos por las leyes de propiedad intelectual aplicables. No '
        'se concede ninguna licencia implícita sobre estos elementos más allá '
        'del uso normal de la plataforma.',
  ),
  LegalSection(
    number: '06',
    title: 'Datos de experimentos',
    body:
        'Los datos generados durante sus experimentos de fermentación son de su '
        'propiedad. Al utilizar la plataforma, nos otorga una licencia limitada '
        'para procesar dichos datos con el fin de prestar el servicio. Podemos '
        'utilizar datos agregados y anonimizados para mejorar los algoritmos de '
        'la plataforma.',
  ),
  LegalSection(
    number: '07',
    title: 'Limitación de responsabilidad',
    body:
        "La plataforma se provee 'tal cual', sin garantías de ningún tipo. No "
        'seremos responsables por daños directos, indirectos, incidentales o '
        'consecuentes derivados del uso o la imposibilidad de uso de la '
        'plataforma, incluyendo pérdida de datos de experimentos o '
        'interrupciones del servicio.',
  ),
  LegalSection(
    number: '08',
    title: 'Modificaciones y terminación',
    body:
        'Nos reservamos el derecho de modificar o discontinuar el servicio con '
        'previo aviso. Podemos suspender o cancelar su acceso si incumple estos '
        'términos. Las disposiciones sobre propiedad intelectual, limitación de '
        'responsabilidad y resolución de disputas sobrevivirán a la '
        'terminación.',
  ),
];
