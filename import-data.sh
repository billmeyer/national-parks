#!/bin/bash

mongoimport --drop -d demo -c national-parks --type json --jsonArray --file ./national-parks.json
