# variables
GIT_REPOSITORY_NAME="docker.api"
RELEASE_SOURCE="/root/release/$GIT_REPOSITORY_NAME"
RELEASE_DESTINATION="/root/website"
SECRET_PATH="/root/secret"
NETWORK_NAME_PUBLIC="public-network"

# remove websites (docker)
rm -f $RELEASE_DESTINATION/deploy/$GIT_REPOSITORY_NAME.*.sh > /dev/null 2>&1
rm -rf $RELEASE_DESTINATION/docker/ > /dev/null 2>&1

# copy websites (docker)
mkdir -p $RELEASE_DESTINATION/deploy
rm -rf $RELEASE_DESTINATION/deploy/$GIT_REPOSITORY_NAME.*.sh  > /dev/null 2>&1
rm -f $RELEASE_DESTINATION/docker-compose.yml > /dev/null 2>&1
cp -R $RELEASE_SOURCE/docker-compose.yml $RELEASE_DESTINATION/
mkdir -p $RELEASE_DESTINATION/docker/
cp -R $RELEASE_SOURCE/docker/. $RELEASE_DESTINATION/docker/

# copy env (docker)
rm -rf  $RELEASE_DESTINATION/.env > /dev/null 2>&1
cp -R $SECRET_PATH/$GIT_REPOSITORY_NAME/*.env $RELEASE_DESTINATION/.env

# php extensions
# disable
mv $RELEASE_DESTINATION/docker/php/php/conf.d/docker-php-ext-xdebug.ini \
$RELEASE_DESTINATION/docker/php/php/conf.d.disabled/  > /dev/null 2>&1
# enable
mv $RELEASE_DESTINATION/docker/php/php/conf.d.disabled/docker-php-ext-opcache.ini \
$RELEASE_DESTINATION/docker/php/php/conf.d/  > /dev/null 2>&1

# docker-compose up
cd $RELEASE_DESTINATION/ || exit
docker network prune -f 2>&1
docker ps -a -q | xargs -n 1 -P 8 -I {} docker stop {}
docker builder prune --all --force
docker system prune -f
cd $RELEASE_DESTINATION && docker-compose build --no-cache 2>&1
docker network create "$NETWORK_NAME_PUBLIC"
cd $RELEASE_DESTINATION && docker-compose up -d 2>&1

# first website server-all
cd $RELEASE_DESTINATION/html/ && cd "$(ls -d */ | head -n 1)" && make serve-all
cd $RELEASE_DESTINATION || exit
