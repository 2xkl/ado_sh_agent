resource_group_name = "z-test-state-rg"
location            = "westeurope"

user_managed_identity = "thatstheumiiguess"
storage_account_name  = "zdevops123123"

vm_config = [
  {
    vmHostname         = "AZPLIC01"
    vmName             = "vm-be-lic-sad"
    vmDataDisks        = []
    vmAvailabilityZone = "2"
    vmNicName          = "nic-beasd"
    vmPrivateIPAddress = "10.0.1.15"
  }
]
