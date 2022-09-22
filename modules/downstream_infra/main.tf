provider "rancher2" {
  api_url   = "https://${var.rancher_hostname}"
  bootstrap = true
}

resource "rancher2_bootstrap" "admin" {
    initial_password = "${var.bootstrapPassword}"
    password         =  "${var.admin_password}"
    telemetry        = true
    
  
}