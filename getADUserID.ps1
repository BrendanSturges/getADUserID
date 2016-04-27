Function Get-FileName($initialDirectory){   
	[System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
	$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
	$OpenFileDialog.initialDirectory = $initialDirectory
	$OpenFileDialog.filter = "All files (*.*)| *.*"
	$OpenFileDialog.ShowDialog() | Out-Null
	$OpenFileDialog.filename
}

Function Save-File([string] $initialDirectory ) {
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    $OpenFileDialog = New-Object System.Windows.Forms.SaveFileDialog
    $OpenFileDialog.initialDirectory = $initialDirectory
    $OpenFileDialog.filter = "All files (*.*)| *.*"
    $OpenFileDialog.ShowDialog() |  Out-Null
	
	$nameWithExtension = "$($OpenFileDialog.filename).csv"
	return $nameWithExtension
}


$userList = Get-Content -Path (Get-FileName)
$fileName = Save-File $fileName
$output = @()

$i = 0
Foreach($user in $userlist){

	Try{	
		$UU = (get-aduser -filter 	{ mail -like $user} -properties mail).samaccountname
	}
	Catch{
		$ErrorMessage = $_.Exception.Message
	}

	$info = New-Object -TypeName PSObject -Property @{
			User = $user
			ID = $UU
			Details = $ErrorMessage
			}
	$output += $info
	$i++
	Write-Progress -id 1 -activity "Checking user $i of $($userlist.count)" -percentComplete ($i / $userlist.Count*100)
}

$output | Select User,ID,Details | Export-Csv $fileName -noTypeInformation -append