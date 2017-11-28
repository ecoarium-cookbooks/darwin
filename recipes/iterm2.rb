#
# Cookbook Name:: darwin
# Recipe:: iterm2
#


remote_file "#{Chef::Config[:file_cache_path]}/iterm.zip" do
  source node[:darwin][:iterm][:download_url]
  checksum node[:darwin][:iterm][:checksum]
end

directory node[:darwin][:iterm][:app_path] do
  action :delete
  recursive true
  not_if "[ -e #{node[:darwin][:iterm][:app_path]} ] & defaults read #{node[:darwin][:iterm][:app_path]}/Contents/Info.plist CFBundleVersion | grep #{node[:darwin][:iterm][:version]}"
end

execute 'unzip iterm' do
  creates node[:darwin][:iterm][:app_path]
  command "unzip #{Chef::Config[:file_cache_path]}/iterm.zip -d #{File.dirname(node[:darwin][:iterm][:app_path])}/"
  user ENV['USER']
end

directory node[:darwin][:iterm][:dynamic_profiles][:directory] do
  recursive true
  owner ENV['USER']
end

node[:darwin][:iterm][:dynamic_profiles][:profiles].each{|profile_name,profile_info|

  file "#{profile_name} iterm dynamic profile" do
    path "#{node[:darwin][:iterm][:dynamic_profiles][:directory]}/#{profile_info[:file_name]}"
    content JSON.pretty_generate(profile_info[:content])
    owner ENV['USER']
  end

}
