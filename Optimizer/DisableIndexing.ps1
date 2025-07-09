Write-Host "Disabling indexing on development folders..."

$devFolders = @(
    "$env:USERPROFILE\Documents\Coding Workspace"
)

foreach ($folder in $devFolders) {
    if (Test-Path $folder) {
        try {
            attrib +I "$folder" /S /D
            Write-Host "Indexing disabled for: $folder"
        } catch {
            Write-Host "Could not disable indexing for: $folder"
        }
    } else {
        Write-Host "Folder not found: $folder"
    }
}
