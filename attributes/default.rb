default[:tapalcatl][:bin] = '/usr/local/bin'
default[:tapalcatl][:cfg_file] = 'tapalcatl.conf'
default[:tapalcatl][:cfg_path] = '/etc/tapalcatl'
default[:tapalcatl][:revision] = 'master'

# interface:port to listen on
default[:tapalcatl][:listen] = ':80'

# each pattern maps a distinct URL path on the tapalcatl server to a storage
# source, layer, upstream proxy URL and metatile size. the storage source can
# be either 'File' for local file storage (which takes a 'BaseDir' subkey) or
# 'S3' to use S3 (which takes 'Bucket', 'KeyPattern' and 'Prefix' subkeys).
#
# the S3 KeyPattern and upstream ProxyURL are both interpolated with the
# variables matches against the input pattern, plus the Layer parameter. the
# S3 KeyPattern additionally can contain {hash} which is a partial md5 of the
# pattern '{layer}/{z}/{x}/{y}.{fmt}' useful for distributing the filenames.
#

# a mapping from the request extension to the MIME type to use in the returned
# headers.
default[:tapalcatl][:mime] = {
  'json' => 'application/json',
  'mvt' => 'application/x-protobuf',
  'mvtb' => 'application/x-protobuf',
  'topojson' => 'application/json',
}

# expvar configuration
default[:tapalcatl][:expvars][:serve] = false
default[:tapalcatl][:expvars][:log_interval] = 0

handler_cfg = {
  'mime' => node[:tapalcatl][:mime],
  'storage' => {
    'tmp' => {
      'type' => 'file',
      'basedir' => '/tmp',
      'metatilesize' => 1,
      'layer' => 'all',
    },
  },
  'pattern' => {
    '/{z:[0-9]+}/{x:[0-9]+}/{y:[0-9]+}.{fmt}' => {
      'storage' => 'tmp',
    },
  },
}
default[:tapalcatl][:handler_cfg_json] = handler_cfg.to_json

# tapalcatl has a buffer pool to reduce GC pressure when copying large amounts
# of data from the upstream server.
default[:tapalcatl][:pool][:enabled] = true

# the "num" is the number of buffers to retain, and should be sized to
# the number of concurrent requests expected.
default[:tapalcatl][:pool][:num] = 10

# the pool entry is the size in bytes to initially assign. buffers can grow, so
# it is not necessary to make this particularly large. a good value is the
# average expected size of the zip files.
default[:tapalcatl][:pool][:entry] = 102400

default[:tapalcatl][:runit][:timeout] = 60
default[:tapalcatl][:user][:create_group] = true
default[:tapalcatl][:user][:enabled] = true
default[:tapalcatl][:user][:home] = '/home/tapalcatl'
default[:tapalcatl][:user][:user] = 'tapalcatl'

default[:tapalcatl][:metrics][:enabled] = false
# addr should be a "host:port"
default[:tapalcatl][:metrics][:statsd][:addr] = ''
# prefix used when sending metrics to statsd
default[:tapalcatl][:metrics][:statsd][:prefix] = ''

# default to using whatever the maximum is that the system advertises in
# /proc/sys/fs/file-max. override to set a specific (lower) value.
default[:tapalcatl][:limits][:open_files] = nil
