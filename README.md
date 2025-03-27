# AI TRADE Microservice API for SaaS Platforms (Feb 6, 2022)
By Andy Ng <andy.ng@aitrade.ai>, Senior Software Development Manager at AI TRADE, Inc.

:shield:  **Disclaimer**: This source code present a conceptual overview of our system architecture. Proprietary configurations, security measures, and specific implementation details have been omitted for confidentiality and security reasons. This information is approved for public sharing by AI TRADE, Inc.

![AI Trade](https://www.aitrade.ai/assets/images/logo.png)

## Overview

AI Trade Microservices Platform is a comprehensive solution for building trading applications with microservices architecture. This platform provides a foundation for developing scalable, maintainable, and high-performance trading systems.

## Features

### Core Services
- **Core Message API**: Real-time messaging and communication service
- **Core Trading API**: Trading operations and order management
- **Core Data API**: Data management and analytics
- **Core Billing API**: Payment and subscription management
- **Core Transaction API**: Transaction processing and history
- **Core User API**: User management and authentication
- **Core Product API**: Product catalog and management
- **WebSocket Service**: Real-time data streaming and updates
- **Image API**: Asset and image management

### Technical Stack
- **Backend**: PHP/Golang microservices
- **Frontend**: Next.js React (In another repository)
- **Database**: 
  - MySQL 8.0 for relational data
  - TimescaleDB (PostgreSQL extension) for high-performance time-series data processing
    - Optimized for handling terabytes of time-series data
    - Efficient data compression and partitioning
    - Built-in time-bucket functions for analytics
    - Supports thousands of concurrent users
- **Caching**: Redis 6
- **API Gateway**: Traefik v2.11
- **Container Orchestration**: Docker Compose
- **Load Balancing**: Traefik with sticky sessions

### Docker Configuration

Our Dockerfile is optimized for PHP 8.2 and includes:

#### Base Image & Dependencies
```dockerfile
FROM php:8.2-fpm
```
- Latest PHP 8.2 with FPM for high-performance processing
- Essential build tools and libraries
- Image optimization tools (jpegoptim, optipng, pngquant)
- Development tools (vim, git, curl)

#### Node.js Environment
```dockerfile
# Node.js 18.x LTS
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get install nodejs -y
RUN apt-get install -y yarn
```
- Node.js 18.x LTS for frontend development
- Yarn package manager for dependency management

#### PHP Extensions
```dockerfile
RUN install-php-extensions \
    bcmath \
    sockets \
    pdo \
    mysqli \
    pcntl \
    exif \
    gmp \
    gd \
    pdo_mysql \
    pdo_pgsql \
    mosquitto \
    opcache \
    redis \
    apcu
```
- Essential PHP extensions for web applications
- Database drivers (MySQL, PostgreSQL)
- Image processing (GD)
- Caching (Redis, APCu)
- Message queuing (Mosquitto)

#### PHP Configuration
```dockerfile
# PHP 8.2 optimizations
php_admin_value[memory_limit] = 1024M
php_admin_value[max_execution_time] = 30
php_admin_value[upload_max_filesize] = 64M
php_admin_value[post_max_size] = 64M
php_admin_value[opcache.enable] = 1
php_admin_value[opcache.jit] = 1235
php_admin_value[opcache.jit_buffer_size] = 128M
```
- Optimized memory and execution limits
- JIT (Just-In-Time) compilation enabled
- OPcache for improved performance
- Increased upload limits

#### Development Tools
```dockerfile
# Xdebug for debugging
ENV XDEBUG_VERSION=3.3.1
RUN pecl install xdebug-${XDEBUG_VERSION}

# Go for microservices
ENV GOLANG_VERSION=1.21.6
```
- Xdebug 3.3.1 for debugging
- Go 1.21.6 for microservices development

#### Performance Optimizations
- Process management with emergency restart
- Increased file descriptor limits
- Epoll event mechanism
- Optimized PHP-FPM settings
- JIT compilation for better performance

## Prerequisites

- Docker and Docker Compose
- Git
- Make (optional, for convenience commands)

## Quick Start

1. Clone the repository:
```bash
git clone https://github.com/aitrade-ai/saas.docker.api.git
cd saas.docker.api
```

2. Initial setup (first time only):
```bash
# Create environment files
make env

# Install dependencies and prepare packages
make package

# Initialize the system
make init
```

3. For subsequent runs, simply use:
```bash
make
```

## Make Commands

The project includes comprehensive Make commands for all operations:

### Setup Commands
- `make env`: Creates necessary environment files from templates
- `make package`: Installs dependencies and prepares required packages
- `make init`: Initializes the system (first-time setup)

### Service Management
- `make`: Starts all services (default command)
- `make up`: Starts all services in detached mode
- `make down`: Stops all running services
- `make restart`: Restarts all services
- `make rebuild`: Rebuilds all service containers
- `make clean`: Removes all containers, volumes, and cached files

### Development Tools
- `make logs`: Shows logs from all services
- `make logs-follow`: Follows logs in real-time
- `make shell`: Opens a shell in the application container
- `make test`: Runs the test suite
- `make lint`: Runs code linting

### Database Commands
- `make mysql`: Opens MySQL CLI
- `make psql`: Opens TimescaleDB CLI
- `make redis`: Opens Redis CLI
- `make db-backup`: Creates database backups
- `make db-restore`: Restores database from backup

### Maintenance
- `make prune`: Removes unused Docker resources
- `make update`: Updates dependencies and containers
- `make status`: Shows status of all services

### Help
- `make help`: Shows available commands and their descriptions

## Security Considerations

- The default credentials in `deploy/local.env` are for development purposes only
- Always change all passwords and secrets before deploying to production
- Use strong, unique passwords for each service
- Consider using a secrets management service in production
- Regularly rotate credentials and secrets
- Never commit the actual `.env` file to version control

## Convenience Commands

The project includes Make commands for common operations:

```bash
# Start all services
make up

# Stop all services
make down

# Rebuild services
make rebuild

# View logs
make logs

# Access MySQL CLI
make mysql

# Access TimescaleDB CLI
make psql

# Access Redis CLI
make redis
```

## Service Endpoints

The following services are available:

- Core Message API: https://core-message-api-develop.aitrade.ai
- Core Trading API: https://core-trading-api-develop.aitrade.ai
- Core Data API: https://core-data-api-develop.aitrade.ai
- Core Billing API: https://core-billing-api-develop.aitrade.ai
- Core Transaction API: https://core-transaction-api-develop.aitrade.ai
- Core User API: https://core-user-api-develop.aitrade.ai
- Core Product API: https://core-product-api-develop.aitrade.ai
- WebSocket: wss://ws-develop.aitrade.ai
- Image API: https://tc-img-api-develop.aitrade.ai

## Architecture

The platform is built with a microservices architecture, where each service is:
- Independently deployable
- Loosely coupled
- Owned by a small team
- Focused on a specific business domain

### System Scale
- Processing terabytes of time-series data
- Supporting thousands of concurrent users
- High-performance data ingestion and querying
- Real-time analytics and reporting

### Network Structure
- **Public Network**: For external-facing services
- **Private Network**: For internal service communication

### Data Storage
- **MySQL**: Primary database for relational data
- **TimescaleDB**: Optimized for time-series data
- **Redis**: Caching and real-time data

## Development

### Adding New Services
1. Create a new service directory in the `services` folder
2. Add service configuration to `docker-compose.develop.yml`
3. Configure Traefik labels for routing
4. Update environment variables if needed

### Local Development
1. Services are hot-reloaded for development
2. Logs are available in `docker/logs`
3. Database dumps are stored in `docker/dumps`

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For support, please visit [www.aitrade.ai](https://www.aitrade.ai) or open an issue in the repository.


## Acknowledgments

- Thanks to all contributors
- Built with modern open-source technologies
- Powered by AI Trade 

## Get Started Today

Ready to transform your trading platform with cutting-edge microservices? Contact us today for a consultation:

- 📧 Email: office@aitrade.ai
- 🌐 Website: [www.aitrade.ai](https://www.aitrade.ai)

Our team of experts will help you:
- Design and implement scalable microservices architecture
- Optimize your time-series data processing
- Set up high-performance trading systems
- Implement real-time analytics and reporting
- Ensure enterprise-grade security and compliance

Let's discuss how we can help you build the next generation of trading platforms. 