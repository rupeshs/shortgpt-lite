// Mocks generated by Mockito 5.4.1 from annotations
// in shortgpt_lite/test/cubit/gpt_chat_cubit_test.dart.
// Do not manually edit this file.

// @dart=2.19

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:dartz/dartz.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:shortgpt_lite/models/errors.dart' as _i5;
import 'package:shortgpt_lite/models/llm_input.dart' as _i7;
import 'package:shortgpt_lite/models/llm_response.dart' as _i6;
import 'package:shortgpt_lite/resources/llm_chat_api.dart' as _i3;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeEither_0<L, R> extends _i1.SmartFake implements _i2.Either<L, R> {
  _FakeEither_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [LlmChatApi].
///
/// See the documentation for Mockito's code generation for more information.
class MockLlmChatApi extends _i1.Mock implements _i3.LlmChatApi {
  MockLlmChatApi() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.AppError, _i6.LlmResponse>> getAnswer(
          _i7.LlmInput? llmInput) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAnswer,
          [llmInput],
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.AppError, _i6.LlmResponse>>.value(
                _FakeEither_0<_i5.AppError, _i6.LlmResponse>(
          this,
          Invocation.method(
            #getAnswer,
            [llmInput],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.AppError, _i6.LlmResponse>>);
}
