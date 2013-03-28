#!/bin/bash

function nova1 () {
  eval "nova --region_name az-1.region-a.geo-1 $@"
}

function nova2 () {
  eval "nova --region_name az-2.region-a.geo-1 $@"
}

function nova3 () {
  eval "nova --region_name az-3.region-a.geo-1 $@"
}

function novab1 () {
  eval "nova --region_name az-1.region-b.geo-1 $@"
}

function novab2 () {
  eval "nova --region_name az-2.region-b.geo-1 $@"
}

function novab3 () {
  eval "nova --region_name az-3.region-b.geo-1 $@"
}

function novaenv () {
  local nova_alias=${1:-""}

  NOVA_ALIAS=$nova_alias
  export NOVA_ALIAS

  source ~/novacli/nova-$1
}

function edbgrantdevops () {
  for x in $1/*
  do
    y=$(basename $x)
    knife edb grant $1 ${y%.*} +devops
  done
}

