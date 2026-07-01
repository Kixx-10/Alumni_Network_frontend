// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CommentNotifier)
final commentProvider = CommentNotifierFamily._();

final class CommentNotifierProvider
    extends $AsyncNotifierProvider<CommentNotifier, List<CommentModel>> {
  CommentNotifierProvider._({
    required CommentNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'commentProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$commentNotifierHash();

  @override
  String toString() {
    return r'commentProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CommentNotifier create() => CommentNotifier();

  @override
  bool operator ==(Object other) {
    return other is CommentNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$commentNotifierHash() => r'2ee4f3d1da2d85682d55ad14579a22adef4dd3cb';

final class CommentNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          CommentNotifier,
          AsyncValue<List<CommentModel>>,
          List<CommentModel>,
          FutureOr<List<CommentModel>>,
          String
        > {
  CommentNotifierFamily._()
    : super(
        retry: null,
        name: r'commentProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CommentNotifierProvider call(String postId) =>
      CommentNotifierProvider._(argument: postId, from: this);

  @override
  String toString() => r'commentProvider';
}

abstract class _$CommentNotifier extends $AsyncNotifier<List<CommentModel>> {
  late final _$args = ref.$arg as String;
  String get postId => _$args;

  FutureOr<List<CommentModel>> build(String postId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<CommentModel>>, List<CommentModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<CommentModel>>, List<CommentModel>>,
              AsyncValue<List<CommentModel>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
