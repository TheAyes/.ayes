{ config, pkgs, inputs, lib, ... }: {
  home.file = {
    "${config.xdg.configHome}/kdeglobals" = {
      text = ''
                [KDE]
                ShowDeleteCommand=false

                [KFileDialog Settings]
                Allow Expansion=true
                Automatically select filename extension=true
                Breadcrumb Navigation=true
                Decoration position=2
                LocationCombo Completionmode=5
                PathCombo Completionmode=5
                Show Bookmarks=false
                Show Full Path=true
                Show Inline Previews=true
                Show Preview=false
                Show Speedbar=true
                Show hidden files=true
                Sort by=Name
                Sort directories first=true
                Sort hidden files last=false
                Sort reversed=false
                Speedbar Width=165
                View Style=DetailTree

                [PreviewSettings]
                MaximumRemoteSize=0

                [General]
                TerminalApplication=kitty
        			'';
    };
  };
}
