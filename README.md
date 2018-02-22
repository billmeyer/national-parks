## Running in docker studio

```
$env:HAB_DOCKER_OPTS="-p 8080:8080"
hab studio enter
hab start mwrock/np-mongodb
hab start mwrock/national-parks --bind database:np-mongodb.default
```

Open your browser to `https://localhost:8080/national-parks` to see the app.

## Starting the supervisor in studio
```
hab sup run > /hab/sup/default/sup.log &
```

## Pre-Demo checklist

* Have studio open
* build at least once
* start np-mongodb
* Have open SSH sessions to hab1-3 and docker host
* increment NP version and commit (but do not push)
* make sure mongodb container is running on docker host
* have browser tabs open to my origins, local app, and azure app
