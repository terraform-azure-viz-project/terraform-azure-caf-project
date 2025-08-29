#!/bin/bash

# Variable generator script for landingzone and customers. This project is purely for Terraform deployment. The code will be managed on GitHub Enterprise. The environment is fully compliant with HIPAA US.

echo "Select mode: 1 for landingzone, 2 for customer"
read mode

if [ "$mode" = "1" ]; then
  tfvars_file="landingzone/terraform.auto.tfvars"
  # Initialize tfvars file with all variables
  cat << 'TFVARS' > $tfvars_file
environment = ""
location_short = ""
location = ""
tenant_id = ""
management_sub_id = ""
connectivity_sub_id = ""
sandbox_sub_ids = []
principal_id = ""
app_name = "caf"
role_definition_name = "Contributor"
hub_address_space = ["10.0.0.0/16"]
hub_gateway_subnet_prefix = ["10.0.1.0/24"]
virtual_hub_id = ""
resource_tags = { "environment" = "prod" }
TFVARS

  echo "Enter environment:"
  read env
  sed -i "s#environment = \"\"#environment = \"$env\"#g" $tfvars_file
  echo "Enter location_short:"
  read loc_short
  sed -i "s#location_short = \"\"#location_short = \"$loc_short\"#g" $tfvars_file
  echo "Enter location:"
  read loc
  sed -i "s#location = \"\"#location = \"$loc\"#g" $tfvars_file
  echo "Enter tenant_id:"
  read tenant_id
  sed -i "s#tenant_id = \"\"#tenant_id = \"$tenant_id\"#g" $tfvars_file
  echo "Enter management_sub_id (UUID only, e.g., 12345678-1234-9876-4563-123456789012):"
  read management_sub_id
  if [ -n "$management_sub_id" ]; then
    sed -i "s#management_sub_id = \"\"#management_sub_id = \"/subscriptions/$management_sub_id\"#g" $tfvars_file
  fi
  echo "Enter connectivity_sub_id (UUID only, e.g., 12345678-1234-9876-4563-123456789012):"
  read connectivity_sub_id
  if [ -n "$connectivity_sub_id" ]; then
    sed -i "s#connectivity_sub_id = \"\"#connectivity_sub_id = \"/subscriptions/$connectivity_sub_id\"#g" $tfvars_file
  fi
  echo "Enter sandbox_sub_ids (comma-separated UUIDs, e.g., sub1,sub2):"
  read sandbox_sub_ids_input
  if [ -n "$sandbox_sub_ids_input" ]; then
    IFS=',' read -ra sandbox_sub_ids <<< "$sandbox_sub_ids_input"
    sandbox_sub_ids_formatted=$(printf '"/subscriptions/%s",' "${sandbox_sub_ids[@]}" | sed 's/,$//')
    sed -i "s#sandbox_sub_ids = \[\]#sandbox_sub_ids = [$sandbox_sub_ids_formatted]#g" $tfvars_file
  fi
  echo "Enter principal_id:"
  read principal_id
  sed -i "s#principal_id = \"\"#principal_id = \"$principal_id\"#g" $tfvars_file
  echo "Enter app_name (default caf):"
  read app_name
  app_name=${app_name:-caf}
  sed -i "s#app_name = \"caf\"#app_name = \"$app_name\"#g" $tfvars_file
  echo "Enter role_definition_name (default Contributor):"
  read role_definition_name
  role_definition_name=${role_definition_name:-Contributor}
  sed -i "s#role_definition_name = \"Contributor\"#role_definition_name = \"$role_definition_name\"#g" $tfvars_file
  echo "Enter hub_address_space (default [\"10.0.0.0/16\"]):"
  read hub_address_space
  hub_address_space=${hub_address_space:-["10.0.0.0/16"]}
  sed -i "s#hub_address_space = \[.*\]#hub_address_space = $hub_address_space#g" $tfvars_file
  echo "Enter hub_gateway_subnet_prefix (default [\"10.0.1.0/24\"]):"
  read hub_gateway_subnet_prefix
  hub_gateway_subnet_prefix=${hub_gateway_subnet_prefix:-["10.0.1.0/24"]}
  sed -i "s#hub_gateway_subnet_prefix = \[.*\]#hub_gateway_subnet_prefix = $hub_gateway_subnet_prefix#g" $tfvars_file
  echo "Enter virtual_hub_id (default \"\"):"
  read virtual_hub_id
  virtual_hub_id=${virtual_hub_id:-""}
  sed -i "s#virtual_hub_id = \"\"#virtual_hub_id = \"$virtual_hub_id\"#g" $tfvars_file
  echo "Enter resource_tags (default { \"environment\" = \"prod\" }, enter as Terraform map, e.g., { \"key\" = \"value\" }):"
  read resource_tags
  resource_tags=${resource_tags:-{ "environment" = "prod" }}
  if [[ ! "$resource_tags" =~ ^\{.*\}$ ]]; then
    echo "Invalid resource_tags format. Using default { \"environment\" = \"prod\" }"
    resource_tags="{ \"environment\" = \"prod\" }"
  fi
  resource_tags_escaped=$(echo "$resource_tags" | sed 's/"/\\"/g')
  sed -i "s#resource_tags = { \"environment\" = \"prod\" }#resource_tags = $resource_tags_escaped#g" $tfvars_file
elif [ "$mode" = "2" ]; then
  echo "Enter customer name:"
  read customer
  mkdir -p infra/$customer
  cp -r infra/customertemplate/* infra/$customer/
  sed -i "s/customer.tfstate/${customer}.tfstate/g" infra/$customer/backend.tf
  tfvars_file="infra/$customer/terraform.auto.tfvars"
  cat << 'TFVARS' > $tfvars_file
environment = ""
location_short = ""
location = ""
hub_rg_name = ""
hub_vnet_name = ""
hub_vnet_id = ""
ssh_public_key = ""
spoke_address_space = ["10.1.0.0/16"]
spoke_vm_subnet_prefix = ["10.1.1.0/24"]
deploy_vm = true
vm_size = "Standard_DS1_v2"
admin_username = "adminuser"
os_disk_type = "Premium_LRS"
image_publisher = "Canonical"
image_offer = "UbuntuServer"
image_sku = "18.04-LTS"
image_version = "latest"
resource_tags = {}
additional_subnets = {}
TFVARS

  echo "Enter environment:"
  read env
  sed -i "s#environment = \"\"#environment = \"$env\"#g" $tfvars_file
  echo "Enter location_short:"
  read loc_short
  sed -i "s#location_short = \"\"#location_short = \"$loc_short\"#g" $tfvars_file
  echo "Enter location:"
  read loc
  sed -i "s#location = \"\"#location = \"$loc\"#g" $tfvars_file
  echo "Enter hub_rg_name:"
  read hub_rg_name
  sed -i "s#hub_rg_name = \"\"#hub_rg_name = \"$hub_rg_name\"#g" $tfvars_file
  echo "Enter hub_vnet_name:"
  read hub_vnet_name
  sed -i "s#hub_vnet_name = \"\"#hub_vnet_name = \"$hub_vnet_name\"#g" $tfvars_file
  echo "Enter hub_vnet_id:"
  read hub_vnet_id
  sed -i "s#hub_vnet_id = \"\"#hub_vnet_id = \"$hub_vnet_id\"#g" $tfvars_file
  echo "Enter ssh_public_key:"
  read ssh_public_key
  sed -i "s#ssh_public_key = \"\"#ssh_public_key = \"$ssh_public_key\"#g" $tfvars_file
  echo "Enter spoke_address_space (default [\"10.1.0.0/16\"]):"
  read spoke_address_space
  spoke_address_space=${spoke_address_space:-["10.1.0.0/16"]}
  sed -i "s#spoke_address_space = \[.*\]#spoke_address_space = $spoke_address_space#g" $tfvars_file
  echo "Enter spoke_vm_subnet_prefix (default [\"10.1.1.0/24\"]):"
  read spoke_vm_subnet_prefix
  spoke_vm_subnet_prefix=${spoke_vm_subnet_prefix:-["10.1.1.0/24"]}
  sed -i "s#spoke_vm_subnet_prefix = \[.*\]#spoke_vm_subnet_prefix = $spoke_vm_subnet_prefix#g" $tfvars_file
  echo "Enter deploy_vm (default true):"
  read deploy_vm
  deploy_vm=${deploy_vm:-true}
  sed -i "s#deploy_vm = true#deploy_vm = $deploy_vm#g" $tfvars_file
  echo "Enter vm_size (default Standard_DS1_v2):"
  read vm_size
  vm_size=${vm_size:-Standard_DS1_v2}
  sed -i "s#vm_size = \"Standard_DS1_v2\"#vm_size = \"$vm_size\"#g" $tfvars_file
  echo "Enter admin_username (default adminuser):"
  read admin_username
  admin_username=${admin_username:-adminuser}
  sed -i "s#admin_username = \"adminuser\"#admin_username = \"$admin_username\"#g" $tfvars_file
  echo "Enter os_disk_type (default Premium_LRS):"
  read os_disk_type
  os_disk_type=${os_disk_type:-Premium_LRS}
  sed -i "s#os_disk_type = \"Premium_LRS\"#os_disk_type = \"$os_disk_type\"#g" $tfvars_file
  echo "Enter image_publisher (default Canonical):"
  read image_publisher
  image_publisher=${image_publisher:-Canonical}
  sed -i "s#image_publisher = \"Canonical\"#image_publisher = \"$image_publisher\"#g" $tfvars_file
  echo "Enter image_offer (default UbuntuServer):"
  read image_offer
  image_offer=${image_offer:-UbuntuServer}
  sed -i "s#image_offer = \"UbuntuServer\"#image_offer = \"$image_offer\"#g" $tfvars_file
  echo "Enter image_sku (default 18.04-LTS):"
  read image_sku
  image_sku=${image_sku:-18.04-LTS}
  sed -i "s#image_sku = \"18.04-LTS\"#image_sku = \"$image_sku\"#g" $tfvars_file
  echo "Enter image_version (default latest):"
  read image_version
  image_version=${image_version:-latest}
  sed -i "s#image_version = \"latest\"#image_version = \"$image_version\"#g" $tfvars_file
  echo "Enter resource_tags (default {}):"
  read resource_tags
  resource_tags=${resource_tags:-{}}
  if [[ ! "$resource_tags" =~ ^\{.*\}$ ]]; then
    echo "Invalid resource_tags format. Using default {}"
    resource_tags="{}"
  fi
  resource_tags_escaped=$(echo "$resource_tags" | sed 's/"/\\"/g')
  sed -i "s#resource_tags = {}#resource_tags = $resource_tags_escaped#g" $tfvars_file
  echo "Enter additional_subnets (default {}):"
  read additional_subnets
  additional_subnets=${additional_subnets:-{}}
  if [[ ! "$additional_subnets" =~ ^\{.*\}$ ]]; then
    echo "Invalid additional_subnets format. Using default {}"
    additional_subnets="{}"
  fi
  additional_subnets_escaped=$(echo "$additional_subnets" | sed 's/"/\\"/g')
  sed -i "s#additional_subnets = {}#additional_subnets = $additional_subnets_escaped#g" $tfvars_file
fi

echo "Variables updated. Remember to update backend.tf manually if needed."
