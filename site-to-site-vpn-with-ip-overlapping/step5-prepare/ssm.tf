# ----------------------------------------------------------------------------------------------
# AWS System Manager Document - ConfigureVPNRouter
# ----------------------------------------------------------------------------------------------
resource "aws_ssm_document" "router" {
  name            = "ConfigureVPNRouter"
  document_format = "YAML"
  document_type   = "Command"

  content = <<DOC
---
schemaVersion: '2.2'
description: Configure VPN Router settings.
parameters:
  customerGatewayAddress:
    type: String
  customerGatewaySubnet:
    type: String
  vpnTunnelAddress:
    type: String
  vpnSubnet:
    type: String
  pskKey:
    type: String
mainSteps:
- action: aws:runShellScript
  name: ConfigureVPN
  inputs:
    runCommand:
    - echo -e "net.ipv4.ip_forward = 1" > /etc/sysctl.conf
    - echo -e "net.ipv4.conf.default.rp_filter = 0" >> /etc/sysctl.conf
    - echo -e "net.ipv4.conf.default.accept_source_route = 0" >> /etc/sysctl.conf
    - sysctl -p
    - echo -e "conn Tunnel1" > /etc/ipsec.d/aws.conf
    - echo -e "     authby=secret" >> /etc/ipsec.d/aws.conf
    - echo -e "     auto=start" >> /etc/ipsec.d/aws.conf
    - echo -e "     left=%defaultroute" >> /etc/ipsec.d/aws.conf
    - echo -e "     leftid={{ customerGatewayAddress }}" >> /etc/ipsec.d/aws.conf
    - echo -e "     right={{ vpnTunnelAddress }}" >> /etc/ipsec.d/aws.conf
    - echo -e "     type=tunnel" >> /etc/ipsec.d/aws.conf
    - echo -e "     ikelifetime=8h" >> /etc/ipsec.d/aws.conf
    - echo -e "     keylife=1h" >> /etc/ipsec.d/aws.conf
    - echo -e "     phase2alg=aes128-sha1;modp1024" >> /etc/ipsec.d/aws.conf
    - echo -e "     ike=aes128-sha1;modp1024" >> /etc/ipsec.d/aws.conf
    - echo -e "     keyingtries=%forever" >> /etc/ipsec.d/aws.conf
    - echo -e "     keyexchange=ike" >> /etc/ipsec.d/aws.conf
    - echo -e "     leftsubnet={{ customerGatewaySubnet }}" >> /etc/ipsec.d/aws.conf
    - echo -e "     rightsubnet={{ vpnSubnet }}" >> /etc/ipsec.d/aws.conf
    - echo -e "     dpddelay=10" >> /etc/ipsec.d/aws.conf
    - echo -e "     dpdtimeout=30" >> /etc/ipsec.d/aws.conf
    - echo -e "     dpdaction=restart_by_peer" >> /etc/ipsec.d/aws.conf
    - "echo -e \"{{ customerGatewayAddress }} {{ vpnTunnelAddress }}: PSK \\\"{{ pskKey\
      \ }}\\\"\" > /etc/ipsec.d/aws.secrets"
    - systemctl restart ipsec
    - systemctl status ipsec
DOC
}

# ----------------------------------------------------------------------------------------------
# Configure VPN Router for OnPremise JP
# ----------------------------------------------------------------------------------------------
resource "null_resource" "configure_vpn_jp" {
  depends_on = [aws_ssm_document.router]
  provisioner "local-exec" {
    command = <<EOF
aws ssm send-command \
    --document-name ${aws_ssm_document.router.name} \
    --instance-ids ${var.instance_id_router_jp} \
    --parameters customerGatewayAddress=${local.customer_gateway_address_jp},customerGatewaySubnet=${var.ipv4_cidr_onpremise_jp},vpnTunnelAddress=${var.tunnel_address_jp},vpnSubnet=${var.ipv4_cidr_aws_jp},pskKey=${var.s2s_psk_key_jp} \
    --output text
EOF
  }
}

# ----------------------------------------------------------------------------------------------
# Configure VPN Router for OnPremise EU
# ----------------------------------------------------------------------------------------------
resource "null_resource" "configure_vpn_eu" {
  depends_on = [aws_ssm_document.router]
  provisioner "local-exec" {
    command = <<EOF
aws ssm send-command \
    --document-name ${aws_ssm_document.router.name} \
    --instance-ids ${var.instance_id_router_eu} \
    --parameters customerGatewayAddress=${local.customer_gateway_address_eu},customerGatewaySubnet=${var.ipv4_cidr_onpremise_eu},vpnTunnelAddress=${var.tunnel_address_eu},vpnSubnet=${var.ipv4_cidr_aws_eu},pskKey=${var.s2s_psk_key_eu} \
    --output text
EOF
  }
}

# ----------------------------------------------------------------------------------------------
# Configure VPN Router for OnPremise US
# ----------------------------------------------------------------------------------------------
resource "null_resource" "configure_vpn_us" {
  depends_on = [aws_ssm_document.router]
  provisioner "local-exec" {
    command = <<EOF
aws ssm send-command \
    --document-name ${aws_ssm_document.router.name} \
    --instance-ids ${var.instance_id_router_us} \
    --parameters customerGatewayAddress=${local.customer_gateway_address_us},customerGatewaySubnet=${var.ipv4_cidr_onpremise_us},vpnTunnelAddress=${var.tunnel_address_us},vpnSubnet=${var.ipv4_cidr_aws_us},pskKey=${var.s2s_psk_key_us} \
    --output text
EOF
  }
}
