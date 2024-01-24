resource "juju_application" "webui" {
  name = "webui"
  model = var.model_name

  charm {
    name = "sdcore-webui-k8s"
    channel = var.channel
  }

  units = 1
  trust = true
}

module "mongodb-k8s" {
  source     = "gatici/mongodb-k8s/juju"
  model_name = var.model_name
}


resource "juju_integration" "webui-db" {
  model = var.model_name

  application {
    name     = juju_application.webui.name
    endpoint = "database"
  }

  application {
    name     = module.mongodb-k8s.db_application_name
    endpoint = "database"
  }
}


