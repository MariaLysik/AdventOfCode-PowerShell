$f = Get-Content .\2025\Day6\1.0.txt

$addOperand = '+'
$multiplyOperand = '*'
$empty = ' '

[UInt64]$total = 0
[UInt64]$currentValue = $null
$operand = $null
for ($col = 0; $col -lt $f[0].Length; $col++) {
  $allEmpty = $true
  $currentNumber = ''
  for ($i = 0; $i -lt $f.Length-1; $i++) {
    $cur = $f[$i][$col]
    if ($cur -ne $empty) {
      $allEmpty = $false
      $currentNumber += $cur
    }
  }
  if ($allEmpty) {
    $total += $currentValue
    $currentValue = $null
    continue
  }
  $bottomValue = $f[$f.Length-1][$col]
  if ($bottomValue -eq $empty) {
    if ($operand -eq $addOperand) {
      $currentValue += [UInt64]$currentNumber
    }
    elseif ($operand -eq $multiplyOperand) {
      $currentValue *= [UInt64]$currentNumber
    }
    else {
      throw 'operand not picked!'
    }
    #Write-Host 'currentValue' $currentValue
  }
  else {
    $operand = $bottomValue
    #Write-Host 'new operand' $operand
    $currentValue = $currentNumber
    #Write-Host 'currentValue' $currentValue
  }
}
$total += $currentValue

Write-Host 'Part 2:' $total