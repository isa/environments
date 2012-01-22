# remove any existing aliases
Remove-Item Alias:ls -Force -ErrorAction SilentlyContinue
Remove-Item Alias:ll -Force -ErrorAction SilentlyContinue
Remove-Item Alias:g -Force -ErrorAction SilentlyContinue
Remove-Item Alias:rm -Force -ErrorAction SilentlyContinue

# set the encoding
$OutputEncoding = [text.encoding]::utf8

# custom functions
function pp {
   cd C:\p4\1953\e3\components\omt\bundles\oms\pOMS.main
}

function g {
      param($file)

      gvim --remote-tab-silent $file
}

function shorten-path([string] $path) { 
   $loc = $path.Replace($HOME, '~') 
   # remove prefix for UNC paths 
   $loc = $loc -replace '^[^:]+::', '' 
   # make path shorter like tabs in Vim, 
   # handle paths starting with \\ and . correctly 
   return ($loc -replace '\\(\.?)([^\\])[^\\]*(?=\\)','\$1$2') 
}

function prompt { 
   $green = [ConsoleColor]::Green 
   $blue = [ConsoleColor]::Blue

   write-host "$([char]0x1A9) " -n -f $green
   #write-host ([net.dns]::GetHostName()) -n -f $chost 
   write-host (shorten-path (pwd).Path) -n -f $blue
   write-host " $([char]0x0BB)" -n -f $green
   return ' ' 
}

# source: http://www.gregorystrike.com/2011/01/27/how-to-tell-if-powershell-is-32-bit-or-64-bit/
function ?64 {
    switch ([System.Runtime.InterOpServices.Marshal]::SizeOf([System.IntPtr])) {
        4 { return "32-bit" }
        8 { return "64-bit" }
        default { return "Unknown Type" }
    }
}

# source: http://tasteofpowershell.blogspot.com/2009/02/get-childitem-dir-results-color-coded.html
function ll {
   $regex_opts = ([System.Text.RegularExpressions.RegexOptions]::IgnoreCase `
      -bor [System.Text.RegularExpressions.RegexOptions]::Compiled)

   $fore = $Host.UI.RawUI.ForegroundColor
   $compressed = New-Object System.Text.RegularExpressions.Regex('\.(zip|tar|gz|rar)$', $regex_opts)
   $executable = New-Object System.Text.RegularExpressions.Regex('\.(exe|bat|cmd|py|pl|ps1|psm1|vbs|rb|reg)$', $regex_opts)
   $programming = New-Object System.Text.RegularExpressions.Regex('\.(txt|xml|json|cs|java|properties|html|css|js|cfg|conf|ini|csv|log)$', $regex_opts)

   Invoke-Expression ("Get-ChildItem -Force $args") |
    %{
      if ($_.GetType().Name -eq 'DirectoryInfo') {
        $Host.UI.RawUI.ForegroundColor = 'Green'
        echo $_
        $Host.UI.RawUI.ForegroundColor = $fore
      } elseif ($compressed.IsMatch($_.Name)) {
        $Host.UI.RawUI.ForegroundColor = 'Cyan'
        echo $_
        $Host.UI.RawUI.ForegroundColor = $fore
      } elseif ($executable.IsMatch($_.Name)) {
        $Host.UI.RawUI.ForegroundColor = 'Magenta'
        echo $_
        $Host.UI.RawUI.ForegroundColor = $fore
      } elseif ($programming.IsMatch($_.Name)) {
        $Host.UI.RawUI.ForegroundColor = 'Yellow'
        echo $_
        $Host.UI.RawUI.ForegroundColor = $fore
      } else {
        echo $_
      }
    }
}

function Get-FilesOnly() {
   gci . *.* -rec | where { ! $_.PSIsContainer }
}

function Get-FoldersOnly() {
   gci . *.* -rec | where { $_.PSIsContainer }
}

function Compare-Files($file1, $file2) {
   Compare-Object (Get-Content $file1) (Get-Content $file2) | Where-Object { $_.SideIndicator -eq '=>' } | Select-Object -ExpandProperty InputObject
}
