{{- define "webAppLabel" }}
app: java-web-app
{{- end }}

{{- define "ingress.annotations.eks" }}
alb.ingress.kubernetes.io/scheme: internet-facing
alb.ingress.kubernetes.io/target-type: ip
{{- end }}

{{- define "ingress.annotations.nginx" }}
nginx.ingress.kubernetes.io/rewrite-target: /
{{- end }}