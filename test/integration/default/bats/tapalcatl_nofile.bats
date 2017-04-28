#!/usr/bin/env bats

@test "proc max files is a number" {
  max=`cat /proc/sys/fs/file-max`
  [ "$max" -gt 1024 ]
}

@test "default limit on open files exists in runit config" {
  max=`cat /proc/sys/fs/file-max`
  count=`grep -c "^ulimit -n $max$" /etc/sv/tapalcatl/run`
  [ "$count" -eq 1 ]
}

@test "tapalcatl limit on open files defaults to max" {
  pid=`ps aux | grep tapalcatl_server | grep -v grep | awk '{print $2;}' | head -n 1`
  nofile=`grep '^Max open files' /proc/$pid/limits | awk '{print $4;}'`
  max=`cat /proc/sys/fs/file-max`
  [ "$nofile" -eq "$max" ]
}
