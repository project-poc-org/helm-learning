{{/*
NAMED TEMPLATES - Reusable snippets
Learn: define, template, include, pipelines, functions
*/}}

{{/*
Expand the name of the chart.
*/}}
{{- define "myapp.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
Shows: conditionals, string functions
*/}}
{{- define "myapp.fullname" -}}
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
Create chart name and version as used by the chart label.
Shows: printf, replace
*/}}
{{- define "myapp.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels - demonstrates include and nindent
*/}}
{{- define "myapp.labels" -}}
helm.sh/chart: {{ include "myapp.chart" . }}
{{ include "myapp.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.podLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "myapp.selectorLabels" -}}
app.kubernetes.io/name: {{ include "myapp.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
Shows: if/else, default function
*/}}
{{- define "myapp.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "myapp.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Generate environment variables from map
Shows: range over map with $key, $value
*/}}
{{- define "myapp.envVars" -}}
{{- range $key, $value := .Values.env }}
- name: {{ $key }}
  value: {{ $value | quote }}
{{- end }}
{{- end }}

{{/*
Generate container ports
Shows: range over list, accessing object properties
*/}}
{{- define "myapp.containerPorts" -}}
- name: http
  containerPort: {{ .Values.service.targetPort }}
  protocol: TCP
{{- end }}

{{/*
Image pull policy based on tag
Shows: if/else if/else, eq function
*/}}
{{- define "myapp.imagePullPolicy" -}}
{{- if eq .Values.image.tag "latest" }}
Always
{{- else if eq .Values.image.pullPolicy "" }}
IfNotPresent
{{- else }}
{{ .Values.image.pullPolicy }}
{{- end }}
{{- end }}

{{/*
Calculate replicas
Shows: ternary-like logic
*/}}
{{- define "myapp.calculateReplicas" -}}
{{- if .Values.autoscaling.enabled }}
{{- .Values.autoscaling.minReplicas }}
{{- else }}
{{- .Values.replicaCount }}
{{- end }}
{{- end }}

{{/*
Generate comma-separated list of enabled features
Shows: complex logic with lists, range, if, join
*/}}
{{- define "myapp.enabledFeatures" -}}
{{- $features := list }}
{{- range $key, $value := .Values.features }}
  {{- if $value }}
    {{- $features = append $features $key }}
  {{- end }}
{{- end }}
{{- $features | join "," }}
{{- end }}
