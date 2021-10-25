# Para hacer login en Azure utilizando un terminal de linux

## Requisitos
- Instalar el az-cli utilizando esta [guia](https://docs.microsoft.com/es-es/cli/azure/install-azure-cli)
- Luego, ejecutar:
```shell
read -sp "Azure password: " AZ_PASS && echo && az login -u <usuario> -p $AZ_PASS
```
- Modificar en el fichero terraform.tfvars los datos de:
```shell
subscription_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
tenant_id       = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
resource_group  = "x-xxxxxxxx-playground-sandbox"
```
