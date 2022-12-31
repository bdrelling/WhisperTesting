# WhisperTesting

We have an Xcode project and Swift package. Currently, `whisper.cpp` is implemented directly into the Xcode project, but we are trying to abstract this into our Swift package via `whisper.spm`. However, we're noticing that `whisper.spm` is about 40x slower in `debug` configuration than in `release`.

Unfortunately, SPM does not allow us to override the default compilation mode for an individual module. Adding something like `cSettings: [.unsafeFlags["-O3"]]` to the package definition makes no impact on third-party dependencies. Similarly, from the Xcode project, we don't seem to have the option for explicit, configuration-based overrides to our dependencies.

## Sample Output

### Debug

`swift test -c debug`

```
swift test
Building for debugging...
/Users/**/WhisperTesting/Tests/WhisperTests/WhisperTests.swift:23:9: warning: variable 'pcmf32' was never mutated; consider changing to 'let' constant
    var pcmf32 = [Float](repeating: 0, count: Int(n_samples))
    ~~~ ^
    let
[4/4] Linking WhisperTestingPackageTests
Build complete! (1.01s)
Test Suite 'All tests' started at 2022-12-30 19:16:12.068
Test Suite 'WhisperTestingPackageTests.xctest' started at 2022-12-30 19:16:12.069
Test Suite 'WhisperBridgeTests' started at 2022-12-30 19:16:12.069
Test Case '-[WhisperTests.WhisperBridgeTests testWhisperSPM]' started.
whisper_model_load: loading model from '/Users/**/WhisperTesting/.build/arm64-apple-macosx/debug/WhisperTesting_WhisperTests.bundle/models/for-tests-ggml-base.en.bin'
whisper_model_load: n_vocab       = 51864
whisper_model_load: n_audio_ctx   = 1500
whisper_model_load: n_audio_state = 512
whisper_model_load: n_audio_head  = 8
whisper_model_load: n_audio_layer = 6
whisper_model_load: n_text_ctx    = 448
whisper_model_load: n_text_state  = 512
whisper_model_load: n_text_head   = 8
whisper_model_load: n_text_layer  = 6
whisper_model_load: n_mels        = 80
whisper_model_load: f16           = 1
whisper_model_load: type          = 2
whisper_model_load: adding 1607 extra tokens
whisper_model_load: mem_required  =  506.00 MB
whisper_model_load: ggml ctx size =  140.60 MB
whisper_model_load: memory size   =   22.83 MB
whisper_model_load: model size    =    0.00 MB
whisper_model_load: WARN no tensors loaded from model file - assuming empty model for testing
whisper_print_timings:     load time =  2897.81 ms
whisper_print_timings:      mel time =     8.35 ms
whisper_print_timings:   sample time =     0.00 ms
whisper_print_timings:   encode time =     0.00 ms / 0.00 ms per layer
whisper_print_timings:   decode time =     0.00 ms / 0.00 ms per layer
whisper_print_timings:    total time =  2906.31 ms
Test Case '-[WhisperTests.WhisperBridgeTests testWhisperSPM]' passed (5.450 seconds).
Test Suite 'WhisperBridgeTests' passed at 2022-12-30 19:16:17.519.
  Executed 1 test, with 0 failures (0 unexpected) in 5.450 (5.450) seconds
Test Suite 'WhisperTestingPackageTests.xctest' passed at 2022-12-30 19:16:17.519.
  Executed 1 test, with 0 failures (0 unexpected) in 5.450 (5.451) seconds
Test Suite 'All tests' passed at 2022-12-30 19:16:17.519.
  Executed 1 test, with 0 failures (0 unexpected) in 5.450 (5.451) seconds
```

### Release

`swift test -c release`

```
swift test -c release
Building for production...
/Users/**/WhisperTesting/Tests/WhisperTests/WhisperTests.swift:23:9: warning: variable 'pcmf32' was never mutated; consider changing to 'let' constant
    var pcmf32 = [Float](repeating: 0, count: Int(n_samples))
    ~~~ ^
    let
[2/2] Linking WhisperTestingPackageTests
Build complete! (0.95s)
Test Suite 'All tests' started at 2022-12-30 19:18:40.837
Test Suite 'WhisperTestingPackageTests.xctest' started at 2022-12-30 19:18:40.838
Test Suite 'WhisperBridgeTests' started at 2022-12-30 19:18:40.838
Test Case '-[WhisperTests.WhisperBridgeTests testWhisperSPM]' started.
whisper_model_load: loading model from '/Users/**/WhisperTesting/.build/arm64-apple-macosx/release/WhisperTesting_WhisperTests.bundle/models/for-tests-ggml-base.en.bin'
whisper_model_load: n_vocab       = 51864
whisper_model_load: n_audio_ctx   = 1500
whisper_model_load: n_audio_state = 512
whisper_model_load: n_audio_head  = 8
whisper_model_load: n_audio_layer = 6
whisper_model_load: n_text_ctx    = 448
whisper_model_load: n_text_state  = 512
whisper_model_load: n_text_head   = 8
whisper_model_load: n_text_layer  = 6
whisper_model_load: n_mels        = 80
whisper_model_load: f16           = 1
whisper_model_load: type          = 2
whisper_model_load: adding 1607 extra tokens
whisper_model_load: mem_required  =  506.00 MB
whisper_model_load: ggml ctx size =  140.60 MB
whisper_model_load: memory size   =   22.83 MB
whisper_model_load: model size    =    0.00 MB
whisper_model_load: WARN no tensors loaded from model file - assuming empty model for testing
whisper_print_timings:     load time =    67.69 ms
whisper_print_timings:      mel time =     1.70 ms
whisper_print_timings:   sample time =     0.00 ms
whisper_print_timings:   encode time =     0.00 ms / 0.00 ms per layer
whisper_print_timings:   decode time =     0.00 ms / 0.00 ms per layer
whisper_print_timings:    total time =    69.52 ms
Test Case '-[WhisperTests.WhisperBridgeTests testWhisperSPM]' passed (0.082 seconds).
Test Suite 'WhisperBridgeTests' passed at 2022-12-30 19:18:40.920.
  Executed 1 test, with 0 failures (0 unexpected) in 0.082 (0.082) seconds
Test Suite 'WhisperTestingPackageTests.xctest' passed at 2022-12-30 19:18:40.920.
  Executed 1 test, with 0 failures (0 unexpected) in 0.082 (0.082) seconds
Test Suite 'All tests' passed at 2022-12-30 19:18:40.920.
  Executed 1 test, with 0 failures (0 unexpected) in 0.082 (0.083) seconds
```
