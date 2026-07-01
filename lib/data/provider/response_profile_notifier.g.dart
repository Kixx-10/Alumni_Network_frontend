// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_profile_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ResponseProfileNotifier)
final responseProfileProvider = ResponseProfileNotifierProvider._();

final class ResponseProfileNotifierProvider
    extends
        $AsyncNotifierProvider<ResponseProfileNotifier, ResponseProfileModel> {
  ResponseProfileNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'responseProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$responseProfileNotifierHash();

  @$internal
  @override
  ResponseProfileNotifier create() => ResponseProfileNotifier();
}

String _$responseProfileNotifierHash() =>
    r'13fb55c4701b48962476a5be75b47db9c2654952';

abstract class _$ResponseProfileNotifier
    extends $AsyncNotifier<ResponseProfileModel> {
  FutureOr<ResponseProfileModel> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<ResponseProfileModel>, ResponseProfileModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<ResponseProfileModel>,
                ResponseProfileModel
              >,
              AsyncValue<ResponseProfileModel>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
