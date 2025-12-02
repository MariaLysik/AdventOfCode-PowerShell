$DATA_INPUT = Get-Content .\2024\Day24\24.help.txt

function Compute([string]$operation,[string[]]$operands) {
  switch ($operation) {
    'AND' { return ($PROCESSED[$operands[0]] -band $PROCESSED[$operands[1]]) }
    'XOR' { return ($PROCESSED[$operands[0]] -bxor $PROCESSED[$operands[1]]) }
    'OR' { return ($PROCESSED[$operands[0]] -bor $PROCESSED[$operands[1]]) }
  }
}

$PROCESSED = @{} # value - true or false
$READY = @{} # value - number of operands processed
$TODO = @{} # op - AND|OR|XOR, operands - @()
$DEPENDENCY = @{} # input = @() of outputs

$i = 0
do {
  [string]$node, [int]$value = $DATA_INPUT[$i].Split(':')
  $PROCESSED[$node] = $value
  $i++
}
while($DATA_INPUT[$i])
$i++

while ($i -lt $DATA_INPUT.Count) {
  [string]$operand1, [string]$op, [string]$operand2, [string]$arrow, [string]$result  = $DATA_INPUT[$i].Split(' ')
  $TODO[$result] = @{ op = $op; operands = @($operand1, $operand2) }
  $DEPENDENCY[$operand1] += ,$result
  $DEPENDENCY[$operand2] += ,$result
  if ($null -ne $PROCESSED[$operand1]) {
    $READY[$result]++
  }
  if ($null -ne $PROCESSED[$operand2]) {
    $READY[$result]++
  }
  $i++
}

function Get-FullAdder([string]$node) {
  if ($null -ne $TODO[$node]) {
    Write-Host $TODO[$node].operands[0] $TODO[$node].op $TODO[$node].operands[1] '=>' $node
    Get-FullAdder $TODO[$node].operands[0]
    Get-FullAdder $TODO[$node].operands[1]
  }
}
Get-FullAdder 'z33'
$TODO.GetEnumerator() | Where-Object { $_.Key.startsWith('z') -and $_.Value.op -ne 'XOR' } | % {
  Write-Host $_.Key $_.Value.op $_.Value.operands
}

$DEPENDENCY['x33']
$DEPENDENCY['y33']


Write-Host 'and wires'
$TODO.GetEnumerator() | Where-Object { (-Not $_.Key.startsWith('z')) -and 
(-Not $_.Key.startsWith('x')) -and 
(-Not $_.Key.startsWith('y')) -and 
$_.Value.op -eq 'XOR'
} | % {
  Write-Host $_.Key $_.Value.op $_.Value.operands $DEPENDENCY[$_.Key]
}

while ($TODO.Count -gt 0) {
  $READY.GetEnumerator() | Where-Object { $null -eq $PROCESSED[$_.Key] -and $_.Value -gt 1 } | ForEach-Object {
    $PROCESSED[$_.Key] = (Compute $TODO[$_.Key].op $TODO[$_.Key].operands)
    foreach($dep in $DEPENDENCY[$_.Key]) {
      $READY[$dep]++
    }
    $TODO.Remove($_.Key)
  }
}

$xBinaryResult = ''
$PROCESSED.GetEnumerator() | Where-Object { $_.Key.startsWith('x') } | Sort-Object Key -Descending | ForEach-Object {
  $xBinaryResult += $_.Value
}
$x = [convert]::ToInt64($xBinaryResult,2)
$yBinaryResult = ''
$PROCESSED.GetEnumerator() | Where-Object { $_.Key.startsWith('y') } | Sort-Object Key -Descending | ForEach-Object {
  $yBinaryResult += $_.Value
}
$y = [convert]::ToInt64($yBinaryResult,2)
$zBinaryResult = ''
$PROCESSED.GetEnumerator() | Where-Object { $_.Key.startsWith('z') } | Sort-Object Key -Descending | ForEach-Object {
  $zBinaryResult += $_.Value
}
$z = [convert]::ToInt64($zBinaryResult,2)
Write-Host $x 'and' $y '=' $z
$dif = $z - $x - $y
Write-Host $dif

Write-Host 'binary'
' '+$xBinaryResult
' '+$yBinaryResult
$zBinaryResult
'            '+[convert]::ToString($dif,2)

(@('vvm','dgr','dtv','z37','fgc','z12','z29','mtj') | sort) -join ','

#TODO
#find it programmatically
# there is a pattern of this full adder
# z(i) (except first and last) must be produced out of XOR operation on two operands out of which:
  # first is always XOR operation of x(i) and y(i)
  # second is always OR operation on two operands out of which:
    # first is always AND operation on x(i-1) and y(i-1)
    # second is always AND operation on  two operands out of which:
      # first is always XOR operation on x(i-1) and y(i-1)
      # second is always an input to XOR producing z(i-1) and has OR operation
      # AND SO ON

# good to start by filtering z which are not product of XOR and then search for swaps among wires (non x,y,z) that have XOR as operation
# ignore first and last z, first should be a product of x(0) XOR y(0), last should be just a product of OR from above loop