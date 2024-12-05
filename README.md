### Particionamineto de mongodb


levantar los contenedores

```bash
make up
```

Configurar los shards
```bash
make init-shards
```

Configurar el sharding:
```bash
make init-sharding
```
Ver logs:
```bash
make logs
```
Detener y limpiar los contenedores:
```bash
make down
```

Verificar el estado
```bash
docker exec -it mongo-router mongosh --eval 'sh.status()'
```