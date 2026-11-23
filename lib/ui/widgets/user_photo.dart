import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/session.dart';
import 'disk_image.dart';

/// Tag da foto do perfil desta conta no Jellyfin (null = sem foto).
final myPhotoTagProvider = FutureProvider<String?>((ref) async {
  final s = ref.watch(sessionProvider).value;
  if (s == null) return null;
  try {
    return await s.api.myImageTag();
  } catch (_) {
    return null;
  }
});

/// Foto redonda de uma conta (ou a inicial do nome numa cor).
class UserPhoto extends ConsumerWidget {
  final String userId;
  final String name;
  final String? tag;
  final double size;
  const UserPhoto({
    super.key,
    required this.userId,
    required this.name,
    required this.tag,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initial = CircleAvatar(
      radius: size / 2,
      backgroundColor: Color(0xFF5038A0 + (name.hashCode & 0x3F3F3F)),
      child: Text(
        name.isEmpty ? '?' : name.characters.first.toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: size * 0.42,
        ),
      ),
    );
    if (tag == null || userId.isEmpty) return initial;
    final url = ref
        .watch(apiProvider)
        .userImageUrl(userId, tag!, size: (size * 2).round().clamp(64, 600));
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: Image(
          image: DiskImage(url),
          fit: BoxFit.cover,
          gaplessPlayback: true,
          errorBuilder: (_, _, _) => initial,
        ),
      ),
    );
  }
}

/// A foto desta conta.
class MyPhoto extends ConsumerWidget {
  final double size;
  const MyPhoto({super.key, this.size = 32});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(sessionProvider).value;
    final tag = ref.watch(myPhotoTagProvider).value;
    return UserPhoto(
      userId: s?.userId ?? '',
      name: s?.userName ?? '',
      tag: tag,
      size: size,
    );
  }
}
