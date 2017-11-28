#
# Cookbook Name:: darwin
# Recipe:: default
#

case node['platform']
when "mac_os_x"
  include_recipe 'dmg'

  include_recipe 'darwin::unix_tools'
  include_recipe 'darwin::iterm2'
  include_recipe 'darwin::finder'
  include_recipe 'darwin::default_editor'
  include_recipe 'darwin::rc_default'
end
