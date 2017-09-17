# Mob-Map
モブプログラミングをやるにあたり goo地図API を叩くプログラムを作ることになったため  
それを行うための一式を作成しました。    

------------- 
## どんなプログラムか

（どんなプログラムかはまだ未定）

## 使うにあたっての事前準備  
1. docker のインストール  
Windows でも Mac でも以下からインストールできます。
<https://www.docker.com/>
2. git clone  
`git clone https://github.com/yasu-s-nttr/mob-map.git`

3. docker ディレクトリ内へ移動  
`cd mob-map/docker/`  

4. 開発環境（PC）で docker コンテナを実行、停止  
`deploy.sh dev {start|stop}`

5. IAMユーザの作成  
<http://docs.aws.amazon.com/ja_jp/IAM/latest/UserGuide/id_users_create.html>  
6. AWS CLI, ECS CLI のインストール  
Mac なら Homebrew(<https://brew.sh/index_ja.html>) で  
`brew install awscli`  
`brew install amazon-ecs-cli`  
Windows でもインストール方法があるはずです。

7. 開発したデータを ECR（Amazon EC2 Container Registry）にプッシュ  
IAMユーザを作成した際に得た ACCESS_KEY, SECRET_KEY を入力  
`deploy.sh pro config ACCESS_KEY SECRET_KEY`  
`deploy.sh pro imagepush`  
8. 本番環境 ECS（Amazon EC2 Container Service） に docker コンテナをアップロード、停止  
一台構成で作成する場合は  
`deploy.sh pro {start|stop}`  
二台構成で作成する場合は  
`deploy.sh pro {start-balance|stop}`  
start後は <http://map.nasu-nasu.jp> でアクセス可能  
1台目にアクセスする場合は <http://map1.nasu-nasu.jp> でも可能

* README.md を書くときの表示例をみるときのツール  
（ちょっと動作がおかしいので他に良いツールがあったら教えてください）  
<http://www.ctrlshift.net/project/markdowneditor/>