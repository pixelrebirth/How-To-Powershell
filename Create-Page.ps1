function Write-TextRange {
    param (
        [int]$min = 50,
        [int]$max = 100,
        [string]$question
    )

    $condition = $false
    while ($condition -eq $false){
        Write-Host ">>>>>>  :" -ForegroundColor Yellow -NoNewline
        $string = Read-Host "$question ($($min)-$($max)w:~$([math]::Round(($max*5)/120))+L)"
        Write-Host "$($string.length / 5) words" -ForegroundColor Cyan
        $condition = $string.length -gt $($min*5) -and $string.length -lt $($max*5)
        if ($condition -eq $false){Write-Host "Error is word length" -ForegroundColor Red}
    }
    return $string #| Check-Spelling -ShowErrors
}

cls
$output = @()

$article_num = 1
$chapter = Read-Host What chapter number is this?
while ($article_num -match "^\d+$"){
    [string]$article_num = Read-Host "What is the article number (spelled out) in the Ideal?"
}
$overarch = Read-Host "What is the `"Overarching Ideal`" of this page?"
$output += "# $overarch | Article | $article_num"
$micro_silly = Write-TextRange -question "What is something silly to subtitle this with" -min 5 -max 20
$output += "##### `_$micro_silly`_"
$output += "-----"
$output += ""

$covered_context  = Read-Host "What is the Covered Context Title?"
$output += "## **$covered_context**"

$output += Write-TextRange -question "What is an analogy to demonstrate this ideal" -min 60 -max 80
$output += ""

$all_list = @()
Write-Host "List a few one line high level comments about this syntax (wq ends)"
while ($list_item -ne "wq"){
    $list_item = Read-Host "*"
    if ($list_item -ne "wq"){
        $all_list += $list_item
    }
}
$all_list | foreach {
    $output += "*  $($_)"
}

$output += Write-TextRange -question "Conceptually demonstrate this ideal" -min 80 -max 100

Write-Host "What are the columns the table should have (wq ends)"
while ($column_item -ne "wq"){
    $column_item = Read-Host ">"
    if ($column_item -ne "wq" -and $column_item -ne ""){$all_columns += "$column_item|"}
}
$output += $all_columns
$output += ""

$all_columns.split("|") | foreach {
    $divider_row += "-----|"
}
$output += $divider_row

Write-Host "Fill the rows with data"
while ($true){
    $quit_table = "NaN"
    $all_columns.split("|") | foreach {
        if ($_ -ne ""){
            $column_content = read-host $_
            $data_row += "$column_content|"
        }
    }
    while ($quit_table -notmatch "^Y$|^N$"){
        $quit_table = Read-Host Quit? Y/N
    }
    $output += $data_row
    $data_row = $null
    if ($quit_table -eq "Y"){break}
}

$output += ""
$output += Write-TextRange -question "What are some technical specifics about this ideal" -min 80 -max 100
$output += ""
$output += Write-TextRange -question "What is a tip you can give for this ideal" -min 10 -max 30
$output += ""
$output += "-----"
$output += "## **Context Examples**"
$output += ""
$output += Write-TextRange -question "What is the objective of this example" -min 40 -max 60
$output += ""

$num = 0
$output += "``````PowerShell"
While ($codeblock -ne "wq"){
    $num++
    $codeblock = read-host Code line $num
    if ($codeblock -eq "wq"){break}
    $output += $codeblock
}
$output += "``````"

$output += ""
$output += Write-TextRange -question "What is the details of this example" -min 60 -max 80

$output += ""
$output += "`[$overarch`]`(images/$($chapter)-$($article_num)-A.gif)"

$output += ""
$img_explain = Write-TextRange -question "Please explain the image" -min 10 -max 30

$output += ""
$output += "> _$img_explain`_"

$output += ""
$output += "-----"
$output += "## **Rhetoric**"
$output += Write-TextRange -question "What is a rhetorical idea/s you can provide for the reader" -min 60 -max 80

$output += ""
$output += "-----"
$output += "## **Answered Exercises**"
$output += Write-TextRange -question "Summarize the excercise" -min 60 -max 80

$output += ""
$all_list = @()
Write-Host "List the steps to the excercise (wq ends)"
while ($excercise_item -ne "wq"){
    $excercise_item = Read-Host "#"
    if ($excercise_item -eq "wq"){break}
    $all_list += $excercise_item
}
$count = 1
$all_list | foreach {
    $output += "$count`. $($_)"
    $count++
}

$output += ""
$output += "[Answer in Appendix A](Appendix-A.md)"

$output += ""
$output += "-----"
$output += "## **Context Examples**"
$output += Write-TextRange -question "Ask about contributing to the GrayMatter Project" -min 20 -max 40

$output += ""
$output += "[GrayMatter Project](https://github.com/pixelrebirth/GrayMatter)"

$output > "Chapter_$($chapter).Article_$($article_num)`.md"

#Output answers to Appendix A after question
#Output terminology to Appendix B
#Fix the table to not have an additional column

return $output
