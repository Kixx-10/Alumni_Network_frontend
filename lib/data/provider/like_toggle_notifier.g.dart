// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'like_toggle_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LikeToggleNotifier)
final likeToggleProvider = LikeToggleNotifierProvider._();

final class LikeToggleNotifierProvider
    extends $NotifierProvider<LikeToggleNotifier, AsyncValue<void>> {
  LikeToggleNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'likeToggleProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$likeToggleNotifierHash();

  @$internal
  @override
  LikeToggleNotifier create() => LikeToggleNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$likeToggleNotifierHash() =>
    r'8c3d5a66ac6a4cbd780a4d599efa898f04982a68';

abstract class _$LikeToggleNotifier extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
