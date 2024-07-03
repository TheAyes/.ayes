#! /run/current-system/sw/bin/bash
. ./commands.sh switch

$update
$rebuild --upgrade

$return