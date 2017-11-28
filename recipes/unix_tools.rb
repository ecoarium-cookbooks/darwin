#
# Cookbook Name:: darwin
# Recipe:: unix_tools
#


%w{
  pstree
  watch
  wget
}.each{|package_name|
  package package_name
}
