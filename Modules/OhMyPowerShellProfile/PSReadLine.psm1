function Initialize-PSReadLine {
    $Available = Get-Module -Name PSReadLine -ListAvailable
    if (-Not $Available) {
        return
    }
    $PSReadLineOptions = @{
        HistorySearchCursorMovesToEnd = $true
        PredictionSource = "HistoryAndPlugin"
        Colors = @{
            InlinePrediction = [ConsoleColor]::Blue
            Operator = [ConsoleColor]::Yellow
            Parameter = [ConsoleColor]::Green
        }
    }
    Set-PSReadLineOption @PSReadLineOptions

    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

    # Related: https://github.com/PowerShell/PSReadLine/issues/1778
    Set-PSReadLineKeyHandler -Key Delete `
        -BriefDescription RemoveFromHistory `
        -LongDescription "Removes the content of the current line from history" `
        -ScriptBlock {
        param($key, $arg)

        $line = $null
        $cursor = $null
        [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

        $toRemove = [Regex]::Escape(($line -replace "\n", "```n"))
        $history = Get-Content (Get-PSReadLineOption).HistorySavePath -Raw
        $history = $history -replace "(?m)^$toRemove\r\n", ""
        Set-Content (Get-PSReadLineOption).HistorySavePath $history -NoNewline
    }
}
