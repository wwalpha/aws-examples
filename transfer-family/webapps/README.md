# Transfer Family Web App Demo

## 概要
AWS Transfer Family Web App を使用して、S3 Access Grants と連携したブラウザベースのファイル転送環境を構築する Terraform テンプレートです。
検証用に Windows EC2 インスタンスもプライベートサブネットに構築されます。

## アーキテクチャ詳細

### ネットワーク構成
本環境は、インターネットからの直接アクセスを極力排除した閉域網に近い構成をとっています。

- **VPC**: 1つの VPC 内に Public/Private サブネットを構成。
- **Private Subnet**:
  - **Windows クライアント (EC2)**: 検証用端末。Public IP を持たず、インターネットから直接到達不能。操作は Systems Manager Session Manager のポートフォワーディング機能を利用して行う。
  - **VPC Endpoints (Interface)**: AWS サービスへの通信を VPC 内部に閉じるために配置。
    - `transfer`: Web App への HTTPS アクセス用。
    - `s3`: Web App から S3 へのデータアクセス用。
    - `ssm`, `ssmmessages`, `ec2messages`: EC2 への管理アクセス用。

### 認証・認可フロー (S3 Access Grants)
従来の IAM Role ベースのアクセス制御とは異なり、Identity Center のユーザー ID に基づいた動的な権限管理を行います。

1. **ユーザー認証**:
   ユーザーは Windows 端末上のブラウザから Web App にアクセスし、**IAM Identity Center** で認証を行います。
2. **権限取得**:
   Web App は認証されたユーザーの Identity Center グループ情報 (`test_group`) に基づき、**S3 Access Grants** に対して S3 へのアクセス権限を要求します。
3. **一時クレデンシャル発行**:
   S3 Access Grants は、事前に定義された Grant (許可ルール) に従って、そのユーザー専用の一時的な認証情報を発行します。この際、バックグラウンドで `sts:SetContext` 権限を持つ IAM ロールが使用されます。
4. **データアクセス**:
   ブラウザ上の Web App は、取得した一時クレデンシャルを使用して、VPC エンドポイント経由で直接 S3 バケットに対して API リクエスト (List, Get, Put 等) を行います。

### セキュリティ設定
- **S3 CORS (Cross-Origin Resource Sharing)**:
  Web App はブラウザ上で動作し、異なるドメインにある S3 バケットへ直接リクエストを送信します。そのため、S3 バケット側で Web App のドメイン (`https://*.transfer-webapp.<region>.on.aws`) からのアクセスを許可する CORS 設定が必須となります。
- **IAM Roles**:
  - `Web App Role`: Web App リソース自体が Identity Center と連携するために必要なロール。
  - `S3 Access Grants Role`: S3 Access Grants がユーザーに代わって S3 にアクセスする権限を委譲するためのロール。

## 構成要素
- **Transfer Family Web App**: VPC エンドポイント経由でアクセス可能な Web アプリケーション。
- **S3 Access Grants**: Identity Center のユーザー/グループに基づいて S3 へのアクセス権限を管理。
- **S3 Buckets**: 転送確認用の2つのバケット (`dummy.txt`, `dummy2.txt` が配置済み)。
- **Identity Center**: テストユーザーとグループの作成、Web App への割り当て。
- **EC2 (Windows Server)**: Web App へのアクセス確認用クライアント (Private Subnet)。
- **VPC Endpoints**: Transfer Family, S3, SSM へのプライベートアクセス用。

## 前提条件
- AWS アカウント
- Terraform インストール済み
- AWS Identity Center が有効化されていること (同じリージョン)

## デプロイ方法

1. 初期化
   ```bash
   terraform init
   ```

2. 計画と適用
   ```bash
   terraform apply
   ```

## 変数 (Variables)
| 変数名 | 説明 | デフォルト値 |
| --- | --- | --- |
| `region` | AWS リージョン | `ap-northeast-1` |
| `project_name` | リソース名のプレフィックス | `transfer-webapp-demo` |
| `user_name` | 作成する Identity Center ユーザー名 | `test_user` |
| `group_name` | 作成する Identity Center グループ名 | `test_group` |
| `windows_admin_password` | Windows Administrator パスワード | `Password123!` |

## 出力 (Outputs)
- `webapp_endpoint`: Web アプリケーションの URL
- `ec2_instance_id`: 検証用 Windows インスタンスの ID
- `s3_bucket_name`: 作成された S3 バケット名

## 検証手順

### 1. Windows クライアントへの接続
EC2 インスタンスはプライベートサブネットに配置されており、パブリック IP を持ちません。
AWS Systems Manager (Session Manager) のポートフォワーディング機能を使用して RDP 接続を行います。

1. ローカル端末で以下のコマンドを実行し、ポートフォワーディングを開始します。
   ```bash
   aws ssm start-session --target <ec2_instance_id> --document-name AWS-StartPortForwardingSession --parameters '{"portNumber":["3389"],"localPortNumber":["33389"]}'
   ```
2. リモートデスクトップクライアントで `localhost:33389` に接続します。
   - ユーザー: `Administrator`
   - パスワード: `Password123!` (または `windows_admin_password` で指定した値)

### 2. Web App へのアクセス
1. Windows クライアント内のブラウザ (Chrome/Edge) を開きます。
2. `terraform output webapp_endpoint` で表示された URL にアクセスします。
3. Identity Center のユーザー (`test_user`) でログインします。
   - **注意**: Identity Center ユーザーのパスワードは Terraform では設定されません。AWS コンソールの Identity Center 画面からユーザーを選択し、「ワンタイムパスワードを送信」などでパスワードを設定/リセットしてからログインしてください。
4. 2つのバケットが表示され、ファイルのアップロード・ダウンロードが可能であることを確認します。

## 注意事項
- `awscc` プロバイダーを使用しているため、AWS Cloud Control API が利用可能なリージョンである必要があります。
- 検証後は `terraform destroy` でリソースを削除してください。
