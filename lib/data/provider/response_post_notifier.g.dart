// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_post_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ResponsePostNotifier)
final responsePostProvider = ResponsePostNotifierProvider._();

final class ResponsePostNotifierProvider
    extends
        $AsyncNotifierProvider<ResponsePostNotifier, List<ResponsePostModel>> {
  ResponsePostNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'responsePostProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$responsePostNotifierHash();

  @$internal
  @override
  ResponsePostNotifier create() => ResponsePostNotifier();
}

String _$responsePostNotifierHash() =>
    r'49a92e29c4227c0474aa6763daef20eaecafebce';

abstract class _$ResponsePostNotifier
    extends $AsyncNotifier<List<ResponsePostModel>> {
  FutureOr<List<ResponsePostModel>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<ResponsePostModel>>,
              List<ResponsePostModel>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<ResponsePostModel>>,
                List<ResponsePostModel>
              >,
              AsyncValue<List<ResponsePostModel>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
