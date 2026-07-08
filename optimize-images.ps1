param(
    [string]$Path = "c:\Users\Gaming PC\Documents\GitHub\CONFIG_TEST"
)

Add-Type -AssemblyName PresentationCore

Get-ChildItem -Path $Path -Filter '*.png' -File | Where-Object { $_.Name -notlike '*-test.png' } | ForEach-Object {
    $source = $_.FullName
    $temp = [System.IO.Path]::ChangeExtension($source, '.tmp.png')
    $uri = New-Object System.Uri($source)
    $decoder = [System.Windows.Media.Imaging.BitmapDecoder]::Create(
        $uri,
        [System.Windows.Media.Imaging.BitmapCreateOptions]::PreservePixelFormat,
        [System.Windows.Media.Imaging.BitmapCacheOption]::OnLoad
    )
    $encoder = New-Object System.Windows.Media.Imaging.PngBitmapEncoder
    $encoder.Frames.Add($decoder.Frames[0])
    $stream = [System.IO.File]::Open($temp, [System.IO.FileMode]::Create)
    $encoder.Save($stream)
    $stream.Close()
    Move-Item -Force $temp $source
    $newSize = (Get-Item $source).Length
    Write-Host "$($_.Name) => $newSize bytes"
}
