name             'tapalcatl'
maintainer       'Mapzen'
maintainer_email 'matt.amos@mapzen.com'
license          'MIT'
description      'Installs/Configures tapalcatl'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.0.1'

recipe 'tapalcatl', 'Installs Tapalcatl'

%w(
  apt
  runit
  user
).each do |dep|
  depends dep
end

%w(ubuntu).each do |os|
  supports os
end
