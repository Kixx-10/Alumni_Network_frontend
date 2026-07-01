// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_profile_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CreateProfileNotifier)
final createProfileProvider = CreateProfileNotifierProvider._();

final class CreateProfileNotifierProvider
    extends $NotifierProvider<CreateProfileNotifier, AsyncValue<void>> {
  CreateProfileNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createProfileNotifierHash();

  @$internal
  @override
  CreateProfileNotifier create() => CreateProfileNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$createProfileNotifierHash() =>
    r'97a5a0fc41737d66c36ae329c64797194432030e';

abstract class _$CreateProfileNotifier extends $Notifier<AsyncValue<void>> {
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
