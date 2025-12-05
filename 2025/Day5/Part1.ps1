$f = Get-Content .\2025\Day5\1.1.txt

class Interval {
  [UInt64]$Min
  [UInt64]$Max
  [Interval]$Next
  [Interval]$Prev

  Interval([UInt64]$start,[UInt64]$end) {
    if ($start -gt $end) {
      throw "Invalid interval!"
    }
    $this.Min = $start
    $this.Max = $end
    $this.Next = $null # Initialize Next to null
    $this.Prev = $null # Initialize Prev to null
  }

  Display() {
    Write-Host $this.Min ":" $this.Max
  }
}

$products = @()
$intervals = @()
foreach ($line in $f) {
  if ($line -and $line.Contains('-')) {
    $start, $end = $line.Split('-')
    $intervals += [Interval]::new($start, $end)
  }
  elseif ($line) {
    $products += [UInt64]$line
  }
}

$freshCount = 0
# primitive solution > change it later to LinkedList one with merging intervals on a fly
foreach($product in $products) {
  foreach($interval in $intervals) {
    if ($product -ge $interval.Min -and $product -le $interval.Max) {
      $freshCount++
      break
    }
  }
}

Write-Host $freshCount