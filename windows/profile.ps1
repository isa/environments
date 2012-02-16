$profile = "$HOME\.environments\windows\profile.ps1"

# remove any of the existing aliases for following
Remove-Item Alias:ls -Force -ErrorAction SilentlyContinue
Remove-Item Alias:ll -Force -ErrorAction SilentlyContinue
Remove-Item Alias:g -Force -ErrorAction SilentlyContinue
Remove-Item Alias:rm -Force -ErrorAction SilentlyContinue
Remove-Item Alias:sp -Force -ErrorAction SilentlyContinue

# set the encoding
$OutputEncoding = [text.encoding]::utf8

# ---- Custom Functions ----
function pp {
   cd $HOME\Projects
}

function e {
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
   $white = [ConsoleColor]::White

   write-host "$([char]0x1A9) " -n -f $green
   write-host (shorten-path (pwd).Path) -n -f $white
   write-host " $([char]0x0BB)" -n -f $green
   return ' '
}

# ---- Powershell Enhancements ----

# custom ternary operator, stupid powershell doesn't have one
function ?: ([scriptblock]$Condition, [scriptblock]$IfTrue, [scriptblock]$IfFlase) {
   if (&$Condition) { &$IfTrue } else { &$IfFalse }
}

# source: http://www.gregorystrike.com/2011/01/27/how-to-tell-if-powershell-is-32-bit-or-64-bit/
function ?64 {
    switch ([System.Runtime.InterOpServices.Marshal]::SizeOf([System.IntPtr])) {
        4 { return "32-bit" }
        8 { return "64-bit" }
        default { return "Unknown Type" }
    }
}

# source: http://poshcode.org/1384
function Get-HostName($fqdm = $true) {
   $ipProperties = [System.Net.NetworkInformation.IPGlobalProperties]::GetIPGlobalProperties()
   if ($fqdm) {
      return $ipProperties.HostName
   }

   return "{0}.{1}" -f $ipProperties.HostName, $ipProperties.DomainName
}

# source: http://stackoverflow.com/questions/5944071/powershell-verbose-output-for-chained-exceptions
function Resolve-Error ($ErrorRecord=$Error[0]) {
   $ErrorRecord | Format-List * -Force
   $ErrorRecord.InvocationInfo | Format-List *
   $Exception = $ErrorRecord.Exception
   for ($i = 0; $Exception; $i++, ($Exception = $Exception.InnerException)) {
      "$i" * 80
      $Exception |Format-List * -Force
   }
}

# based on: http://tasteofpowershell.blogspot.com/2009/02/get-childitem-dir-results-color-coded.html
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
        echo $_
      } elseif ($compressed.IsMatch($_.Name)) {
        $Host.UI.RawUI.ForegroundColor = 'Cyan'
        echo $_
        $Host.UI.RawUI.ForegroundColor = $fore
      } elseif ($executable.IsMatch($_.Name)) {
        $Host.UI.RawUI.ForegroundColor = 'Green'
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

# list all the types with the given object's namespace
function Get-AllTypes($object) {
   $object.GetType().Assembly.GetTypes()
}

# find the total execution time
function Time() {
   $History = Get-History
   write-host $History
   $History[$History.Length].EndExecutionTime - $history[$History.Length].StartExecutionTime
}

# tails a file
function Tail($LogFile) {
   #Get-Content -Path $Log -Wait
   $Content = gc $LogFile
   $Size = $Content.Length

   while($True) {
      $Content = gc $LogFile
      $CurrentSize = $Content.Length

      $Content[$Size .. $CurrentSize]

      $Size = $CurrentSize
   }
}

# find command-lines of given process i.e java, powershell, cmd
function Find-CommandLine($ProcessName) {
   Get-WmiObject Win32_Process -Filter "Name like '%$ProcessName%'" | Select-Object CommandLine
}
