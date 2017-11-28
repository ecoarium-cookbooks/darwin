

default[:darwin][:project][:name] = $WORKSPACE_SETTINGS[:project][:name]
default[:darwin][:project][:home] = $WORKSPACE_SETTINGS[:paths][:project][:home]

default[:darwin][:iterm][:download_url] = 'https://iterm2.com/downloads/beta/iTerm2-2_9_20160206.zip'
default[:darwin][:iterm][:checksum] = 'b9c680b089bad6829246019e1ebb24017992fbbbd89d58b13f0ac6d9816ff5a5'

default[:darwin][:iterm][:app_path] = '/Applications/iTerm.app'
default[:darwin][:iterm][:dynamic_profiles][:directory] = "#{ENV['HOME']}/Library/Application Support/iTerm2/DynamicProfiles"

default[:darwin][:iterm][:dynamic_profiles][:profiles][:project] = {
  file_name: "#{node[:darwin][:project][:name]}.json",
  content: {
    Profiles: [
      {
        Name: "#{node[:darwin][:project][:name]}",
        Guid: "#{node[:darwin][:project][:name]}",
        "Dynamic Profile Parent Name" => "ecosystem-base",
        "Working Directory" => node[:darwin][:project][:home],
        "Initial Text" => "bash --init-file #{node[:darwin][:project][:home]}/.ecosystem",
        'Semantic History' => {
          'action' => 'command',
          'text' => "#{$WORKSPACE_SETTINGS[:ecosystem][:paths][:shell][:lib][:home]}/goodies/bin/iterm-semantic-history-shim \"\\1:\\2\""
        }
      }
    ]
  }
}

default[:darwin][:iterm][:dynamic_profiles][:profiles][:base] = {
  file_name: '0-ecosystem-base.json',
  content: {
    Profiles: [
      {
        Name: 'ecosystem-base',
        Guid: 'ecosystem-base',
        'Keyboard Map' => {
          '0xf702-0x380000' => {
            'Text' => "",
            'Action' => 2
          },

          '0xf703-0x300000' => {
            'Text' => "[F",
            'Action' => 10
          },

          '0xf702-0x300000' => {
            'Text' => "[H",
            'Action' => 10
          },

          '0xf703-0x280000' => {
            'Text' => 'f',
            'Action' => 10
          },

          '0xf703-0x320000' => {
            'Text' => "",
            'Action' => 34
          },

          '0xf702-0x280000' => {
            'Text' => 'b',
            'Action' => 10
          },

          '0xf702-0x320000' => {
            'Text' => "",
            'Action' => 33
          },
          '0xf703-0x380000' => {
            'Text' => "",
            'Action' => 0
          },
        }
      }
    ]
  }
}



default[:darwin][:default_editor][:ls_handler_role_all] = 'com.github.atom'

default[:darwin][:default_editor][:ls_handlers] = {
  types: %w{
    public.perl-script
    public.shell-script
    public.plain-text
    public.xml
    public.xhtml
    public.utf8-tab-separated-values-text
    public.utf8-plain-text
    public.utf16-plain-text
    public.utf16-external-plain-text
    public.source-code
    public.text
    public.data
    public.ruby-script
    public.bash-script
    com.apple.traditional-mac-plain-text
    com.apple.iwork.pages.sfftemplate
    com.apple.log
    com.apple.property-list
  },
  extensions: %w{
    berks
    erb
    out
    lock
    kin
    feature
    gradle
    cfg
    info
    berksfile
    err
    apple-script
    ps1
    cmd
    dist
    vcxproj
    vcproj
    sh
    bash
    md
    ecosystem
    yml
    gitignore
  }
}
