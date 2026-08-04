import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/class/domain/entities/class_member.dart';
import '../providers/user_detail_provider.dart';

export '../providers/user_detail_provider.dart';

/// Detalle de un usuario de la clase. Mantiene estado mutable (scroll, carga
/// del perfil) por lo que se expone vía ChangeNotifierProvider de Riverpod.
/// family: uno por miembro; autoDispose: libera el ScrollController al salir.
final userDetailProvider = ChangeNotifierProvider.autoDispose
    .family<UserDetailProvider, ClassMember>(
      (ref, member) => UserDetailProvider(member),
    );
