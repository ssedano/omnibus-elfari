
name 'elfari'
maintainer 'serafin.sedano@gmail.com'
homepage 'http://github.com/ssedano/elfari'

replaces        'elfari'
install_path    '/opt/elfari'
build_version   '0.0.1'
build_iteration 1

# creates required build directories
dependency 'preparation'

# elfari dependencies/components
dependency 'elfari'

# version manifest file
dependency 'version-manifest'

exclude '\.git*'
exclude 'bundler\/git'
