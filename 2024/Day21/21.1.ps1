$DATA_INPUT = Get-Content .\2024\Day21\21.txt

# TODO obtain this table programmatically
$BEST_PATHS = @{
  'A0' = "<";
  '0A' = ">";
  'A1' = "^<<";
  '1A' = ">>v";
  'A2' = "<^";
  '2A' = "v>";
  'A3' = "^";
  '3A' = "v";
  'A4' = "^^<<";
  '4A' = ">>vv";
  'A5' = "<^^";
  '5A' = "vv>";
  'A6' = "^^";
  '6A' = "vv";
  'A7' = "^^^<<";
  '7A' = ">>vvv";
  'A8' = "<^^^";
  '8A' = "vvv>";
  'A9' = "^^^";
  '9A' = "vvv";
  '01' = "^<";
  '10' = ">v";
  '02' = "^";
  '20' = "v";
  '03' = "^>";
  '30' = "<v";
  '04' = "^<^";
  '40' = ">vv";
  '05' = "^^";
  '50' = "vv";
  '06' = "^^>";
  '60' = "<vv";
  '07' = "^^^<";
  '70' = ">vvv";
  '08' = "^^^";
  '80' = "vvv";
  '09' = "^^^>";
  '90' = "<vvv";
  '12' = ">";
  '21' = "<";
  '13' = ">>";
  '31' = "<<";
  '14' = "^";
  '41' = "v";
  '15' = "^>";
  '51' = "<v";
  '16' = "^>>";
  '61' = "<<v";
  '17' = "^^";
  '71' = "vv";
  '18' = "^^>";
  '81' = "<vv";
  '19' = "^^>>";
  '91' = "<<vv";
  '23' = ">";
  '32' = "<";
  '24' = "<^";
  '42' = "v>";
  '25' = "^";
  '52' = "v";
  '26' = "^>";
  '62' = "<v";
  '27' = "<^^";
  '72' = "vv>";
  '28' = "^^";
  '82' = "vv";
  '29' = "^^>";
  '92' = "<vv";
  '34' = "<<^";
  '43' = "v>>";
  '35' = "<^";
  '53' = "v>";
  '36' = "^";
  '63' = "v";
  '37' = "<<^^";
  '73' = "vv>>";
  '38' = "<^^";
  '83' = "vv>";
  '39' = "^^";
  '93' = "vv";
  '45' = ">";
  '54' = "<";
  '46' = ">>";
  '64' = "<<";
  '47' = "^";
  '74' = "v";
  '48' = "^>";
  '84' = "<v";
  '49' = "^>>";
  '94' = "<<v";
  '56' = ">";
  '65' = "<";
  '57' = "<^";
  '75' = "v>";
  '58' = "^";
  '85' = "v";
  '59' = "^>";
  '95' = "<v";
  '67' = "<<^";
  '76' = "v>>";
  '68' = "<^";
  '86' = "v>";
  '69' = "^";
  '96' = "v";
  '78' = ">";
  '87' = "<";
  '79' = ">>";
  '97' = "<<";
  '89' = ">";
  '98' = "<";
  '<^' = ">^";
  '^<' = "v<";
  '<v' = ">";
  'v<' = "<";
  '<>' = ">>";
  '><' = "<<";
  '<A' = ">>^";
  'A<' = "v<<";
  '^v' = "v";
  'v^' = "^";
  '^>' = "v>";
  '>^' = "<^";
  '^A' = ">";
  'A^' = "<";
  'v>' = ">";
  '>v' = "<";
  'vA' = "^>";
  'Av' = "<v";
  '>A' = "^";
  'A>' = "v"
}

function Do-Robot ([hashtable]$sequences) {
  $newSequences = @{}
  foreach($sequence in $sequences.GetEnumerator()) {
    $previous = $ACTIVATE
    for($i = 0; $i -lt $sequence.Key.Length; $i++) {
      $current = $sequence.Key[$i].toString()
      $newSequences["$($BEST_PATHS[$previous+$current] + $ACTIVATE)"] += $sequence.Value
      $previous = $current
    }
  }
  return $newSequences
}

$DIRECTIONAL_LOOP_COUNT = 25
$sum = 0
foreach ($line in $DATA_INPUT) {
  [int]$number = [Regex]::new('(\d+)').Matches($line).Value
  $sequenceMap = @{$line = 1}
  for ($robot = 0; $robot -le $DIRECTIONAL_LOOP_COUNT; $robot++) {
    $sequenceMap = (Do-Robot $sequenceMap)
  }
  $total = 0
  $sequenceMap.GetEnumerator() | ForEach-Object { $total += ($_.Key.Length * $_.value) }
  $sum += ($total * $number)
  $sequenceMap
  Write-Host 'xxxxxxxxxxxxxxxx'
}
Write-Host $sum

# 2 - 248684
# 25 - 307055584161760