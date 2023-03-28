param(
    [string]$sourceDirectory,
    [string]$oldExtension,
    [string]$newExtension
)

Get-ChildItem -Path $sourceDirectory -Filter "*.$oldExtension" | ForEach-Object {
    $newFileName = $_.Name -replace ".$oldExtension", ".$newExtension"
    Rename-Item $_.FullName -NewName $newFileName
}
