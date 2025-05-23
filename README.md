# Azure VM Manager Script

Este script PowerShell permite **criar**, **reiniciar** ou **deletar** máquinas virtuais (VMs) no Microsoft Azure de forma interativa. Ele foi projetado para funcionar com **Managed Identity**, **Azure Key Vault** e uma URL de webhook para o provisionamento das VMs.

## 📌 Funcionalidades

- **CREATE**: Cria uma VM enviando uma requisição para uma URL segura (armazenada no Key Vault).
- **RESTART**: Reinicia uma VM existente.
- **DELETE**: Deleta uma VM existente (com confirmação).

## ⚙️ Requisitos

- PowerShell 7+
- Módulo `Az` instalado (`Install-Module -Name Az`)
- Managed Identity habilitada (ou login manual com `Connect-AzAccount`)
- Permissões adequadas no Azure:
  - Leitura no Key Vault
  - Permissões de VM para restart e delete
- Acesso ao Azure Key Vault com os segredos necessários

## 📁 Estrutura
```
├── VM_Deploy_Delete_Restart.ps1 # Script principal
└── README.md # Este arquivo
```
## ▶️ Como usar

1. Abra um terminal PowerShell no diretório do script.
2. Execute o script:

   ```powershell
   .\manage-vm.ps1

3. Siga as instruções interativas:
- Escolha entre CREATE, RESTART ou DELETE.
- Informe o nome da VM.

## 🧠 Como funciona
- CREATE: Obtém a URL do webhook do Key Vault e envia um POST com o nome da VM.

- RESTART: Recupera o Resource Group da VM e executa Restart-AzVM.

- DELETE: Recupera o Resource Group da VM e executa Remove-AzVM após confirmação do usuário.

## 🔐 Segurança

O uso de .env mantém informações sensíveis fora do código fonte, permitindo versionamento seguro.

O script foi projetado para funcionar com Managed Identity, garantindo maior segurança em automações como Azure Automation, pipelines CI/CD, entre outros.
