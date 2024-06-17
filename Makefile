# 現在のディレクトリ名を基に変数basenameを設定
basename = $(shell basename ${PWD})

# psqlコマンドを実行するためのターゲット
# PostgreSQLコンテナに接続し、psql CLIを起動する
.PHONY: psql
psql:
    sudo docker run -it --rm --network=${basename}_postgres_network postgres \
        psql -h ${basename}_db_1 -U postgres

# Adminerを起動するためのターゲット
# Adminerコンテナを起動し、8080ポートでアクセス可能にする
.PHONY: adminer
adminer:
    sudo docker run -it --rm -p 8080:8080 --network=${basename}_postgres_network adminer