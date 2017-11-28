#
# Cookbook Name:: darwin
# Recipe:: finder
#

{
  ShowStatusBar: 1,
  ShowPathbar: 1,
  NewWindowTarget: 'PfLo',
  NewWindowTargetPath: "file://#{ENV['HOME']}/Projects/",
  FXPreferredViewStyle: 'clmv',
  FXPreferredGroupBy: 'Name',
  FXArrangeGroupViewBy: 'Name',
  FK_ArrangeBy: 'Name',
  FK_SavedViewStyle: 'clmv',
  _FXShowPosixPathInTitle: true,
  AppleShowAllFiles: true
}.each{|key_name,key_value|
  darwin_os_configuration "set #{key_name} to #{key_value}" do
    domain 'com.apple.finder'
    key key_name
    value key_value
  end
}

{

  ENV['USER'] => "file://#{ENV['HOME']}",
  Projects: "file://#{ENV['HOME']}/Projects"
}.each{|shortcut_name,shortcut_path|
  execute "create shortcut #{shortcut_name} to #{shortcut_path}" do
    command "#{File.expand_path('../files', File.dirname(__FILE__))}/mysides add #{shortcut_name} #{shortcut_path}; true"
    user ENV['USER']
  end
}
