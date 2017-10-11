## Running in docker studio

```
$env:HAB_DOCKER_OPTS="-p 8080:8080"
hab studio enter
hab start core/mongodb
hab config apply mongodb.default 1 habitat/mongo.toml
hab start mwrock/national-parks --bind database:mongodb.default
```
