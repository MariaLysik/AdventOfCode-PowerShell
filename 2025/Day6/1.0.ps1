$f = Get-Content .\2025\Day6\1.1.txt

$arr = @()
foreach ($line in $f) {
  $arr += ,@($line.Split() | Where-Object { $_ })
}

$total= 0
for($i = 0; $i -lt $arr[0].Length; $i++) {
  $operand = $arr[-1][$i]
  Write-Host $operand
  $currentValue = [UInt64]($arr[0][$i])
  if ($operand -eq '+') {
    # add
    for($j = 1; $j -lt $arr.Length -1; $j++) {
      $currentValue += [UInt64]($arr[$j][$i])
    }
  }
  else {
    #multiply
    for($j = 1; $j -lt $arr.Length -1; $j++) {
      $currentValue *= [UInt64]($arr[$j][$i])
    }
  }
  Write-Host $currentValue
  $total += $currentValue
}

Write-Host 'Part 1:' $total