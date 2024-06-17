# 現在のディレクトリ名を基に変数basenameを設定する
basename = $(shell basename $(PWD))

# psqlコマンドを実行するためのターゲットを定義する
# このターゲットは、PostgreSQLコンテナに接続し、psql CLIを起動する
.PHONY: psql
psql:
    # Dockerを使用してPostgreSQLコンテナに接続し、psql CLIを起動する
    # --networkオプションで指定されたネットワークを介して接続する
    sudo docker run -it --rm --network=${basename}_postgresql-network postgres \
    psql -h docker-postgresql-tutorial-db-1 -U postgres

# Adminerを起動するためのターゲットを定義する
# このターゲットは、Adminerコンテナを起動し、8081ポートでアクセス可能にする
.PHONY: adminer
adminer:
    # Dockerを使用してAdminerコンテナを起動する
    # 8081ポートを開放し、--networkオプションで指定されたネットワークを介して接続する
    sudo docker run -it --rm -p 8081:8080 --network=${basename}_postgresql-network adminer