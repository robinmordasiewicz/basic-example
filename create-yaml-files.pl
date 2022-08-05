#!/usr/local/bin/perl

use strict;
use Text::CSV;

# open the CSV file for read
my $file = 'originpool.csv';
open(my $fh, "<", $file) or die "Couldn't open $file: $!\n";

# initialise a csv object
my $csv = Text::CSV->new();

# read the header line
my @headers = $csv->getline($fh);
$csv->column_names(@headers);

# iterate over each line of the CSV file, reading
# each line into a hash (associative array) reference.
while (my $row = $csv->getline_hr($fh)) {

my $originpool = "yaml/$row->{NAME}-originpool.yaml";
open( FHDL , '>', $originpool ) or die "Could not open file' $!";
print FHDL <<__EOF__;
{
  "metadata": {
    "name": "$row->{NAME}-originpool",
    "namespace": "namespace-1",
    "labels": {},
    "annotations": {},
    "description": null,
    "disable": null
  },
  "spec": {
    "origin_servers": [
      {
        "public_ip": {
          "ip": "$row->{IP}"
        },
        "labels": {}
      }
    ],
    "use_tls": {
      "use_host_header_as_sni": {},
      "tls_config": {
        "default_security": {}
      },
      "volterra_trusted_ca": {},
      "no_mtls": {}
    },
    "port": 443,
    "same_as_endpoint_port": {},
    "healthcheck": [
      {
        "tenant": "example-xxxxxx",
        "namespace": "namespace-1",
        "name": "tcp-healthcheck"
      }
    ],
    "loadbalancer_algorithm": "LB_OVERRIDE",
    "endpoint_selection": "LOCAL_PREFERRED",
    "advanced_options": null
  },
  "resource_version": null
}
__EOF__

close(FHDL);

}
close($fh);

my @a = (1..5);
for(@a){

  # iterate over each line of the CSV file, reading
  # each line into a hash (associative array) reference.

  my $fhyaml = "yaml/district${_}.yaml";
  open( FHDL , '>', $fhyaml ) or die "Could not open file' $!";
  print FHDL <<__EOF__;

{
  "metadata": {
    "name": "district${_}-http-loadbalancer",
    "namespace": "namespace-1",
    "labels": {},
    "annotations": {},
    "description": null,
    "disable": null
  },
  "spec": {
    "domains": [
__EOF__

  my $file = "district${_}.csv";
  open(my $fhcsv, "<", $file) or die "Couldn't open $file: $!\n";
  my $csv = Text::CSV->new();
  # read the header line
  my @headers = $csv->getline($fhcsv);
  $csv->column_names(@headers);

  while (my $row = $csv->getline_hr($fhcsv)) {
  print FHDL <<__EOF__;
      "$row->{DNS}",
__EOF__
  }
  close($fhcsv);

  print FHDL <<__EOF__;
    ],
    "http": {
      "dns_volterra_managed": null,
      "port": 80
    },
    "advertise_on_public_default_vip": {},
    "default_route_pools": null,
    "routes": [
__EOF__

  my $file = "district${_}.csv";
  open(my $fhcsv, "<", $file) or die "Couldn't open $file: $!\n";
  my $csv = Text::CSV->new();
  # read the header line
  my @headers = $csv->getline($fhcsv);
  $csv->column_names(@headers);
while (my $row = $csv->getline_hr($fhcsv)) {
print FHDL <<__EOF__;
      {
        "simple_route": {
          "http_method": "ANY",
          "path": {
            "regex": "/*"
          },
          "origin_pools": [
            {
              "pool": {
                "tenant": "example-xxxxxxxx",
                "namespace": "namespace-1",
                "name": "$row->{ORIGINPOOL}"
              },
              "weight": 1,
              "priority": 1,
              "endpoint_subsets": {}
            }
          ],
          "headers": [
            {
              "name": "host",
              "exact": "$row->{DNS}",
              "invert_match": null
            }
          ],
          "auto_host_rewrite": {},
          "advanced_options": null
        }
      },
__EOF__
}
  close($fhcsv);

print FHDL <<__EOF__;
    ],
    "cors_policy": null,
    "app_firewall": {
      "tenant": "globalpayments-nimdeswt",
      "namespace": "namespace1",
      "name": "app-fw"
    },
    "add_location": true,
    "no_challenge": {},
    "more_option": null,
    "user_id_client_ip": {},
    "disable_rate_limit": {},
    "malicious_user_mitigation": null,
    "waf_exclusion_rules": null,
    "data_guard_rules": null,
    "blocked_clients": null,
    "trusted_clients": null,
    "api_protection_rules": null,
    "ddos_mitigation_rules": null,
    "service_policies_from_namespace": {},
    "round_robin": {},
    "multi_lb_app": {},
    "disable_bot_defense": {},
    "disable_api_definition": {},
    "disable_ip_reputation": {}
  },
  "resource_version": null
}
__EOF__
close(FHDL);
}

