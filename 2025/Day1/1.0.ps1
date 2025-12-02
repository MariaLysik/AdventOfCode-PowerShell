$countOfZeros = 0
$countOfClicks = 0
$currentPosition = 50
$modulo = 100

function Convert-ToNumber([string]$s) {
  $value = [int]($s.substring(1))
  if ($s[0] -eq 'L') {
    return -$value
  }
  return $value
}

function Get-FullCircles([int]$number) {
  if ($number -lt 0) {
    return [Math]::Abs([Math]::Ceiling($number/$modulo))
  }
  return [Math]::Abs([Math]::Floor($number/$modulo))
}

Write-Host 'starting at position' $currentPosition

Get-Content .\2025\Day1\1.0.txt | ForEach-Object {
  Write-Host 'move' $_
  $currentNumber = Convert-ToNumber $_
  if ($currentNumber -eq 0) {
    Write-Host 'no move, skipping'
    return
  }

  $fullCircles = Get-FullCircles $currentNumber
  if ($fullCircles) {
    Write-Host 'full circles' $fullCircles
    $countOfClicks += $fullCircles
    $currentNumber %= $modulo
  }

  $nextPosition = $currentPosition + $currentNumber

  if ($nextPosition -ge $modulo) {
    Write-Host 'clicking 0 from left'
    $countOfClicks++
  }
  elseif ($nextPosition -le 0 -and $currentPosition -ne 0) {
    Write-Host 'clicking 0 from right'
    $countOfClicks++
  }

  $currentPosition = ($nextPosition + $modulo) % $modulo
  if ($currentPosition -eq 0) {
    $countOfZeros++
  }

  Write-Host 'current position' $currentPosition
}

Write-Host 'Part 1:' $countOfZeros
Write-Host 'Part 2:' $countOfClicks