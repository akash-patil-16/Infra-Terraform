
location = "eastus"

tags = {
  environment = "dev"
  owner       = "platform"
}

resource_groups = {
  hub = {
    name = "rg-hub-network"
  }
  spoke = {
    name = "rg-spoke-network"
  }
}

virtual_networks = {
  hub = {
    name           = "vnet-hub"
    resource_group = "hub"
    address_space  = ["10.0.0.0/16"]
  }
  spoke = {
    name           = "vnet-spoke"
    resource_group = "spoke"
    address_space  = ["10.1.0.0/16"]
  }
  spoke2 = {
    name           = "vnet-spoke2"
    resource_group = "spoke"
    address_space  = ["10.2.0.0/16"]
  }
}

subnets = {
  firewall = {
    name             = "AzureFirewallSubnet"
    virtual_network  = "hub"
    address_prefixes = ["10.0.1.0/24"]
  }
  gateway = {
    name             = "GatewaySubnet"
    virtual_network  = "hub"
    address_prefixes = ["10.0.2.0/24"]
  }
  hub_management = {
    name             = "snet-hub-management"
    virtual_network  = "hub"
    address_prefixes = ["10.0.3.0/24"]
  }
  firewall_management = {
    name             = "AzureFirewallManagementSubnet"
    virtual_network  = "hub"
    address_prefixes = ["10.0.4.0/26"]
  }
  bastion = {
    name             = "AzureBastionSubnet"
    virtual_network  = "hub"
    address_prefixes = ["10.0.5.0/26"]
  }
  web = {
    name             = "snet-web"
    virtual_network  = "spoke"
    address_prefixes = ["10.1.1.0/24"]
  }
  app = {
    name             = "snet-app"
    virtual_network  = "spoke2"
    address_prefixes = ["10.2.2.0/24"]
  }
}

spoke_vnet_keys = ["spoke", "spoke2"]

admin_username = "azureadmin"
admin_password = "Akash@1234@"

bastions = {
  hub = {
    name   = "bas-hub-01"
    subnet = "bastion"
    sku    = "Standard"
  }
}

virtual_machines = {
  web = {
    name   = "vm-web-01"
    subnet = "web"
    size   = "Standard_DC1ds_v3"
  }
  app = {
    name   = "vm-app-01"
    subnet = "app"
    size   = "Standard_DC1ds_v3"
  }
}
firewall_next_hop_ip = null
