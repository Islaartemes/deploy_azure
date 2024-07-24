# Terraform Azure WordPress Deployment

Este repositório contém um script Terraform para subir uma VM na Azure, configurar Docker na VM e rodar um container com o WordPress.

## Pré-requisitos

1. Terraform instalado - [Instruções](https://www.terraform.io/downloads.html)
2. Azure CLI instalada e configurada - [Instruções](https://docs.microsoft.com/cli/azure/install-azure-cli)

## Passos para execução

1. Clone o repositório:
    ```sh
    git clone <URL do repositório>
    cd terraform-azure-wordpress
    ```

2. Inicialize o Terraform:
    ```sh
    terraform init
    ```

3. Visualize o plano de execução:
    ```sh
    terraform plan
    ```

4. Aplique o plano:
    ```sh
    terraform apply
    ```

5. Após a conclusão, o IP público da VM será exibido como saída. Acesse este IP no seu navegador para ver a instalação do WordPress.

## Limpando os recursos

Para destruir os recursos criados pelo Terraform:
```sh
terraform destroy
