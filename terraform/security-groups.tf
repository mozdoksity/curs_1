#--------------------------security_group------------------------


#создаем группы безопасности(firewall)

# ---------------------- Security Bastion --------------------

resource "yandex_vpc_security_group" "bastion-bars" {
  name       = "bastion-bars"
  network_id = yandex_vpc_network.network.id
  
  ingress {
    description    = "Allow 0.0.0.0/0"
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  egress {
    description    = "Permit ANY"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }

}

resource "yandex_vpc_security_group" "web-bars" {
  name       = "web-bars"
  network_id = yandex_vpc_network.network.id
  ingress {
    description    = "Allow HTTPS"
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description    = "Allow HTTP"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}


# ---------------------Security SSH Traffic----------------------

resource "yandex_vpc_security_group" "ssh-traffic-bars" {
  name       = "ssh-traffic-bars"
  network_id = yandex_vpc_network.network.id
 
  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["10.0.15.0/24", "10.0.30.0/24"]
  }

  ingress {
    protocol       = "ICMP"
    v4_cidr_blocks = ["10.0.15.0/24", "10.0.30.0/24"]
  }
}

# ---------------------Security WebServers-------------------------

resource "yandex_vpc_security_group" "webservers-bars" {
  name       = "webservers-bars"
  network_id = yandex_vpc_network.network.id

  ingress {
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["10.0.15.0/24", "10.0.30.0/24"]
  }

  ingress {
    protocol       = "TCP"
    port           = 8080
    v4_cidr_blocks = ["10.0.15.0/24", "10.0.30.0/24"]
  }

  ingress {
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["10.0.15.0/24", "10.0.30.0/24"]
  }

  ingress {
    protocol       = "TCP"
    port           = 9100
    v4_cidr_blocks = ["10.0.15.0/24", "10.0.30.0/24"]
  }

  ingress {
    protocol       = "TCP"
    port           = 9113
    v4_cidr_blocks = ["10.0.15.0/24", "10.0.30.0/24"]
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# -------------------------Security Prometheus-------------------------

resource "yandex_vpc_security_group" "prometheus-bars" {
  name       = "prometheus-bars"
  network_id = yandex_vpc_network.network.id

  ingress {
    protocol       = "TCP"
    port           = 9090
    v4_cidr_blocks = ["10.0.15.0/24", "10.0.30.0/24"]
  }

  ingress {
    description    = "Node-Exporter traffic"
    protocol       = "TCP"
    port           = 9100
    v4_cidr_blocks = ["10.0.15.0/24", "10.0.30.0/24"]
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# -------------------Security Grafana-----------------------

resource "yandex_vpc_security_group" "grafana-bars" {
  name       = "grafana-bars"
  network_id = yandex_vpc_network.network.id

  ingress {
    protocol       = "TCP"
    port           = 3000
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    port           = 9100
    v4_cidr_blocks = ["10.0.15.0/24", "10.0.30.0/24"]
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# ---------------------Security ElasticSearch----------------------

resource "yandex_vpc_security_group" "elasticsearch-bars" {
  name       = "elasticsearch-bars"
  network_id = yandex_vpc_network.network.id

  ingress {
    protocol       = "TCP"
    port           = 9200
    v4_cidr_blocks = ["10.0.15.0/24", "10.0.30.0/24"]
  }

  ingress {
    protocol       = "TCP"
    port           = 9100
    v4_cidr_blocks = ["10.0.15.0/24", "10.0.30.0/24"]
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# -------------------Security Kibana-----------------------

resource "yandex_vpc_security_group" "kibana-bars" {
  name       = "kibana-bars"
  network_id = yandex_vpc_network.network.id

  ingress {
    protocol       = "TCP"
    port           = 5601
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    port           = 9100
    v4_cidr_blocks = ["10.0.15.0/24", "10.0.30.0/24"]
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# -----------------Security Public Load Balancer---------------

resource "yandex_vpc_security_group" "alb-bars" {
  name       = "alb-bars"
  network_id = yandex_vpc_network.network.id

  ingress {
    protocol          = "ANY"
    description       = "Health checks"
    v4_cidr_blocks    = ["0.0.0.0/0"]
    predefined_target = "load_balancer_healthchecks"
  }

  ingress {
    protocol       = "TCP"
    description    = "allow HTTP connections from internet"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    description    = "allow HTTPS connections from internet"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }

  ingress {
    protocol       = "ICMP"
    description    = "allow ping"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}