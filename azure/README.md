# Para hace login utilizando un terminal de linux

## Requisitos
- Instalar el az cli utilizando esta [guia](https://docs.microsoft.com/es-es/cli/azure/install-azure-cli)
- Luego, ejecutar:
```shell
read -sp "Azure password: " AZ_PASS && echo && az login -u <usuario> -p $AZ_PASS
```
