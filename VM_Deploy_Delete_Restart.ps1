param()

# Carregar .env
Load-EnvFile

# Obter variáveis do ambiente
$kvName = $env:KEYVAULT_NAME
$deploySecretName = $env:WEBHOOK_DEPLOY_URL_SECRET_NAME
$subscriptionName = $env:SUBSCRIPTION_NAME

function Get-UserInput {
    param(
        [string]$Prompt,
        [bool]$Mandatory = $true
    )
    do {
        $input = Read-Host $Prompt
        if (-not $Mandatory -or $input) {
            return $input
        } else {
            Write-Host "Valor obrigatório. Tente novamente." -ForegroundColor Yellow
        }
    } while ($true)
}

# Login e assinatura
Write-Host "[*] Conectando ao Azure..." -ForegroundColor Cyan
Connect-AzAccount -Identity
Select-AzSubscription -SubscriptionName $subscriptionName

# Ação
$action = Read-Host "Escolha a ação (CREATE, RESTART, DELETE)"
$action = $action.ToUpper()
if ($action -notin @("CREATE", "RESTART", "DELETE")) {
    Write-Host "Ação inválida. Use CREATE, RESTART ou DELETE." -ForegroundColor Red
    exit
}

# Nome da VM
$vm_name = Get-UserInput -Prompt "Digite o nome da VM"

# Ações
switch ($action) {
    "CREATE" {
        $uri = Get-AzKeyVaultSecret -VaultName $kvName -Name $deploySecretName -AsPlainText
        $body = @{ hostname = $vm_name } | ConvertTo-Json
        Write-Host "[*] Enviando requisição para criar a VM '$vm_name'..." -ForegroundColor Cyan
        Invoke-RestMethod -Method POST -Uri $uri -Body $body -ContentType 'application/json'
        Write-Host "Requisição de criação enviada." -ForegroundColor Green
    }

    "RESTART" {
        Write-Host "[*] Reiniciando a VM '$vm_name'..." -ForegroundColor Cyan
        Restart-AzVM -Name $vm_name -ResourceGroupName (Get-AzVM -Name $vm_name).ResourceGroupName
        Write-Host "VM reiniciada." -ForegroundColor Green
    }

    "DELETE" {
        $vm = Get-AzVM -Name $vm_name
        $confirmation = Read-Host "Tem certeza que deseja deletar a VM '$vm_name'? (y/n)"
        if ($confirmation -eq 'y') {
            Write-Host "[*] Deletando a VM '$vm_name'..." -ForegroundColor Cyan
            Remove-AzVM -Name $vm_name -ResourceGroupName $vm.ResourceGroupName -Force
            Write-Host "VM deletada." -ForegroundColor Green
        } else {
            Write-Host "Operação cancelada." -ForegroundColor Yellow
        }
    }
}
