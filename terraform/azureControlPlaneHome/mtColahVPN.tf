# -----------------------------------------------------------------------------
# vpn configuration
# -----------------------------------------------------------------------------
#
# -----------------------------------------------------------------------------
# Local Gateway Resource
# https://www.terraform.io/docs/providers/azurerm/r/local_network_gateway.html
# This resource has no changes assocated with it.

resource "azurerm_local_network_gateway" "mtColahVPNnetgw" {
  name                = "mtColahVPN-Netgw"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location            = "${var.location}"
  gateway_address     = "58.111.149.48"
  address_space       = ["192.168.1.0/24"]
}

# -----------------------------------------------------------------------------
# vpn gateway resource
#azurerm_virtual_network_gateway
#https://www.terraform.io/docs/providers/azurerm/r/virtual_network_gateway.html

# vpn gateway public IP address
resource "azurerm_public_ip" "mtColahVPNpip" {
  name                         = "mtColahVPN-pip"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  location                     = "${var.location}"
  public_ip_address_allocation = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "mtColahVPNgw" {
  name                = "mtColahVPN-gw"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location            = "${var.location}"

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "Basic"

  ip_configuration {
    name                          = "vnetGatewayIPConfig"
    public_ip_address_id          = "${azurerm_public_ip.mtColahVPNpip.id}"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = "${module.network.vnet_subnets[1]}"
  }

  #   vpn_client_configuration { # see doco. this is used for point to site connections.
  #     address_space = ["10.2.0.0/24"]
  #
  #     root_certificate {
  #       name = "DigiCert-Federated-ID-Root-CA"
  #
  #       public_cert_data = <<EOF
  # MIIDuzCCAqOgAwIBAgIQCHTZWCM+IlfFIRXIvyKSrjANBgkqhkiG9w0BAQsFADBn
  # MQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3
  # d3cuZGlnaWNlcnQuY29tMSYwJAYDVQQDEx1EaWdpQ2VydCBGZWRlcmF0ZWQgSUQg
  # Um9vdCBDQTAeFw0xMzAxMTUxMjAwMDBaFw0zMzAxMTUxMjAwMDBaMGcxCzAJBgNV
  # BAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdp
  # Y2VydC5jb20xJjAkBgNVBAMTHURpZ2lDZXJ0IEZlZGVyYXRlZCBJRCBSb290IENB
  # MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvAEB4pcCqnNNOWE6Ur5j
  # QPUH+1y1F9KdHTRSza6k5iDlXq1kGS1qAkuKtw9JsiNRrjltmFnzMZRBbX8Tlfl8
  # zAhBmb6dDduDGED01kBsTkgywYPxXVTKec0WxYEEF0oMn4wSYNl0lt2eJAKHXjNf
  # GTwiibdP8CUR2ghSM2sUTI8Nt1Omfc4SMHhGhYD64uJMbX98THQ/4LMGuYegou+d
  # GTiahfHtjn7AboSEknwAMJHCh5RlYZZ6B1O4QbKJ+34Q0eKgnI3X6Vc9u0zf6DH8
  # Dk+4zQDYRRTqTnVO3VT8jzqDlCRuNtq6YvryOWN74/dq8LQhUnXHvFyrsdMaE1X2
  # DwIDAQABo2MwYTAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBhjAdBgNV
  # HQ4EFgQUGRdkFnbGt1EWjKwbUne+5OaZvRYwHwYDVR0jBBgwFoAUGRdkFnbGt1EW
  # jKwbUne+5OaZvRYwDQYJKoZIhvcNAQELBQADggEBAHcqsHkrjpESqfuVTRiptJfP
  # 9JbdtWqRTmOf6uJi2c8YVqI6XlKXsD8C1dUUaaHKLUJzvKiazibVuBwMIT84AyqR
  # QELn3e0BtgEymEygMU569b01ZPxoFSnNXc7qDZBDef8WfqAV/sxkTi8L9BkmFYfL
  # uGLOhRJOFprPdoDIUBB+tmCl3oDcBy3vnUeOEioz8zAkprcb3GHwHAK+vHmmfgcn
  # WsfMLH4JCLa/tRYL+Rw/N3ybCkDp00s0WUZ+AoDywSl0Q/ZEnNY0MsFiw6LyIdbq
  # M/s/1JRtO3bDSzD9TazRVzn2oBqzSa8VgIo5C1nOnoAKJTlsClJKvIhnRlaLQqk=
  # EOF
  #     }
  #
  #     revoked_certificate {
  #       name       = "Verizon-Global-Root-CA"
  #       thumbprint = "912198EEF23DCAC40939312FEE97DD560BAE49B1"
  #     }
  #   }
}

# -----------------------------------------------------------------------------
# vpn gateway resource
#azurerm_virtual_network_gateway_connection
#https://www.terraform.io/docs/providers/azurerm/r/virtual_network_gateway_connection.html
resource "azurerm_virtual_network_gateway_connection" "mtColahVPNgwCon" {
  name                = "mtColahVPN-gwcon"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location            = "${var.location}"

  type                       = "IPsec"
  virtual_network_gateway_id = "${azurerm_virtual_network_gateway.mtColahVPNgw.id}"
  local_network_gateway_id   = "${azurerm_local_network_gateway.mtColahVPNnetgw.id}"
  shared_key                 = "${var.vpn_psk}"

  # ipsec_policy {
  #   dh_group         = "DHGroup2"
  #   ike_encryption   = "AES128"
  #   ike_integrity    = "SHA256"
  #   ipsec_encryption = "AES128"
  #   ipsec_integrity  = "SHA256"
  #   pfs_group        = "PFS2"
  #
  #   #sa_datasize = "" #optional
  #   #sa_lifetime = "" #optional
  # }
}
