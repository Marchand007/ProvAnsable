$clientname = $args
$configDirClientnameExist = Test-Path("~/Project/NewTech/commun/config/$clientname")
$dirClientnameExist = Test-Path("~/Project/NewTech/commun/$clientname")

$principal = new-object System.Security.Principal.WindowsPrincipal([System.Security.Principal.WindowsIdentity]::GetCurrent())

if (!$principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) {
    $stopascii = get-content -path ~/Project/NewTech/commun/stop.txt
    Write-Output $stopascii
}
else {
    if ($clientname -and !$configDirClientnameExist -and !$dirClientnameExist) {

        $next = get-content ~/Project/NewTech/commun/next.txt
        $nextint = [int]$next

        New-Item -Path ~/Project/NewTech/commun/config -Name "$clientname" -ItemType Directory
        $vagrantfiletemplate = get-content -path ~/Project/NewTech/commun/Vagrantfile.template

        mkdir ~/Project/NewTech/commun/$clientname

        New-Item -Path ~/Project/NewTech/commun/$clientname -Name Vagrantfile -ItemType File

        Set-Content -path ~/Project/NewTech/commun/$clientname/Vagrantfile -Value $vagrantfiletemplate.replace('{{ip1}}', $nextint).replace('{{ip2}}', $nextint + 1).replace('{{ip3}}', $nextint + 2)

        Add-Content ~/Project/NewTech/config/hosts -Value [$clientname]
        Add-Content ~/Project/NewTech/config/hosts -Value ("192.168.33." + $nextint)
        Add-Content ~/Project/NewTech/config/hosts -Value ("192.168.33." + ($nextint + 1))
        Add-Content ~/Project/NewTech/config/hosts -Value ("192.168.33." + ($nextint + 2))

        set-content -Path ~/Project/NewTech/commun/next.txt -Value ($nextint + 3)


        $title = "Ajout d'entrée"
        $question = "Voulez-vous utiliser $clientname.com et api.$clientname.com sur votre machine hôte?"
        $choices = '&Oui', '&Non'

        $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)

        if ($decision -eq 0) {
            Write-Host 'Configuration confirmée'
            add-content -Path C:\Windows\System32\drivers\etc\hosts -Value (("192.168.33." + $nextint) + (" $clientname.com"))
            add-content -Path C:\Windows\System32\drivers\etc\hosts -Value (("192.168.33." + ($nextint + 1)) + (" api.$clientname.com"))
        }
        else {
            Write-Host 'Action non validé'
        }

        


    }
}