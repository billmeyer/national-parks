## Running in docker studio

```
$env:HAB_DOCKER_OPTS="-p 8080:8080"
hab studio enter
hab start mwrock/np-mongodb
hab start mwrock/national-parks --bind database:np-mongodb.default
```
