#
# Cookbook Name:: darwin
# Recipe:: default_editor
#


plist_file = "#{ENV['HOME']}/Library/Preferences/com.apple.LaunchServices/com.apple.launchservices.secure.plist"

execute 'restart launch services register' do
  command '/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -r -domain local -domain system -domain user'
  user ENV['USER']
  action :nothing
  notifies :run, 'execute[restart finder]'
end

execute 'restart finder' do
  command 'killall Finder'
  user ENV['USER']
  action :nothing
end

convert_plist_to_xml_for_plist_buddy_flag_file = '/tmp/convert_plist_to_xml_for_plist_buddy_flag_file'

file 'delete convert plist to xml for plist buddy flag file' do
  action :delete
  path convert_plist_to_xml_for_plist_buddy_flag_file
end

execute 'convert plist to xml for plist buddy' do
  command "plutil -convert xml1 #{plist_file}"
  user ENV['USER']
  creates convert_plist_to_xml_for_plist_buddy_flag_file
  action :nothing
  only_if{
    ::File.exists?(plist_file)
  }
end

node[:darwin][:default_editor][:ls_handlers][:types].each{|ls_handler_type|
  execute "remove ls_handler_type #{ls_handler_type}" do
    command "defaults read #{plist_file} | grep -v 'LSHandlerRoleViewer = \"-\"' | egrep 'LSHandlerContentTag |LSHandlerContentType|LSHandlerURLScheme' | grep -n #{ls_handler_type} | awk -F ':' '{print $1 - 1}' | xargs -I{} /usr/libexec/PlistBuddy -c \"Delete 'LSHandlers:{}'\" #{plist_file}"
    user ENV['USER']
    action :nothing
  end

  log "processing ls_handler_type #{ls_handler_type}" do
    not_if {
      `defaults read #{plist_file} | grep -A4 '#{ls_handler_type}' | grep '#{node[:darwin][:default_editor][:ls_handler_role_all]}'`
      $?.exitstatus == 0
    }
    notifies :run, 'execute[convert plist to xml for plist buddy]', :immediately
    notifies :run, "execute[remove ls_handler_type #{ls_handler_type}]", :immediately
  end

  execute "add ls_handler_type #{ls_handler_type}" do
    command "defaults write #{plist_file} LSHandlers -array-add '{ LSHandlerContentType = \"#{ls_handler_type}\"; LSHandlerRoleAll = \"#{node[:darwin][:default_editor][:ls_handler_role_all]}\"; }'"
    user ENV['USER']
    not_if "defaults read #{plist_file} | grep '#{ls_handler_type}'"
    notifies :run, 'execute[restart launch services register]'
  end
}

node[:darwin][:default_editor][:ls_handlers][:extensions].each{|ls_handler_extension|
  execute "remove ls_handler_extension #{ls_handler_extension}" do
    command "defaults read #{plist_file} | grep -v 'LSHandlerRoleViewer = \"-\"' | egrep 'LSHandlerContentTag |LSHandlerContentType|LSHandlerURLScheme' | grep -n #{ls_handler_extension} | awk -F ':' '{print $1 - 1}' | xargs -I{} /usr/libexec/PlistBuddy -c \"Delete 'LSHandlers:{}'\" #{plist_file}"
    user ENV['USER']
    action :nothing
  end

  log "processing ls_handler_extension #{ls_handler_extension}" do
    not_if {
      `defaults read #{plist_file} | grep -A4 '#{ls_handler_extension}' | grep '#{node[:darwin][:default_editor][:ls_handler_role_all]}'`
      outcome = $?.exitstatus == 0
      if outcome != true
        convert_plist_to_xml_for_plist_buddy = true
      end
      outcome
    }
    notifies :run, 'execute[convert plist to xml for plist buddy]', :immediately
    notifies :run, "execute[remove ls_handler_extension #{ls_handler_extension}]", :immediately
  end

  execute "add ls_handler_extension #{ls_handler_extension}" do
    command "defaults write #{plist_file} LSHandlers -array-add '{ LSHandlerContentTag = \"#{ls_handler_extension}\"; LSHandlerContentTagClass = \"public.filename-extension\"; LSHandlerRoleAll = \"#{node[:darwin][:default_editor][:ls_handler_role_all]}\"; }'"
    user ENV['USER']
    not_if "defaults read #{plist_file} | grep '#{ls_handler_extension}'"
    notifies :run, 'execute[restart launch services register]'
  end
}
