#!/usr/bin/env bats

@test "tapalcatl server binary is installed" {
  [ -x "/opt/go/bin/tapalcatl_server" ]
}
