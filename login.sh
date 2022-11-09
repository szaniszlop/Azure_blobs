#!/bin/bash

export subscription_id="$(az account show --query 'id' --out tsv | sed -e 's/\r//g')"

if [[ -z "$subscription_id" ]]; then
	az login
	export subscription_id="$(az account show --query 'id' --out tsv | sed -e 's/\r//g')"
fi

if [[ -z "$subscription_id" ]]; then
	echo "Could not log in to Azure"
	exit -1
fi

echo "Logged in to $subscription_id"
