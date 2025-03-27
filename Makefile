.PHONY: up down rebuild logs mysql psql redis clean

# Default target
all: up

# Start all services
up:
	docker-compose -f deploy/docker-compose.develop.yml up -d

# Stop all services
down:
	docker-compose -f deploy/docker-compose.develop.yml down

# Rebuild services
rebuild:
	docker-compose -f deploy/docker-compose.develop.yml down
	docker-compose -f deploy/docker-compose.develop.yml build --no-cache
	docker-compose -f deploy/docker-compose.develop.yml up -d

# View logs
logs:
	docker-compose -f deploy/docker-compose.develop.yml logs -f

# Access MySQL CLI
mysql:
	docker exec -it api.mysql mysql -uuser -p${MYSQL_PASSWORD} database

# Access TimescaleDB CLI
psql:
	docker exec -it api.timescaledb psql -U ${POSTGRES_USER} -d ${POSTGRES_DB}

# Access Redis CLI
redis:
	docker exec -it api.redis redis-cli

# Clean up volumes and containers
clean:
	docker-compose -f deploy/docker-compose.develop.yml down -v
	docker system prune -f

# Show help
help:
	@echo "Available commands:"
	@echo "  make up      - Start all services"
	@echo "  make down    - Stop all services"
	@echo "  make rebuild - Rebuild all services"
	@echo "  make logs    - View service logs"
	@echo "  make mysql   - Access MySQL CLI"
	@echo "  make psql    - Access TimescaleDB CLI"
	@echo "  make redis   - Access Redis CLI"
	@echo "  make clean   - Clean up volumes and containers"
	@echo "  make help    - Show this help message" 