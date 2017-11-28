#
# Cookbook Name:: darwin
# Recipe:: iterm2
#


remote_file "#{Chef::Config[:file_cache_path]}/iterm.zip" do
  source node[:darwin][:iterm][:download_url]
  owner ENV['USER']
  checksum node[:darwin][:iterm][:checksum]
  not_if  {
    File.exists?(node[:darwin][:iterm][:app_path])
  }
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
