istioctl manifest generate --set profile=demo | kubectl delete -f -

kubectl create namespace istio-system
kubectl label namespace default istio-injection=enabled
kubectl apply -f kiali-secret.yaml

istioctl manifest generate \
--set values.gateways.istio-egressgateway.enabled=false \
--set values.gateways.istio-ingressgateway.sds.enabled=true \
--set "values.kiali.dashboard.grafanaURL=http://grafana:3000" \
--set addonComponents.grafana.enabled=true \
--set values.kiali.enabled=true \
--set "values.kiali.dashboard.grafanaURL=http://grafana:3000" \
--set values.tracing.enabled=true \
--set values.tracing.provider=zipkin > manifest-$(date +%F).yaml

kubectl apply -f manifest-$(date +%F).yaml

kubectl apply -f samples/httpbin/httpbin.yaml
