#!/bin/bash
#

# Create sample CSV files

echo "NAME,IP" > originpool.csv
for entry in `seq -s ' ' 1 80`
do
  echo "school${entry},203.0.113.1" >> originpool.csv
done

# Add headers to the CSV
for entry in `seq -s ' ' 1 5`
do
  echo "DNS,ORIGINPOOL" > district${entry}.csv
done

for entry in `seq -s ' ' 1 15` 
do
  echo "school${entry}.example.com,school${entry}-originpool" >> district1.csv
done

for entry in `seq -s ' ' 16 30`
do
  echo "school${entry}.example.com,school${entry}-originpool" >> district2.csv
done

for entry in `seq -s ' ' 31 45` 
do
  echo "school${entry}.example.com,school${entry}-originpool" >> district3.csv
done

for entry in `seq -s ' ' 46 60` 
do
  echo "school${entry}.example.com,school${entry}-originpool" >> district4.csv
done

for entry in `seq -s ' ' 61 75` 
do
  echo "school${entry}.example.com,school${entry}-originpool" >> district5.csv
done

./create-yaml-files.pl

vesctl --config .vesconfig configuration apply namespace -i yaml/namespace.yaml
vesctl --config .vesconfig configuration apply app_firewall -i yaml/app_firewall.yaml
vesctl --config .vesconfig configuration apply healthcheck -i yaml/healthcheck.yaml

for entry in `seq -s ' ' 1 80`
do
  vesctl --config .vesconfig configuration apply origin_pool -i yaml/school${entry}-originpool.yaml
done

for entry in `seq -s ' ' 1 5`
do
  vesctl --config .vesconfig configuration apply http_loadbalancer -i yaml/district${entry}.yaml
done
