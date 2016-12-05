$output = @()

$overarch = Read-Host "What is the `"Overarching Ideal`" of this page?"
$overarch_num = Read-Host "What is the article number (spelled out) in the Ideal?"
$output += "# $overarch | Article | $overarch_num"

$micro_silly = Read-Host "What is something silly to subtitle this with?"
$output += "##### `_$micro_silly`_"
$output += "-----"
$output += ""

$covered_context  = Read-Host "What is the Covered Context Title?"
$output += "## **$covered_context**"

while ($analogical.length -lt 300 -or $analogical.length -gt 350){
    $analogical = Read-Host "What is an analogy to demonstrate this ideal? (60-70w:~2+L)"
    "$($analogical.length / 5) words"
}
$output += $analogical | Check-Spelling -ShowErrors
$output += ""

$all_list = @()
Write-Host "List a few one line high level comments about this syntax (wq ends)"
while ($list_item -ne "wq"){
    $list_item = Read-Host "*"
    $all_list += $list_item
}
$all_list | foreach {
    $output += "*  $($_)"
}

while ($concept.length -lt 500 -or $concept.length -gt 600){
    $concept = Read-Host "What is an analogy to demonstrate this ideal? (100-120w:~4+L)"
    "$($concept.length / 5) words"
}
$output += $concept | Check-Spelling -ShowErrors
$output += ""

Write-Host "What are the columns should the table have (wq ends)"
while ($column_item -ne "wq"){
    $column_item = Read-Host ">"
    if ($column_item -ne "wq" -and $column_item -ne ""){$all_columns += "$column_item|"}
}
$output += $all_columns

Write-Host "Fill the table with information as needed"
$all_columns.split("|") | foreach {
    $divider_row += "-----|"
} 
$output += $divider_row

Write-Host "Fill the rows with data"
while ($true){
    $quit_table = "NaN"
    $all_columns.split("|") | foreach {
        $column_content = read-host $_
        $data_row += "$column_content|"
    }
    while ($quit_table -notmatch "^Y$|^N$"){
        $quit_table = Read-Host Quit? Y/N
    }
    $output += $data_row
    $data_row = $null
    if ($quit_table -eq "Y"){break}
}

return $output

