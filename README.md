Tapalcatl Cookbook
=================

This cookbook sets up [Tapalcatl](https://github.com/tilezen/tapalcatl), the "metatile" server.

Requirements
------------

#### recipes
- `apt`
- `runit`
- `user`

Attributes
----------

#### tapalcatl::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['tapalcatl']['package']</tt></td>
    <td>String</td>
    <td>Package to install</td>
    <td><tt>github.com/tilezen/tapalcatl/tapalcatl_server</tt></td>
  </tr>
  <tr>
    <td><tt>['tapalcatl']['cfg_file']</tt></td>
    <td>String</td>
    <td>Config file name</td>
    <td><tt>tapalcatl.conf</tt></td>
  </tr>
  <tr>
    <td><tt>['tapalcatl']['cfg_path']</tt></td>
    <td>String</td>
    <td>Config file location</td>
    <td><tt>/etc/tapalcatl</tt></td>
  </tr>
  <tr>
    <td><tt>['tapalcatl']['pattern']</tt></td>
    <td>JSON object</td>
    <td>
        <p>A map of Gorilla Mux patterns to objects describing the metatile storage and upstream server fallback. Each pattern maps a distinct URL path on the Tapalcatl server to a storage source, layer, upstream proxy URL and metatile size. The storage source can be either 'File' for local file storage (which takes a 'BaseDir' subkey) or 'S3' to use S3 (which takes 'Bucket', 'KeyPattern' and 'Prefix' subkeys).</p>
        <p>The S3 KeyPattern and upstream ProxyURL are both interpolated with the variables matches against the input pattern, plus the Layer parameter. The S3 KeyPattern additionally can contain {hash} which is a partial md5 of the pattern <tt>'{layer}/{z}/{x}/{y}.{fmt}'</tt> useful for distributing the filenames.</p>
    </td>
    <td>It's complicated. See the default attributes file for examples.</td>
  </tr>
  <tr>
    <td><tt>['tapalcatl']['listen']</tt></td>
    <td>String</td>
    <td>The `interface:port` to listen on.</td>
    <td><tt>:80</tt></td>
  </tr>
  <tr>
    <td><tt>['tapalcatl']['healthcheck']</tt></td>
    <td>String</td>
    <td>Optional. If present, then the path to respond to healthchecks on.</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['tapalcatl']['mime']</tt></td>
    <td>JSON object</td>
    <td>A map of request extensions to MIME types. This is used to lookup a MIME type for the response headers.</td>
    <td>See the default attributes file for an example.</td>
  </tr>
  <tr>
    <td><tt>['tapalcatl']['poolsize']</tt></td>
    <td>Integer</td>
    <td>Tapalcatl has a buffer pool to reduce GC pressure when copying large amounts of data from the upstream server. The poolsize is the number of buffers to retain, and should be sized to the number of concurrent requests expected.</td>
    <td>10</td>
  </tr>
  <tr>
    <td><tt>['tapalcatl']['poolwidth']</tt></td>
    <td>Integer</td>
    <td>The pool width is the size in bytes to initially assign. Buffers can grow, so it is not necessary to make this particularly large. A good value is the average expected size of the zip files.</td>
    <td>102400</td>
  </tr>
  <tr>
    <td><tt>['tapalcatl']['runit']['timeout']</tt></td>
    <td>Integer</td>
    <td>The time in seconds runit should wait to see if a service starts up successfully.</td>
    <td><tt>60</tt></td>
  </tr>
  <tr>
    <td><tt>['tapalcatl']['user']['create_group']</tt></td>
    <td>Boolean</td>
    <td>Whether to create a group for the user.</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['tapalcatl']['user']['enabled']</tt></td>
    <td>Boolean</td>
    <td>Whether to create a user for tapalcatl.</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['tapalcatl']['user']['home']</tt></td>
    <td>String</td>
    <td>The user's home directory location.</td>
    <td><tt>/home/tapalcatl</tt></td>
  </tr>
  <tr>
    <td><tt>['tapalcatl']['user']['user']</tt></td>
    <td>String</td>
    <td>The user's name.</td>
    <td><tt>tapalcatl</tt></td>
  </tr>
  <tr>
    <td><tt>['tapalcatl']['limits']['open_files']</tt></td>
    <td>Integer</td>
    <td>The maximum number of open file descriptors allowed.</td>
    <td>The value in <tt>/proc/sys/fs/file-max</tt></td>
  </tr>
</table>

Contributing
------------

We welcome contributions to tapalcatl's Chef recipe. To contribute, please use the standard Github workflow:

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------

Copyright Mapzen 2016. Available under the MIT license. See LICENSE for more information.
