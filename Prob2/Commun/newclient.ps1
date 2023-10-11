$clientname = $args

$isAdmin = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")
if ($isAdmin) {
    $dirTravailExist = Test-Path("C:\Travail\ClientsRepo")
    if (!$dirTravailExist) {
        mkdir "C:\Travail\ClientsRepo"
    }
    $clientRepoExist = Test-Path -Path "C:\Travail\ClientsRepo\$clientname"
    if ($clientname -and !$clientRepoExist) {
        $githubAccessToken = $env:GITHUBACCESSTOKEN

        Set-Location "C:\Travail\ClientsRepo"
    

        $repoName = $clientname
        $pat = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($githubAccessToken)"))
        $body = @{
            name        = "$repoName"
            description = "Repository for '$clientname'"
            auto_init   = $true
        }
        $params = @{
            'Uri'         = ('https://api.github.com/user/repos')
            'Headers'     = @{'Authorization' = 'Basic ' + $pat }
            'Method'      = 'Post'
            'ContentType' = 'application/json'
            'Body'        = ($body | ConvertTo-Json)
        }
        $response = Invoke-RestMethod @params

        if ($response) {
            $repoCloneUrl = $response.clone_url
            git clone $repoCloneUrl

            $htmlTemplate = Get-Content "$PSScriptRoot\template\index.html"
            $cssTemplate = Get-Content "$PSScriptRoot\template\style.css"

            Set-Location "$repoName"

            #New-Item "README.md" -ItemType File
            New-Item "index.html" -ItemType File
            New-Item "style.css" -ItemType File
            #Set-Content README.md -Value "# $clientname"
            Set-Content index.html -Value $htmlTemplate.replace('{{ClientName}}', $clientname)
            Set-Content style.css -Value $cssTemplate

            $sourceIMG = "$PSScriptRoot\template\img"
            $destinationIMG = "C:\Travail\ClientsRepo\$repoName"
            Copy-Item -Path $sourceIMG -Destination $destinationIMG -Recurse

            git add .
            git commit -m "Initial commit with Readme, Index.html & style.css"

            git push origin main
            Write-Output "Fichiers ajoutés au repo $repoName"

            #Install-Module -Name Az -Repository PSGallery -Force (A METTRE DANS LE README)
            Connect-AzAccount

            $resourceGroupName = "$clientName-ResGroup";      
            New-AzResourceGroup `
                -Name $resourceGroupName `
                -Location canadacentral
            
            # $adminUser = Read-Host "Entrez un nom d'administrateur "
            # $tempAdminPass = Read-Host "Veuillez entrer un mot de passe " -AsSecureString
            $adminUser = "maximefrank"
            $adminPass = ConvertTo-SecureString -String "MaxEtFrank&666" -AsPlainText -Force
            $credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $adminUser, $adminPass 
            
            New-AzVm `
                -ResourceGroupName $resourceGroupName `
                -Name $clientName"-static" `
                -ImageName Debian11 `
                -Size Standard_B1s `
                -Location canadacentral `
                -VirtualNetworkName $clientName"-vnet" `
                -PublicIpAddressName $clientName"-static-Ip" `
                -OpenPorts 22, 80, 443 `
                -Credential $credential
            
            New-AzVm `
                -ResourceGroupName $resourceGroupName `
                -Name $clientName"-httpd" `
                -ImageName Debian11 `
                -Size Standard_B1s `
                -Location canadacentral `
                -VirtualNetworkName $clientName"-vnet" `
                -PublicIpAddressName $clientName"-httpd-Ip" `
                -OpenPorts 22, 80, 443 `
                -Credential $credential `
                -SubnetName $clientName"-static"
            
            New-AzVm `
                -ResourceGroupName $resourceGroupName `
                -Name $clientName"-postgresql" `
                -ImageName Debian11 `
                -Size Standard_B1s `
                -Location canadacentral `
                -VirtualNetworkName $clientName"-vnet" `
                -PublicIpAddressName $clientName"-postgresql-Ip" `
                -OpenPorts 22, 80, 443 `
                -Credential $credential `
                -SubnetName $clientName"-static"
            
 
            $staticVMPublicIp = Get-AzPublicIpAddress -Name $clientName"-static-ip" -ResourceGroupName $resourceGroupName
            $httpdVMPublicIp = Get-AzPublicIpAddress -Name $clientName"-httpd-ip" -ResourceGroupName $resourceGroupName
            $postgresqlVMPublicIp = Get-AzPublicIpAddress -Name $clientName"-postgresql-ip" -ResourceGroupName $resourceGroupName

            Add-Content $PSScriptRoot/config/hosts -Value [$clientname]
            Add-Content $PSScriptRoot/config/hosts -Value ($staticVMPublicIp.IpAddress + " ansible_ssh_user=" + $adminUser) 
            Add-Content $PSScriptRoot/config/hosts -Value ($httpdVMPublicIp.IpAddress + " ansible_ssh_user=" + $adminUser)
            Add-Content $PSScriptRoot/config/hosts -Value ($postgresqlVMPublicIp.IpAddress + " ansible_ssh_user=" + $adminUser)
            Add-Content $PSScriptRoot/config/hosts -Value ""

            New-Item -Path $PSScriptRoot/config -Name "$clientname" -ItemType Directory

            Copy-Item "$PSScriptRoot/template/upgrade.yml.template" -Destination "$PSScriptRoot/config/$clientname/upgrade.yml"
            $content = Get-Content -Path "$PSScriptRoot/config/$clientname/upgrade.yml"
            $content = $content -replace '{{ClientName}}', ($clientname)
            Set-Content "$PSScriptRoot/config/$clientname/upgrade.yml" -Value $content
            

            Copy-Item "$PSScriptRoot/template/install-static.yml.template" -Destination "$PSScriptRoot/config/$clientname/install-static.yml"
            $content = Get-Content -Path "$PSScriptRoot/config/$clientname/install-static.yml"
            $content = $content -replace '{{ip1}}', ($staticVMPublicIp.IpAddress)
            $content = $content -replace '{{becomeuser}}', ($adminUser)
            Set-Content "$PSScriptRoot/config/$clientname/install-static.yml" -Value $content

            Copy-Item "$PSScriptRoot/template/install-httpd.yml.template" -Destination "$PSScriptRoot/config/$clientname/install-httpd.yml"
            $content = Get-Content -Path "$PSScriptRoot/config/$clientname/install-httpd.yml"
            $content = $content -replace '{{ip2}}', ($httpdVMPublicIp.IpAddress)
            $content = $content -replace '{{becomeuser}}', ($adminUser)
            Set-Content "$PSScriptRoot/config/$clientname/install-httpd.yml" -Value $content
        
            Copy-Item "$PSScriptRoot/template/install-postgresql.yml.template" -Destination "$PSScriptRoot/config/$clientname/install-postgresql.yml"
            $content = Get-Content -Path "$PSScriptRoot/config/$clientname/install-postgresql.yml"
            $content = $content -replace '{{ip3}}', ($postgresqlVMPublicIp.IpAddress)
            $content = $content -replace '{{becomeuser}}', ($adminUser)
            $content = $content -replace '{{db_name}}', ($clientname + "-db")
            $content = $content -replace '{{db_user}}', ($clientname)
            $content = $content -replace '{{password}}', ($clientname + '12345*')
            $content = $content -replace '{{adminuser}}', ($adminUser)
            Set-Content "$PSScriptRoot/config/$clientname/install-postgresql.yml" -Value $content
        
            Copy-Item "$PSScriptRoot/template/setupssh.sh.template" -Destination "$PSScriptRoot/config/$clientname/setupssh.sh"
            $content = Get-Content -Path "$PSScriptRoot/config/$clientname/setupssh.sh"
            $content = $content -replace '{{ip1}}', ($staticVMPublicIp.IpAddress)
            $content = $content -replace '{{ip2}}', ($httpdVMPublicIp.IpAddress)
            $content = $content -replace '{{ip3}}', ($postgresqlVMPublicIp.IpAddress)
            $content = $content -replace '{{user}}', ($adminUser)
            Set-Content "$PSScriptRoot/config/$clientname/setupssh.sh" -Value $content
        
            Copy-Item "$PSScriptRoot/template/playbook.sh.template" -Destination "$PSScriptRoot/config/$clientname/playbook.sh"
            $content = Get-Content -Path "$PSScriptRoot/config/$clientname/playbook.sh"
            $content = $content -replace '{{ClientName}}', ($clientname)
            Set-Content "$PSScriptRoot/config/$clientname/playbook.sh" -Value $content

            Copy-Item "$PSScriptRoot/template/clone-repo.yml.template" -Destination "$PSScriptRoot/config/$clientname/clone-repo.yml"
            $content = Get-Content -Path "$PSScriptRoot/config/$clientname/clone-repo.yml"
            $content = $content -replace '{{ip1}}', ($staticVMPublicIp.IpAddress)
            $content = $content -replace '{{reponame}}', ($repoCloneUrl)
            Set-Content "$PSScriptRoot/config/$clientname/clone-repo.yml" -Value $content

            Set-Location "$PSScriptRoot"

        }
        else {
            Write-Output "Creation du repo est un échec"
        }
    }
}
else {
    Write-Output "Vous devez etre administrateur pour pouvoir executer ce script"
}