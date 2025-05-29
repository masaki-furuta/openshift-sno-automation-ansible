#!/bin/bash
set -euo pipefail

echo "# 1. プロジェクト作成"
oc new-project nodejs-test

echo "# 2. Node.js アプリをソースからビルドしてデプロイ（Node.js 12）"
oc new-app --image-stream=openshift/nodejs:18-ubi9~https://github.com/sclorg/nodejs-ex.git

echo "# 3. サービスに対してルート（外部公開）を作成"
oc expose service nodejs-ex

echo "# 4. アクセス確認"
oc get route

echo "# 5. curlで動作確認"
ROUTE=$(oc get route nodejs-ex -o jsonpath='{.spec.host}')
echo "🌐 アクセスURL: http://$ROUTE"
w3m http://$ROUTE || echo "⚠️ curl failed"

