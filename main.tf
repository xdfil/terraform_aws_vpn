provider "aws" {
  region  = "us-east-2"
}

resource "aws_vpc" "demo_a01e_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_vpn_gateway" "demo_a01e_vgw" {
  vpc_id = "${aws_vpc.demo_a01e_vpc.id}"
}

resource "aws_customer_gateway" "demo_a01e_cgw" {
  bgp_asn    = 65000
  ip_address = "192.0.2.101"
  type       = "ipsec.1"

  tags = {
    Name = "demo_a01e"
  }
}

resource "aws_vpn_connection" "demo_a01e_vpn" {
  vpn_gateway_id      = "${aws_vpn_gateway.demo_a01e_vgw.id}"
  customer_gateway_id = "${aws_customer_gateway.demo_a01e_cgw.id}"
  type                = "ipsec.1"
  static_routes_only  = true

  tags = {
    Name = "demo_a01e"
  }
}

resource "aws_cloudwatch_metric_alarm" "demo_a01e_vpn_alarm" {
  alarm_name                = "Demo_a01e"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = "2"
  metric_name               = "TunnelState"
  namespace                 = "AWS/VPN"
  period                    = "120"
  statistic                 = "Maximum"
  threshold                 = "1"
  alarm_description         = "This metric monitors VPN state"
  insufficient_data_actions = ["<TOPIC_ARN>"]
  alarm_actions             = ["<TOPIC_ARN>"]
  ok_actions                = ["<TOPIC_ARN>"]
  dimensions = {
    VpnId  = aws_vpn_connection.demo_a01e_vpn.id
  }
}
