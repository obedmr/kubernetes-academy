terraform {
  backend "gcs" {
    bucket = "academy-infra"
    prefix = "terraform/state"
  }
}

resource "google_compute_network" "academy-vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
  project                 = var.project_id
}

resource "google_compute_subnetwork" "academy-subnet" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_cidr_range
  project       = var.project_id
  region        = var.region
  network       = google_compute_network.academy-vpc.self_link
  secondary_ip_range {
    range_name    = var.pods_range_name
    ip_cidr_range = var.pods_cidr_range
  }
  secondary_ip_range {
    range_name    = var.services_range_name
    ip_cidr_range = var.services_cidr_range
  }
}

resource "google_project_iam_member" "academy_group" {
  project = "wizeline-academy-k8s-36bd66a7"
  role    = "roles/viewer"
  member  = "group:kubernetes-academy@wizeline.com"
}

resource "google_project_iam_member" "academy_group_k8s_viewer" {
  project = var.project_id
  role    = "roles/container.clusterViewer"
  member  = "group:kubernetes-academy@wizeline.com"
}

resource "google_project_iam_member" "academy_group_k8s_student" {
  project = var.project_id
  role    = google_project_iam_custom_role.academy-intro-student.id
  member  = "group:${var.academy_google_group}"
}

resource "google_compute_firewall" "gke-academy-nodes" {
  project = var.project_id
  name    = "gke-academy-nodes-services"
  network = google_compute_network.academy-vpc.name
  allow {
    protocol = "tcp"
    ports    = ["30000-32767"]
  }
  description   = "Allows k8s services of type NodePort to be reachable from the internet."
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["gke-gke-academy-1"]
}

resource "google_project_iam_custom_role" "academy-intro-student" {
  project     = var.project_id
  role_id     = "CustomK8sAcademyIntroStudent"
  title       = "Kubernetes Academy Intro Student"
  description = "Used to grant access to the students to out K8s cluster with least privilege."
  permissions = [
    # "container.apiServices.create",
    # "container.apiServices.delete",
    "container.apiServices.get",
    "container.apiServices.list",
    "container.apiServices.update",
    "container.apiServices.updateStatus",
    # "container.backendConfigs.create",
    # "container.backendConfigs.delete",
    "container.backendConfigs.get",
    "container.backendConfigs.list",
    # "container.backendConfigs.update",
    # "container.bindings.create",
    # "container.bindings.delete",
    "container.bindings.get",
    "container.bindings.list",
    # "container.bindings.update",
    # "container.certificateSigningRequests.create",
    # "container.certificateSigningRequests.delete",
    "container.certificateSigningRequests.get",
    "container.certificateSigningRequests.list",
    # "container.certificateSigningRequests.update",
    # "container.certificateSigningRequests.updateStatus",
    "container.clusterRoleBindings.get",
    "container.clusterRoleBindings.list",
    "container.clusterRoles.get",
    "container.clusterRoles.list",
    # "container.clusters.get",
    # "container.clusters.list",
    "container.componentStatuses.get",
    "container.componentStatuses.list",
    "container.configMaps.create",
    "container.configMaps.delete",
    "container.configMaps.get",
    "container.configMaps.list",
    "container.configMaps.update",
    "container.controllerRevisions.get",
    "container.controllerRevisions.list",
    "container.cronJobs.create",
    "container.cronJobs.delete",
    "container.cronJobs.get",
    "container.cronJobs.getStatus",
    "container.cronJobs.list",
    "container.cronJobs.update",
    "container.cronJobs.updateStatus",
    # "container.csiDrivers.create",
    # "container.csiDrivers.delete",
    # "container.csiDrivers.get",
    # "container.csiDrivers.list",
    # "container.csiDrivers.update",
    # "container.csiNodes.create",
    # "container.csiNodes.delete",
    # "container.csiNodes.get",
    # "container.csiNodes.list",
    # "container.csiNodes.update",
    # "container.customResourceDefinitions.create",
    # "container.customResourceDefinitions.delete",
    # "container.customResourceDefinitions.get",
    # "container.customResourceDefinitions.list",
    # "container.customResourceDefinitions.update",
    # "container.customResourceDefinitions.updateStatus",
    "container.daemonSets.create",
    "container.daemonSets.delete",
    "container.daemonSets.get",
    "container.daemonSets.getStatus",
    "container.daemonSets.list",
    "container.daemonSets.update",
    "container.daemonSets.updateStatus",
    "container.deployments.create",
    "container.deployments.delete",
    "container.deployments.get",
    "container.deployments.getScale",
    "container.deployments.getStatus",
    "container.deployments.list",
    "container.deployments.rollback",
    "container.deployments.update",
    "container.deployments.updateScale",
    "container.deployments.updateStatus",
    "container.endpoints.create",
    "container.endpoints.delete",
    "container.endpoints.get",
    "container.endpoints.list",
    "container.endpoints.update",
    "container.events.create",
    "container.events.delete",
    "container.events.get",
    "container.events.list",
    "container.events.update",
    "container.horizontalPodAutoscalers.create",
    "container.horizontalPodAutoscalers.delete",
    "container.horizontalPodAutoscalers.get",
    "container.horizontalPodAutoscalers.getStatus",
    "container.horizontalPodAutoscalers.list",
    "container.horizontalPodAutoscalers.update",
    "container.horizontalPodAutoscalers.updateStatus",
    "container.ingresses.create",
    "container.ingresses.delete",
    "container.ingresses.get",
    "container.ingresses.getStatus",
    "container.ingresses.list",
    "container.ingresses.update",
    "container.ingresses.updateStatus",
    # "container.initializerConfigurations.create",
    # "container.initializerConfigurations.delete",
    # "container.initializerConfigurations.get",
    # "container.initializerConfigurations.list",
    # "container.initializerConfigurations.update",
    # "container.jobs.create",
    # "container.jobs.delete",
    # "container.jobs.get",
    # "container.jobs.getStatus",
    # "container.jobs.list",
    # "container.jobs.update",
    # "container.jobs.updateStatus",
    # "container.limitRanges.create",
    # "container.limitRanges.delete",
    # "container.limitRanges.get",
    # "container.limitRanges.list",
    # "container.limitRanges.update",
    # "container.localSubjectAccessReviews.create",
    # "container.localSubjectAccessReviews.list",
    "container.namespaces.create",
    # "container.namespaces.delete",
    "container.namespaces.get",
    "container.namespaces.getStatus",
    "container.namespaces.list",
    "container.namespaces.update",
    "container.namespaces.updateStatus",
    # "container.networkPolicies.create",
    # "container.networkPolicies.delete",
    # "container.networkPolicies.get",
    # "container.networkPolicies.list",
    # "container.networkPolicies.update",
    # "container.nodes.create",
    # "container.nodes.delete",
    # "container.nodes.get",
    # "container.nodes.getStatus",
    # "container.nodes.list",
    # "container.nodes.proxy",
    # "container.nodes.update",
    # "container.nodes.updateStatus",
    "container.persistentVolumeClaims.create",
    "container.persistentVolumeClaims.delete",
    "container.persistentVolumeClaims.get",
    "container.persistentVolumeClaims.getStatus",
    "container.persistentVolumeClaims.list",
    "container.persistentVolumeClaims.update",
    "container.persistentVolumeClaims.updateStatus",
    "container.persistentVolumes.create",
    "container.persistentVolumes.delete",
    "container.persistentVolumes.get",
    "container.persistentVolumes.getStatus",
    "container.persistentVolumes.list",
    "container.persistentVolumes.update",
    "container.persistentVolumes.updateStatus",
    # "container.petSets.create",
    # "container.petSets.delete",
    # "container.petSets.get",
    # "container.petSets.list",
    # "container.petSets.update",
    # "container.petSets.updateStatus",
    # "container.podDisruptionBudgets.create",
    # "container.podDisruptionBudgets.delete",
    # "container.podDisruptionBudgets.get",
    # "container.podDisruptionBudgets.getStatus",
    # "container.podDisruptionBudgets.list",
    # "container.podDisruptionBudgets.update",
    # "container.podDisruptionBudgets.updateStatus",
    # "container.podPresets.create",
    # "container.podPresets.delete",
    # "container.podPresets.get",
    # "container.podPresets.list",
    # "container.podPresets.update",
    # "container.podSecurityPolicies.get",
    # "container.podSecurityPolicies.list",
    # "container.podTemplates.create",
    # "container.podTemplates.delete",
    # "container.podTemplates.get",
    # "container.podTemplates.list",
    # "container.podTemplates.update",
    "container.pods.attach",
    "container.pods.create",
    "container.pods.delete",
    "container.pods.evict",
    "container.pods.exec",
    "container.pods.get",
    "container.pods.getLogs",
    "container.pods.getStatus",
    "container.pods.initialize",
    "container.pods.list",
    "container.pods.portForward",
    "container.pods.proxy",
    "container.pods.update",
    "container.pods.updateStatus",
    "container.replicaSets.create",
    "container.replicaSets.delete",
    "container.replicaSets.get",
    "container.replicaSets.getScale",
    "container.replicaSets.getStatus",
    "container.replicaSets.list",
    "container.replicaSets.update",
    "container.replicaSets.updateScale",
    "container.replicaSets.updateStatus",
    "container.replicationControllers.create",
    "container.replicationControllers.delete",
    "container.replicationControllers.get",
    "container.replicationControllers.getScale",
    "container.replicationControllers.getStatus",
    "container.replicationControllers.list",
    "container.replicationControllers.update",
    "container.replicationControllers.updateScale",
    "container.replicationControllers.updateStatus",
    # "container.resourceQuotas.create",
    # "container.resourceQuotas.delete",
    # "container.resourceQuotas.get",
    # "container.resourceQuotas.getStatus",
    # "container.resourceQuotas.list",
    # "container.resourceQuotas.update",
    # "container.resourceQuotas.updateStatus",
    # "container.roleBindings.get",
    # "container.roleBindings.list",
    # "container.roles.get",
    # "container.roles.list",
    # "container.runtimeClasses.create",
    # "container.runtimeClasses.delete",
    # "container.runtimeClasses.get",
    # "container.runtimeClasses.list",
    # "container.runtimeClasses.update",
    # "container.scheduledJobs.create",
    # "container.scheduledJobs.delete",
    # "container.scheduledJobs.get",
    # "container.scheduledJobs.list",
    # "container.scheduledJobs.update",
    # "container.scheduledJobs.updateStatus",
    "container.secrets.create",
    "container.secrets.delete",
    "container.secrets.get",
    "container.secrets.list",
    "container.secrets.update",
    # "container.selfSubjectAccessReviews.create",
    # "container.selfSubjectAccessReviews.list",
    # "container.serviceAccounts.create",
    # "container.serviceAccounts.delete",
    "container.serviceAccounts.get",
    "container.serviceAccounts.list",
    # "container.serviceAccounts.update",
    "container.services.create",
    "container.services.delete",
    "container.services.get",
    "container.services.getStatus",
    "container.services.list",
    "container.services.proxy",
    "container.services.update",
    "container.services.updateStatus",
    # "container.statefulSets.create",
    # "container.statefulSets.delete",
    # "container.statefulSets.get",
    # "container.statefulSets.getScale",
    # "container.statefulSets.getStatus",
    # "container.statefulSets.list",
    # "container.statefulSets.update",
    # "container.statefulSets.updateScale",
    # "container.statefulSets.updateStatus",
    # "container.storageClasses.create",
    # "container.storageClasses.delete",
    # "container.storageClasses.get",
    # "container.storageClasses.list",
    # "container.storageClasses.update",
    # "container.subjectAccessReviews.create",
    # "container.subjectAccessReviews.list",
    # "container.thirdPartyObjects.create",
    # "container.thirdPartyObjects.delete",
    # "container.thirdPartyObjects.get",
    # "container.thirdPartyObjects.list",
    # "container.thirdPartyObjects.update",
    # "container.thirdPartyResources.create",
    # "container.thirdPartyResources.delete",
    # "container.thirdPartyResources.get",
    # "container.thirdPartyResources.list",
    # "container.thirdPartyResources.update",
    # "container.tokenReviews.create",
    # "resourcemanager.projects.get",
    # "resourcemanager.projects.list"
  ]
}