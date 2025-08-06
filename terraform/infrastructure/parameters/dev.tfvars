environment = "dev"
location    = "westeurope"

#SHARED
rg_shared = "z-rg-shared-dev"
acr_name  = "zacrkrkmxa001dev"

#NETWORK
rg_network = "z-rg-network-dev"

vnet_ingress_name  = "ingress-vnet"
range_vnet_ingress = ["192.168.60.0/24"]
range_subnet_apim  = ["192.168.60.0/27"]
range_subnet_agw   = ["192.168.60.32/27"]

vnet_aks_name    = "aks-vnet"
range_vnet_aks   = ["192.168.61.0/24"]
range_subnet_aks = ["192.168.61.0/24"]

vnet_endpoints_name  = "endpoints-vnet"
range_vnet_endpoints = ["192.168.62.0/25"]
range_subnet_pe      = ["192.168.62.0/25"]

#AKS
rg_aks               = "z-rg-aks-dev"
rg_aks_node          = "z-rg-aksnode-dev"
aks_managed_identity = "z-umi-aks-dev"
aks_cluster_name = "akscluster"

#INGRESS
rg_ingress = "z-rg-ingress-dev"
apim_name  = "apim-cus-krkm"
application_gateway_name = "appgw"