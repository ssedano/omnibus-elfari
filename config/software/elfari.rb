#
#  https://github.com/ssedano/elfari
#
name "elfari"
version "0.0.1"

dependency "ruby"
dependency "rubygems"
dependency "bundler"
dependency "libyaml"
dependency "libxslt"
dependency "libxml2"
dependency "rsync"

relative_path "elfari"

build do
  build_env = {
    "PATH" => "#{install_dir}/embedded/bin:#{ENV['PATH']}",
    "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
    "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
    "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include/",
    "BUNDLE_BIN_PATH" => "#{install_dir}/embedded/bin/bundle",
    "BUNDLE_GEMFILE" => nil,
    "GEM_HOME" => "#{install_dir}/embedded/lib/ruby/gems/1.9.1",
    "GEM_PATH" => "#{install_dir}/embedded/lib/ruby/gems/1.9.1",
    "RUBYOPT" => nil,
    "LD_LIBRARY_PATH" => "#{install_dir}/embedded/lib"
  }

  command "#{install_dir}/embedded/bin/rsync -a --exclude '.git' --exclude '.gitignore' #{Omnibus::Config.project_root}/elfari #{install_dir}/"
  # command "cp -r #{Omnibus::Config.project_root}/elfari #{install_dir}/"

  command "(cd #{install_dir}/elfari && #{install_dir}/embedded/bin/bundle  install)" , :env => build_env

  command "cat > #{install_dir}/bin/elfari << EOF
#!/usr/bin/env sh
(
export GEM_PATH='#{install_dir}/embedded/lib/ruby/gems/1.9.1'
export GEM_HOME='#{install_dir}/embedded/lib/ruby/gems/1.9.1'
cd elfari
#{install_dir}/embedded/bin/bundle exec #{install_dir}/embedded/bin/ruby  #{install_dir}/elfari/elfari.rb
)
EOF"

  command "chmod 755 #{install_dir}/bin/elfari"
  command "curl https://yt-dl.org/downloads/2014.04.07.4/youtube-dl -o #{install_dir}/embedded/lib/ruby/gems/1.9.1/bundler/gems/ruby-youtube-dl-689cddae9248/bin/youtube-dl.py"
  command "chmod a+x #{install_dir}/embedded/lib/ruby/gems/1.9.1/bundler/gems/ruby-youtube-dl-689cddae9248/bin/youtube-dl.py"

  if OHAI['platform_family'] == 'mac_os_x'
    command "sed -i.bak 's/\\/usr\\/bin\\/mplayer/\\/usr\\/local\\/bin\\/mplayer/g' #{install_dir}/elfari/config/config.yml"
    command "sed -i.bak 's/\\/usr\\/bin\\/vlc/\\/Applications\\/VLC.app\\/Contents\\/MacOS\\/VLC/g' #{install_dir}/elfari/config/config.yml"
    command "rm #{install_dir}/elfari/config/config.yml.bak"
  end
end
