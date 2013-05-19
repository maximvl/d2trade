#!/bin/bash

source ./update_path.sh
erl -pa ebin/ deps/*/ebin/ -s cboss
