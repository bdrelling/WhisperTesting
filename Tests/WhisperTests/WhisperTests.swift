import whisper
import XCTest

final class WhisperBridgeTests: XCTestCase {
  // This function is copied from https://github.com/ggerganov/whisper.spm/blob/master/Sources/test-swift/main.swift
  func testWhisperSPM() throws {
    let modelPath = try XCTUnwrap(Bundle.module.path(forResource: "for-tests-ggml-base.en", ofType: "bin", inDirectory: "models"))

    let ctx = whisper_init(modelPath)

    var params = whisper_full_default_params(WHISPER_SAMPLING_GREEDY)

    params.print_realtime = true
    params.print_progress = false
    params.print_timestamps = true
    params.print_special = false
    params.translate = false
    // params.language         = "en";
    params.n_threads = 4
    params.offset_ms = 0

    let n_samples = Int32(WHISPER_SAMPLE_RATE)
    var pcmf32 = [Float](repeating: 0, count: Int(n_samples))

    let ret = whisper_full(ctx, params, pcmf32, n_samples)
    assert(ret == 0, "Failed to run the model")

    let n_segments = whisper_full_n_segments(ctx)

    for i in 0..<n_segments {
      let text_cur = whisper_full_get_segment_text(ctx, i)
      print(text_cur as Any)
    }

    whisper_print_timings(ctx)
    whisper_free(ctx)
  }
}
