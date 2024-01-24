resource "juju_model" "sdcore" {
  name = var.model_name
}

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
  version    = "1.0.2"
  model_name = var.model_name
}


resource "juju_integration" "webui-db" {
  model = var.model_name

  application {
    name     = juju_application.webui.name
    endpoint = "database"
  }

  application {
    name     = var.db_application_name
    endpoint = "database"
  }
}


