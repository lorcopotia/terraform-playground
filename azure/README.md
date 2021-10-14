# Para hace login utilizando un terminal de linux

Ejecutar:
```shell
read -sp "Azure password: " AZ_PASS && echo && az login -u <usuario> -p $AZ_PASS
```
