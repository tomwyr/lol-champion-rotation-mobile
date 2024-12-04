platform :android do
  lane :deploy do
    gradle(task: "clean assembleRelease")
    upload_to_play_store(json_key: ENV["GOOGLE_PLAY_JSON_KEY"], track: "internal")
  end
end

platform :ios do
  lane :deploy do
    build_app(scheme: "Runner")
    upload_to_testflight(api_key_path: "./ios/AuthKey.p8")
  end
end
