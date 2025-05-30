#!/bin/bash
#set -euo pipefail

echo "# 1. プロジェクト作成"
oc new-project nodejs-test

echo "# 2. Ephemeral Storage でレジストリを有効化"
oc patch configs.imageregistry.operator.openshift.io cluster \
  --type merge -p '{"spec":{"managementState":"Managed","storage":{"emptyDir":{}}}}'

echo "# 3. Node.js アプリをソースからビルドしてデプロイ（Node.js 12）"
oc new-app --image-stream=openshift/nodejs:18-ubi9~https://github.com/sclorg/nodejs-ex.git
oc logs -f buildconfig/nodejs-ex
sleep 5

echo "# 4. サービスに対してルート（外部公開）を作成"
oc expose service nodejs-ex

echo "# 5. アクセス確認"
oc get route

echo "# 6. curlで動作確認"
ROUTE=$(oc get route nodejs-ex -o jsonpath='{.spec.host}')
echo "🌐 アクセスURL: http://$ROUTE"
w3m -dump http://$ROUTE || echo "⚠️ w3m failed"

read -p "Enter でプロジェクトを削除します"

echo "# 7. プロジェクト削除"
oc delete project nodejs-test

