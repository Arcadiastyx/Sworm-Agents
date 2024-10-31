function Invoke-Translation {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Text
    )

    $body = @{
        text = $Text
    } | ConvertTo-Json

    try {
        $response = Invoke-RestMethod -Method Post -Uri "http://localhost:5000/process" -ContentType "application/json" -Body $body
        
        Write-Host "`nRésultats:" -ForegroundColor Green
        Write-Host "Original: " -NoNewline -ForegroundColor Yellow
        Write-Host $response.original
        Write-Host "Traduction: " -NoNewline -ForegroundColor Cyan
        Write-Host $response.translated
        Write-Host "Version corrigée: " -NoNewline -ForegroundColor Magenta
        Write-Host $response.final
    }
    catch {
        Write-Host "Erreur: $_" -ForegroundColor Red
    }
}

# Interface interactive
while ($true) {
    Write-Host "`nEntrez votre texte (ou 'quit' pour sortir):" -ForegroundColor Green
    $input = Read-Host
    
    if ($input -eq 'quit') { break }
    
    Invoke-Translation -Text $input
} 