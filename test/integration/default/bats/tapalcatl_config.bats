#!/usr/bin/env bats

@test "tapalcatl config exists" {
  [ -f "/etc/tapalcatl/tapalcatl.conf" ]
}
