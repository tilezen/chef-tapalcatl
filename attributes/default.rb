default[:go][:version] = '1.7.3'

default[:tapalcatl][:package] = 'github.com/tilezen/tapalcatl/tapalcatl_server'

default[:tapalcatl][:cfg_file] = 'tapalcatl.conf'
default[:tapalcatl][:cfg_path] = '/etc/tapalcatl'

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
default[:tapalcatl][:patterns] = {
  '/v1/{z}/{x}/{y}.{fmt}' => {
    'File' => {
      'BaseDir' => '/tmp/tiles'
    },
    'Layer' => 'all',
    'ProxyURL' => 'http://upstream.server/{layer}/{z}/{x}/{y}.{fmt}',
    'MetatileSize' => 1
  },
  '/v2/{z}/{x}/{y}.{fmt}' => {
    'S3' => {
      'Bucket' => 's3://bucket-name-here',
      'KeyPattern' => '/{hash}/{z}/{x}/{y}.fmt',
      'Prefix' => 'prefix'
    },
    'Layer' => 'all',
    'ProxyURL' => 'http://upstream.server/{layer}/{z}/{x}/{y}.{fmt}',
    'MetatileSize' => 1
  }
}

# a mapping from the request extension to the MIME type to use in the returned
# headers.
default[:tapalcatl][:mime] = {
  'json'     => 'application/json',
  'topojson' => 'application/json',
  'mvt'      => 'application/x-protobuf',
  'mvtb'     => 'application/x-protobuf',
}

# tapalcatl has a buffer pool to reduce GC pressure when copying large amounts
# of data from the upstream server. the poolsize is the number of buffers to
# retain, and should be sized to the number of concurrent requests expected.
default[:tapalcatl][:poolsize] = 10

# the pool width is the size in bytes to initially assign. buffers can grow, so
# it is not necessary to make this particularly large. a good value is the
# average expected size of the zip files.
default[:tapalcatl][:poolwidth] = 102400

default[:tapalcatl][:runit][:timeout] = 60
default[:tapalcatl][:user][:create_group] = true
default[:tapalcatl][:user][:enabled] = true
default[:tapalcatl][:user][:home] = '/home/tapalcatl'
default[:tapalcatl][:user][:user] = 'tapalcatl'
