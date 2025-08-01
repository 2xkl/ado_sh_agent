resource_group_name = "z-test-state-rg"
location            = "westeurope"

user_managed_identity = "thatstheumiiguess"
storage_account_name  = "zdevops123123"

vm_config = {
  vmName             = "vm-be-lic-dev-westeu-001"
  vmHostname         = "AZPLIC01"
  vmDataDisks        = []
  vmNicName          = "nic-be-lic-001-dev-westeu"
  vmPrivateIPAddress = "10.0.1.5"
  vmAvailabilityZone = "2"
}
