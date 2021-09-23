#Vérification du statut d'Administrateur. Si le script n'as pas été lancé en admin, ouverture d'un nouveau processus. Merci à l'auteur que je n'ai malheureusement pu retrouver tant il a été copié...
param([switch]$Elevated)

function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Test-Admin) -eq $false)  {
    if ($elevated) {
        # tried to elevate, did not work, aborting
    } else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
    }
    exit
}

Write-Host "Ce script s'execute en Administrateur" -foregroundcolor "yellow"

#Enumération des types de connexions d'un évènement Windows. Merci a theposhwolf.com
enum LogonTypes {
    Interactive = 2
    Network = 3
    Batch = 4
    Service = 5
    Unlock = 7
    NetworkClearText = 8
    NewCredentials = 9
    RemoteInteractive = 10
    CachedInteractive = 11
}

#Déclaration des Valriables
$computer = Read-Host 'Entrez le nom du contrôleur de domaine'
$DAUsers = Get-ADGroupMember -Identity "Administrateurs de l’entreprise" #Modifier si besoin le nom du groupe. Attention, il doit reprendre exactement celui de l'AD
$SDate = (Get-Date).AddDays(-7).ToString("dd/MM/yyyy") #Modifier si besoin l'intervalle en modifiant la valeur du nombre de jours antérieurs
$EDate = (Get-Date).AddDays(1).ToString("dd/MM/yyyy")

#Enumération des évènements windows et tri selon le groupe et le type.

    Get-WinEvent  -Computer $computer -FilterHashtable @{Logname='Security';ID=4624;StartTime=$SDate;EndTime=$EDate} |`
    Where-Object { $_.Properties[5].Value -in $DAUsers.SamAccountName -and ($_.Properties[8].Value -eq 10 -or $_.Properties[8].Value -eq 2)} |`
    ForEach-Object {
 `   [pscustomobject]@{SamAccountName = $_.Properties[5].Value;Time = $_.TimeCreated;WorkstationName = $_.Properties.Value[11];SourceNetworkAddress = $_.Properties.Value[18];LogonType = [LogonTypes]$_.Properties.Value[8]}
    } | Format-Table
