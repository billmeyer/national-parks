Demo

1. Version the webpage and the package.
2. Show the app build and working in the Studio.

$env:HAB_DOCKER_OPTS="-p 8080:8080"
hab studio enter
hab start echohack/national-parks

3. Show the app working in Docker

docker-compose up

4. Update
cf push national1 --docker-image echohack/national-parks:cf-5.6.0-20171026043832 -c "/cf-init.sh"


