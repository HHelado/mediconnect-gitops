{{/*
Expand the name of the chart.
*/}}
{{- define "sa-platform.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "sa-platform.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Common labels using range, quote, default, and if
*/}}
{{- define "sa-platform.labels" -}}
helm.sh/chart: {{ include "sa-platform.chart" . }}
{{ include "sa-platform.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
app.kubernetes.io/environment: {{ default "production" .Values.global.environment | quote }}
{{- range $key, $val := .Values.global.extraLabels }}
{{ $key }}: {{ $val | quote }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "sa-platform.selectorLabels" -}}
app.kubernetes.io/name: {{ include "sa-platform.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "sa-platform.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Database hostname helper
*/}}
{{- define "sa-platform.databaseHost" -}}
{{- if .Values.postgresql.enabled -}}
{{- printf "%s-postgresql-headless" (include "sa-platform.fullname" .) -}}
{{- else -}}
{{- required "Un host de base de datos externo es requerido si postgresql.enabled es false" .Values.postgresql.externalHost -}}
{{- end -}}
{{- end }}

{{/*
Broker hostname helper
*/}}
{{- define "sa-platform.brokerUrl" -}}
{{- if .Values.nats.enabled -}}
{{- printf "nats://%s-nats:4222" (include "sa-platform.fullname" .) -}}
{{- else -}}
{{- default "nats://localhost:4222" .Values.nats.externalUrl -}}
{{- end -}}
{{- end }}
