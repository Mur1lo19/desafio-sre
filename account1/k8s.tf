resource "kubernetes_deployment" "ms_gateway_deployment" {
  metadata {
    name = "ms-gateway"
    labels = {
      app = "ms-gateway"
    }
  }
  spec {
    replicas = 5
    selector {
      match_labels = {
        app = "ms-gateway"
      }
    }
    template {
      metadata {
        labels = {
          app = "ms-gateway"
        }
      }
      spec {
        container {
          name  = "ms-gateway"
          image = "nginx:latest"
          
          resources {
            limits = {
              cpu    = "500m"
              memory = "1024Mi"
            }
            requests = {
              cpu    = "200m"
              memory = "512Mi"
            }
          }
          liveness_probe {
            http_get {
              path = "/"
              port = 80

              http_header {
                name  = "X-Custom-Header"
                value = "Awesome"
              }
            }
            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "ms_gateway_service" {
  metadata {
    name = "ms-gateway"
  }
  spec {
    selector = {
      app = "ms-gateway"
    }
    session_affinity = "ClientIP"
    port {
      port        = 8080
      target_port = 80
    }
    type = "LoadBalancer"
  }
}

resource "kubernetes_horizontal_pod_autoscaler_v2" "ms_gateway_hpa" {
  metadata {
    name = "ms-gateway-hpa"
  }
  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment.ms_gateway_deployment.metadata[0].name
    }
    min_replicas = 5
    max_replicas = 100
    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type               = "Utilization"
          average_utilization = 50
        }
      }
    }
  }
}