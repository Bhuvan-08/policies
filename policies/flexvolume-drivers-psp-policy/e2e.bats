#!/usr/bin/env bats

@test "Accept pod with allowed flexVolume driver" {
  run kwctl run annotated-policy.wasm \
    -r test_data/request_allowed.json \
    --settings-json '{"rule": "MustRunAs", "allowedFlexVolumes": [{"driver": "example/allowed-driver"}]}'

  [ "$status" -eq 0 ]
  [[ "$output" == *"allowed\":true"* ]]
}

@test "Reject pod with unlisted flexVolume driver" {
  # Same pod (uses example/allowed-driver), but we change settings to only allow "vendor/unknown"
  run kwctl run annotated-policy.wasm \
    -r test_data/request_allowed.json \
    --settings-json '{"rule": "MustRunAs", "allowedFlexVolumes": [{"driver": "vendor/unknown-driver"}]}'

  [ "$status" -eq 0 ]
  [[ "$output" == *"allowed\":false"* ]]
}