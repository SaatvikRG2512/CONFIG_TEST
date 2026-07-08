param(
    [Parameter(Mandatory=$true)]
    [string]$Source,

    [Parameter(Mandatory=$true)]
    [string]$Dest
)

Add-Type -AssemblyName PresentationCore
$uri = New-Object System.Uri($Source)
$decoder = [System.Windows.Media.Imaging.BitmapDecoder]::Create(
    $uri,
    [System.Windows.Media.Imaging.BitmapCreateOptions]::PreservePixelFormat,
    [System.Windows.Media.Imaging.BitmapCacheOption]::OnLoad
)
$frame = $decoder.Frames[0]
$encoder = New-Object System.Windows.Media.Imaging.PngBitmapEncoder
$encoder.Frames.Add($frame)
$stream = [System.IO.File]::Open($Dest, [System.IO.FileMode]::Create)
$encoder.Save($stream)
$stream.Close()

$srcInfo = Get-Item $Source
$destInfo = Get-Item $Dest
Write-Host "Dimensions: $($frame.PixelWidth)x$($frame.PixelHeight)"
Write-Host "Source size: $($srcInfo.Length) bytes"
Write-Host "Dest size:   $($destInfo.Length) bytes"
Write-Host "Savings:     $([math]::Max(0, $srcInfo.Length - $destInfo.Length)) bytes"
