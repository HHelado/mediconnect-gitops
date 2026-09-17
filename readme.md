# MediConnect - Repositorio GitOps de Manifiestos Declarativos

Este repositorio constituye la **unica fuente de verdad** (*Single Source of Truth*) para el despliegue y operacion de la plataforma hospitalaria **MediConnect** en Kubernetes, administrado exclusivamente bajo el modelo **GitOps** mediante **ArgoCD**.

---

## 1. Estructura del Repositorio

- **charts/sa-platform/**: Helm Chart central parametrizado con subcharts para los 5 microservicios (pi-gateway, uth-service, doctors-service, ppointments-service, lab-results-service) y componentes de infraestructura (PostgreSQL, NATS JetStream, CronJobs).
  - **	emplates/**: Manifiestos declarativos donde los despliegues de microservicios utilizan kind: Rollout de Argo Rollouts para entrega progresiva (estrategia Canary).
  - **	emplates/analysistemplate.yaml**: Metricas de evaluacion automatica para la promocion y reversion del Canary.
  - **	emplates/secrets.yaml**: Secretos cifrados asimetricamente mediante kind: SealedSecret de Bitnami (cero texto plano).
  - **alues.yaml**, **alues-dev.yaml**, **alues-prod.yaml**: Valores de configuracion diferenciados por ambiente, validados mediante helm lint.
- **pps/application.yaml**: Manifiesto del recurso Custom Resource Definition (CRD) Application de ArgoCD para sincronizacion continua hacia el namespace sa-p8.

---

## 2. Politicas de Operacion GitOps

1. **Prohibicion de Despliegue Directo:** No se permiten modificaciones manuales con kubectl apply ni desde los pipelines de CI.
2. **Actualizacion por Pull Request:** Los cambios de version en las imagenes de contenedor son propuestos exclusivamente a traves de Pull Requests generados de forma automatica por el pipeline de Integracion Continua tras superar pruebas, escaneo de vulnerabilidades con Trivy y firma criptografica con Cosign.
3. **Reconciliacion Declarativa:** ArgoCD detecta cualquier discrepancia (*drift*) entre este repositorio y el estado real del cluster, forzando la convergencia hacia el estado declarado.
