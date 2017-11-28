#
# Cookbook Name:: darwin
# Recipe:: rc_default
#


remote_file "#{Chef::Config[:file_cache_path]}/RCDefaultApp.dmg" do
  source 'http://www.rubicode.com/Downloads/RCDefaultApp-2.1.X.dmg'
  checksum 'eb940bf74628f94ac3bfe39e360cb8fb8bbbc9a3c314d2214d5f1476b5d8b6a4'
end

execute 'mount' do
  command "hdiutil attach #{Chef::Config[:file_cache_path]}/RCDefaultApp.dmg"
  not_if do ::File.directory?('/Volumes/RCDefaultApp-2.1.X') end
end

execute 'move RCDefaultApp.prefPane' do
  command 'cp -a /Volumes/RCDefaultApp-2.1.X/RCDefaultApp.prefPane /Library/PreferencePanes/RCDefaultApp.prefPane'
  not_if do ::File.directory?('/Library/PreferencePanes/RCDefaultApp.prefPane') end
end

unmount = execute 'unmount' do
  command 'hdiutil detach /Volumes/RCDefaultApp-2.1.X'
  only_if do ::File.directory?('/Volumes/RCDefaultApp-2.1.X') end
end

Chef.event_handler do
  on :resource_failed do |resource, action, exception|
    unmount.run_action(:run)
    raise "The resource #{resource} failed to load due to an exception: #{exception}"
  end
end
