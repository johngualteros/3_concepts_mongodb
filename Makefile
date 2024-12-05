COMPOSE_FILE = docker-compose.yml
DOCKER_COMPOSE = docker-compose

.PHONY: up down init-shards init-sharding logs

up:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) up -d

down:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) down --volumes

init-shards:
	sleep 5
	docker exec -it mongo-config mongosh --port 27001 --eval 'rs.initiate({_id: "configReplSet", configsvr: true, members: [{ _id: 0, host: "mongo-config:27001" }]})'
	docker exec -it mongo-shard1 mongosh --port 27002 --eval 'rs.initiate({_id: "shard1ReplSet", members: [{ _id: 0, host: "mongo-shard1:27002" }]})'
	docker exec -it mongo-shard2 mongosh --port 27003 --eval 'rs.initiate({_id: "shard2ReplSet", members: [{ _id: 0, host: "mongo-shard2:27003" }]})'

init-sharding:
	docker exec -it mongo-router mongosh --eval 'while(!db.runCommand({ping: 1}).ok){ sleep(100); }'
	docker exec -it mongo-router mongosh --eval 'sh.addShard("shard1ReplSet/mongo-shard1:27002"); sh.addShard("shard2ReplSet/mongo-shard2:27003"); sh.enableSharding("torneo"); sh.shardCollection("torneo.encuentros", { fecha: 1 }); sh.shardCollection("torneo.resultados", { encuentro: 1 }); sh.shardCollection("torneo.tabla_posiciones", { temporada: 1 });'

logs:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) logs -f
