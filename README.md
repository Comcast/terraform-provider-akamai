[![Build Status](https://travis-ci.org/Comcast/terraform-provider-akamai.svg?branch=master)](https://travis-ci.org/Comcast/terraform-provider-akamai)

# terraform-provider-akamai

An Akamai provider for HashiCorp [Terraform](http://terraform.io).

## Installation

1. Download the desired [release](https://github.com/Comcast/terraform-provider-akamai/releases) version for your operating system
2. Untar the download contents
3. Install the `terraform-provider-akamai` anywhere on your system
4. Add `terraform-provider-akamai` to your `~/.terraformrc` file:

```
providers {
  "akamai" = "path/to/your/terraform-provider-akamai"
}
```

### Install from source

If you'd prefer to install from source:

1. Add `terraform-provider-akamai` to your `~/.terraformrc` file:

```
providers {
  "akamai" = "$GOPATH/bin/terraform-provider-akamai"
}
```

2. Install `terraform-provider-akamai`:

```
git clone git@github.com:Comcast/terraform-provider-akamai.git
cd terraform-provider-akamai
make
```

## Environment

Note that `terraform-provider-akamai` assumes the following Akamai credentials stored as environment variables:

```
export AKAMAI_EDGEGRID_HOST=https://some-host.luna.akamaiapis.net
export AKAMAI_EDGEGRID_ACCESS_TOKEN=some-access-token
export AKAMAI_EDGEGRID_CLIENT_TOKEN=some-client-token
export AKAMAI_EDGEGRID_CLIENT_SECRET=some-client-secret
```

## Usage

See `example.tf` as a usage reference.

### WARNING!

When using `terraform-provider-akamai` against an existing Akamai GTM domain with existing Akamai GTM properties,
Terraform will destroy all existing Akamai GTM properties associated with the `resource "akamai_gtm_domain"`
cited in your `.tf file`. If undesired, this destructive action can be avoided by omitting usage of the
`resource "akamai_gtm_domain"` in your `.tf` file.

### Acceptance Tests

Acceptance tests require Akamai credentials authorized to perform CRUD actions against the `golangtest.akadns.net` GTM domain.

Establish the required `AKAMAI_EDGEGRID_*` environment variables and execute the tests:

```
make test
```

## Releasing new versons

To publish a new `terraform-provider-akamai` release from your git repository's `HEAD`...

1. establish a `GITHUB_TOKEN` env variable: `export GITHUB_TOKEN=YOUR_ACCESS_TOKEN`
1. edit `Makefile`'s `VERSION` variable to the appropriate semantic version
1. execute `make build` to build the release artifacts
1. execute `make release` to publish the release artifacts to GitHub
