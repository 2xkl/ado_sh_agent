environment = "dev"

location = "westeurope"

rg_shared = "z-rg-shared-dev"
acr_name  = "zrgsharedacr001dev"

rg_network           = "z-rg-network-dev"
range_vnet_aks       = ["10.1.0.0/16"]
range_subnet_aks     = ["10.1.1.0/24"]
range_subnet_apim    = ["10.1.2.0/24"]
range_subnet_ingress = ["10.1.3.0/24"]

rg_aks               = "z-rg-aks-dev"
rg_aks_node          = "z-rg-aksnode-dev"
aks_managed_identity = "z-umi-aks-dev"

rg_ingress = "z-rg-ingress-dev"
apim_name  = "apim-custom-2xkl"
