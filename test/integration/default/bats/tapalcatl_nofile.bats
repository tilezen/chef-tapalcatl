#!/usr/bin/env bats

@test "tapalcatl limit on open files is increased" {
  pid=`ps aux | grep tapalcatl_server | grep -v grep | awk '{print $2;}' | head -n 1`
  nofile=`grep '^Max open files' /proc/$pid/limits | awk '{print $4;}'`
  [ "$nofile" -eq 16384 ]
}
