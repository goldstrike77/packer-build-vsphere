
#!/bin/bash

OS="KYLINV10 ROCKY9 UBUNTU2404 WIN2019EN"

for i in $OS; do
  cd $i
  packer build -var-file=variables.pkrvars.hcl build.pkr.hcl
  cd ..
done