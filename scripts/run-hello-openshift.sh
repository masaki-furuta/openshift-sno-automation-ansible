#!/bin/bash
#set -euo pipefail

echo "# 1. プロジェクト作成"
oc new-project hello-openshift

echo "# 2. サンプルアプリのデプロイ（hello-openshift イメージ）"
oc new-app --image=docker.io/openshift/hello-openshift
oc status
oc describe service/hello-openshift
read

echo "# 3. Routeを作成して外部アクセスを有効化"
oc expose service hello-openshift

echo "# 4. アクセス確認"
oc get route

echo "# 5. curlで確認"
ROUTE=$(oc get route hello-openshift -o jsonpath='{.spec.host}')
echo "🌐 アクセスURL: http://$ROUTE"
w3m -dump http://$ROUTE || echo "⚠️ w3m failed"

read -p "Enter でプロジェクトを削除します"

echo "# 6. プロジェクト削除"
oc delete project hello-openshift
