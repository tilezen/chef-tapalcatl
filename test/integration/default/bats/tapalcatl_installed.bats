#!/usr/bin/env bats

@test "tapalcatl server binary is installed" {
  [ -x "/usr/local/bin/tapalcatl_server" ]
}
