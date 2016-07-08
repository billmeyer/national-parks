#!/bin/bash

mongoimport --drop -d demo -c nationalparks --type json --jsonArray --file ./nationalparks.json
