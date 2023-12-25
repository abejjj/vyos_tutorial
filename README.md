VyOSをdocker-composeで起動する際のサンプル・チュートリアルです。

### Dockerイメージのビルド
sudoが可能なユーザで `./build/build_docker_image.sh` を実行します。 
また、事前に以下をインストールしてください。

```
docker
unsquashfs

```
### docker-composeの起動
VyOSのコンテナがGOSUを利用している都合上、環境変数の設定が必要なため、.envファイル化しています。
以下を事前に実行してください。

```
export GOSU_UID=$(id -u)
export GOSU_GID=$(id -g)
#イメージ名はよしなに取得して設定してください。以下は例です。
export IMAGENAME=$(docker images  --format "{{json . }}" | jq  -cr 'select(.Repository | test("^vyos-[0-9.]+-rolling")) | (.Repository + ":" +  .Tag)')

envsubst < ./vrouter/.env.template > ./vrouter/.env

```
