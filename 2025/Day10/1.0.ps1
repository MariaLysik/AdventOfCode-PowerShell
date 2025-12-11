Measure-Command {
  $f = Get-Content .\2025\Day10\1.1.txt

  function Get-LightIndicator([string]$pattern) {
    $pattern = $pattern -replace '\.', '0' -replace '#', '1'
    return [Convert]::ToInt16($pattern, 2)
  }

  function Get-Button([string]$posArray,[int]$maskSize) {
    $positions = @($posArray -split ',')
    $chars = New-Object char[] ($maskSize)
    for ($i=0; $i -lt $maskSize; $i++) { $chars[$i] = '0' }
    foreach ($p in $positions) { $chars[$p] = '1' }
    $newString = -join $chars
    return [Convert]::ToInt16($newString, 2)
  }

  function Get-Buttons([string]$pattern,[int]$maskSize) {
    $masks = @()
    $buttons = [regex]::Matches($pattern, '\((?<round>[^()]+)\)') | ForEach-Object { $_.Groups['round'].Value }
    foreach ($button in $buttons) {
      $n = Get-Button $button $maskSize
      $masks += $n
    }
    return $masks
  }
  
  function Get-IndexCombinations {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][ValidateRange(0, [int]::MaxValue)]
        [int]$N,
        [Parameter(Mandatory)][ValidateRange(0, [int]::MaxValue)]
        [int]$K
    )

    if ($K -gt $N) { return }      # no combinations
    if ($K -eq 0) { ,@() ; return }# one empty combination

    # Start with [0,1,2,...,K-1]
    $idx = 0..($K - 1)

    while ($true) {
        # Emit a copy of current indices (adjusted if one-based)
        $emit = $idx.Clone()
        ,$emit

        # Find rightmost index that can be incremented
        $pos = $K - 1
        while ($pos -ge 0 -and $idx[$pos] -eq $pos + $N - $K) { $pos-- }
        if ($pos -lt 0) { break }  # done

        # Increment that index and fix the tail
        $idx[$pos]++
        for ($j = $pos + 1; $j -lt $K; $j++) { $idx[$j] = $idx[$j - 1] + 1 }
    }
  }

  function Get-KSubsets {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][object[]]$Set,
        [Parameter(Mandatory)][ValidateRange(0, [int]::MaxValue)]
        [int]$K
    )

    $n = $Set.Length
    if ($K -gt $n) { return }
    if ($K -eq 0) { ,@() ; return }

    foreach ($indices in Get-IndexCombinations -N $n -K $K) {
      # Emit the K-element subset as a single pipeline object (array)
      ,($indices | ForEach-Object { $Set[$_] })
    }
  }

  function Get-MinButtonPresses ($expected, $masks) {
    if ($masks -contains $expected) {
      return 1
    }
    # check binary XOR on all subsets of masks
    for ($size = 2; $size -lt $masks.Count; $size++) {
      $subsets = Get-KSubsets -Set $masks -K $size
      foreach ($subset in $subsets) {
        $current = $subset[0]
        for ($i = 1; $i -lt $size; $i++) {
          $current = $current -bxor $subset[$i]
        }
        if ($current -eq $expected) {
          return $size
        }
      }
    }
    return $masks.Count
  }

  $totalButtonPresses = 0
  foreach ($line in $f) {
    Write-Host $line
    ($line  -match '\[(.*?)\]') | Out-Null
    $maskSize = $matches[1].Length
    Write-Host 'mask size' $maskSize
    $expected = Get-LightIndicator $matches[1]
    Write-Host 'expected' $expected
    $masks = Get-Buttons $line $maskSize
    Write-Host 'masks' $masks
    $bp = Get-MinButtonPresses $expected $masks
    $totalButtonPresses += $bp
  }
  Write-Host "Part 1:" $totalButtonPresses
}