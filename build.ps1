Push-Location $PSScriptRoot

Push-Location 'src\PowerShell.Cmdletization.OData'

dotnet restore
dotnet build

Pop-Location

Remove-Item 'Microsoft.PowerShell.ODataUtils' -Recurse -Force -ErrorAction SilentlyCOntinue

$moduleVersionLine = Select-String -Path 'src\ModuleGeneration\Microsoft.PowerShell.ODataUtils.psd1' -Pattern 'ModuleVersion' -SimpleMatch
$moduleVersion = $moduleVersionLine.Line.Split("'")[1]
$moduleDir = New-Item -ItemType Directory "Microsoft.PowerShell.ODataUtils\$moduleVersion"
Copy-Item 'src\ModuleGeneration\*' $moduleDir -Recurse -Force

$moduleDirCoreCLR = Join-Path $moduleDir 'CoreCLR'
$moduleDirFullCLR = Join-Path $moduleDir 'FullCLR'
New-Item -ItemType Directory $moduleDirCoreCLR | Out-Null
New-Item -ItemType Directory $moduleDirFullCLR | Out-Null

Copy-Item 'src\PowerShell.Cmdletization.OData\bin\Debug\net472\PowerShell.Cmdletization.OData.dll' $moduleDirFullCLR
Copy-Item 'src\PowerShell.Cmdletization.OData\bin\Debug\net7.0\PowerShell.Cmdletization.OData.dll' $moduleDirCoreCLR

Pop-Location
