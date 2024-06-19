# docker-postgresql-tutorial

## docker-compose.yml の書き方

1. **services**

   作成したいサービス（コンテナ）を列挙します。ここでは、`db`と`web`という 2 つのサービスを例として挙げています。

   ```yaml
   services:
     db: # サービス名
     web: # サービス名
   ```

2. **image**

   既存のイメージを使用し、追加の設定やカスタマイズを行う必要がない場合は、`image:`に続けて Docker イメージを指定します。これにより、指定されたイメージを基にコンテナがビルドされます。

   ```yaml
   image: postgres:latest # イメージ名:タグ
   ```

3. **build**

   `image:`を使用して既存のイメージからビルドするのではなく、カスタムの`Dockerfile`を用いてビルドする場合は、`build:`に続けて`Dockerfile`が置かれているディレクトリへの相対パスを記述します。

   ```yaml
   build: ./path/to/dockerfile/directory # Dockerfileが置いてあるディレクトリへの相対パス
   ```

4. **volumes**

   `volumes`はデータをコンテナの外に保存するための設定項目であり、ホストマシンにもデータを共有することでデータの永続性を可能にしています。これがないと、コンテナが削除されたときにそのコンテナ内にあった全てのデータが消えてしまいます。

   a. サービス内にある場合

   `volumes`はホスト側のディレクトリとコンテナ内のディレクトリをマウント、要は結びつけをするために使われ、ホスト上でコードを変更を行うと、その変更がリアルタイムでコンテナ内に反映されます。

   ```yaml
   # db コンテナ
   volumes:
     - db_data:/var/lib/postgresql/data  # ホストディレクトリ : コンテナ内ディレクトリ

   # web コンテナ
   volumes:
     - .:/myapp  # ホストディレクトリ : コンテナ内ディレクトリ
   ```

   b. トップレベルで指定している場合

   ここでの`volumes`は Docker Compose にボリュームを作成するように指示します。そしてここで定義されたボリュームはサービス内の`volumes`で使用することができ、サンプルにおいても`db`コンテナにおいて使用されています。

   ```yaml
   volumes:
     db_data:
   ```

   ボリュームを使うとデータは Docker コンテナの起動・停止のサイクルから独立して保存・管理できるため、コンテナが削除されてもボリュームに保存されたデータは保持されます。消したくないデータ等はボリュームに入れておくと良いでしょう。

5. **environment**

   `environment` は、Docker のコンテナ内で使用される環境変数を設定するために使用します。Docker コンテナはホストマシンの環境と完全に分離されて動作するため、コンテナ内部で環境変数を設定する必要があります。

   ```yaml
   environment:
     POSTGRES_PASSWORD: root_password
     POSTGRES_DB: your_database
     POSTGRES_USER: user_name
   ```

6. **ports**

   `ports` の設定では、ホストマシンと Docker コンテナ間でのネットワークポートのマッピングを指定します。指定する形式はホストマシンのポート番号:コンテナのポート番号となるので逆にならないように注意しましょう。

   ```yaml
   ports:
     - "3000:3000" # ホストマシンのポート番号:コンテナのポート番号
   ```

   `ports` の設定は Docker コンテナのアプリケーションがネットワークを通じて外部と通信するために必要な設定ですので、ネットワークを通じた外部とのやり取りがある場合は忘れずに設定しておきましょう。

7. **depends_on**

   `depends_on` はサービス間の依存関係を定義するために使用し、Docker Compose に指定したサービスが他の１つ以上のサービスに依存していることを伝えることができます。その結果、Docker Compose は、そのサービスを開始する前に依存している全てのサービスが先に開始されていることを確認してくれます。

   ```yaml
   # (web コンテナ)
   depends_on:
     - db
   ```

   上記の内容では、web コンテナが db コンテナに依存しているので、db コンテナが先に開始されることを Docker Compose は確認します。

8. **command**

   `command` はサービスコンテナが起動したときに実行するコマンドを指定します。

   ```yaml
   command: bundle exec rails s -p 3000 -b '0.0.0.0'
   ```

## Docker Compose コマンド

1. **コンテナ作成・起動【up】**

   ```bash
   $ docker compose up  # イメージが存在しないときはビルドする
   ```

   オプション：

   - --build：イメージをビルドした上でコンテナを作成・起動する
   - -d：コンテナをバッググラウンドで起動させる（detach）

2. **コンテナ一覧表示【ps】**

   ```bash
   $ docker compose ps 　　# コンテナの一覧を表示
   ```

   オプション：

   - -a：停止中を含めたコンテナの一覧を表示させたい場合（all）

3. **ログ表示【logs】**

   ```bash
   $ docker compose logs web 　# サービス名を指定
   ```

4. コンテナ作成後、コマンド実行【run】

   ```bash
   $ docker compose run web ruby app.rb 　# サービスとコマンドを指定
   ```

5. コマンド実行【exec】

   ```bash
   $ docker compose exec web /bin/sh # サービスとコマンドを指定
   ```

6. コンテナを停止・削除【down】

   ```bash
   $ docker compose down
   ```

## 参考資料

- Docker Compose コマンドリファレンス: [Docker ドキュメント](https://docs.docker.jp/engine/reference/commandline/compose_toc.html)
