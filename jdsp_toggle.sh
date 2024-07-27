#!/bin/bash

# Get the current value of master_enable
current_value=$(jamesdsp --get master_enable)

# Toggle the value
if [ "$current_value" = "true" ]; then
    new_value="false"
else
    new_value="true"
fi

# Set the new value
jamesdsp --set master_enable=$new_value

