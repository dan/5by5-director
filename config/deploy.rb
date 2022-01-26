lock "~> 3.16.0"

set :application,     "director"
set :repo_url,        "git@github.com:dan/5by5-director.git"
set :branch,          "main"

set :deploy_to,       "/data/sites/director.5by5.tv"
set :deploy_via,      :remote_cache
set :rbenv_type,      :user

set :rbenv_ruby,      "3.1.0"
set :rbenv_prefix,    "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins,  %w{ gem bundle ruby }
set :pty,             true
set :use_sudo,        false
set :stage,           :production
set :format,          :pretty
set :log_level,       :info
set :keep_releases,   2
