# Local development and testing (KT)

Helpers to run the provider built from this repo with Terraform, either against
a fake Secure Access API (no credentials needed) or against a real org.

```
local-dev/
├── setup.sh          builds the provider + fake API, writes tf/dev.tfrc
├── mock-api/main.go  fake API on 127.0.0.1:18089 (token + /deployments/v2/regions)
└── tf/main.tf        secureaccess_regions data source with outputs
```

## 1. Build and configure

```bash
./local-dev/setup.sh
export TF_CLI_CONFIG_FILE="$PWD/local-dev/tf/dev.tfrc"
```

`dev.tfrc` tells Terraform to use `local-dev/bin/terraform-provider-secureaccess`
instead of downloading the provider. Terraform prints a
"Provider development overrides are in effect" warning - that is expected.
No `terraform init` is needed.

## 2a. Run against the fake API

```bash
./local-dev/bin/mock-api &
export SECUREACCESS_API_KEY=fake SECUREACCESS_API_KEY_SECRET=fake
export SECUREACCESS_URL=http://127.0.0.1:18089
cd local-dev/tf && terraform plan
```

Stop the fake API with `pkill -f local-dev/bin/mock-api`.

## 2b. Run against a real org

```bash
export SECUREACCESS_API_KEY=<key> SECUREACCESS_API_KEY_SECRET=<secret>
export SECUREACCESS_URL=https://api.sse.cisco.com
cd local-dev/tf && terraform plan
```

`terraform apply` is safe here: the config only has a data source, so nothing
is created in Secure Access. For resources, apply creates real objects - use a
test org and run `terraform destroy` afterwards.

## 3. Acceptance test

```bash
# against the fake API (start it first, see 2a) or a real org (see 2b)
make testacc TESTARGS="-run TestAccDataSourceSecureAccessRegions"
```
