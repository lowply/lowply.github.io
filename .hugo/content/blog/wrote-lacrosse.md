+++
categories = ["Go"]
date = "2017-01-14T03:33:43+09:00"
description = ""
draft = false
slug = "wrote-lacrosse"
title = "AWS Route 53用のCLIツールをGoで書いた"

+++

AWS Route 53 上の特定の FQDN に対して value と TTL を指定して UPSERT をリクエストするコマンドラインツールを書いた。元々は気楽なシェルスクリプトだったものを、練習も兼ねて Go で書き直して GitHub Release へのデプロイまでちゃんとやってみた。

[lowply/lacrosse: A simple CLI tool to update DNS records on Amazon Route 53](https://github.com/lowply/lacrosse)

### 動機

そもそもは、 [Let’s Encrypt](https://letsencrypt.org/) のドメイン認証を [lukas2511/dehydrated](https://github.com/lukas2511/dehydrated) を使って [dns-01 challenge](https://tools.ietf.org/html/draft-ietf-acme-acme-01#section-7.5) で実行したくて、それ用の hook スクリプト内で手軽に `_acme-challenge.example.com` への `TXT` レコードを設定したいというのがきっかけだった。これを使うと [hook.sh](https://github.com/lukas2511/dehydrated/blob/master/docs/examples/hook.sh) の `deploy_challenge` 部分を下記のように書ける。

```bash
deploy_challenge() {
    local DOMAIN="${1}" TOKEN_FILENAME="${2}" TOKEN_VALUE="${3}"
    lacrosse _acme-challenge.${DOMAIN} TXT ${TOKEN_VALUE} 300 default
}
```

で、これが個人的にすごく便利で気に入っていたので、 思いついて Go で書き直してみることにした。パッケージの依存関係については [Masterminds/glide](https://github.com/Masterminds/glide)、クロスコンパイルには [mitchellh/gox](https://github.com/mitchellh/gox)、CI には [Travis CI](https://travis-ci.org/lowply/lacrosse/)、デプロイはタグ打って push すると Travis が ビルドしてバイナリを [GitHub Release](https://github.com/lowply/lacrosse/releases) に上げてくれる、という感じでシンプルに、あまり複雑なライブラリとかは使わないようにした。

一番苦労したのはテストで、Route 53 へのリクエストに対するレスポンスをエミュレートするモックを作るのに手間取った。

### route53ifaceを使ってテストを書く

[aws/aws-sdk-go](https://github.com/aws/aws-sdk-go) にはスタブのために用意されたインターフェイス [route53iface](https://docs.aws.amazon.com/sdk-for-go/api/service/route53/route53iface/) がある。

> The stub package, route53iface, can be used to provide alternative implementations of service clients, such as mocking the client for testing.

これを使うと、例えば Route 53 をこういう構造体で表現して使った場合

```go
type Route53 struct {
    Client route53iface.Route53API
}

r := &Route53{
    Client: route53.New(sess),
}
```

テスト側は `Client` のモックを用意すればいいので

```go
type mockRoute53Client struct {
    route53iface.Route53API
}

r := &Route53{
    Client: &mockRoute53Client{},
}
```

という感じで書く。そしてこの `mockRoute53Client` にメソッドを生やして実際の挙動を上書きしていくイメージ。

例えば `ChangeResourceRecordSets` という関数のモックを作りたい場合、まず [route53iface](https://docs.aws.amazon.com/sdk-for-go/api/service/route53/route53iface/) を見て引数と戻り値をチェック。

```go
ChangeResourceRecordSets(*route53.ChangeResourceRecordSetsInput) (*route53.ChangeResourceRecordSetsOutput, error)
```

`*route53.ChangeResourceRecordSetsOutput` を内部で作って返してあげれば良いということがわかる。

```go
type mockRoute53Client struct {
    route53iface.Route53API
}

...snip...

func ptr(s string) *string {
    return &s
}

func (m *mockRoute53Client) ChangeResourceRecordSets(*route53.ChangeResourceRecordSetsInput) (*route53.ChangeResourceRecordSetsOutput, error) {
    time := time.Now().UTC()
    r := &route53.ChangeResourceRecordSetsOutput{
        ChangeInfo: &route53.ChangeInfo{
            Comment:     ptr("This is a test"),
            Id:          ptr("XXXXXXXXXX"),
            Status:      ptr("INSYNC"),
            SubmittedAt: &time,
        },
    }
    return r, nil
}
```

あとは普通にテストコードを書く。下記の例では、`route53.go` の `RequestChange()` 内で、モック側の `ChangeResourceRecordSets()` が呼ばれ、実際に AWS の API にアクセスしないでもテストを行える。

```
func TestRoute53_RequestChange(t *testing.T) {
    r := &Route53{
        Client: &mockRoute53Client{},
		}
    err := r.RequestChange()
    if err != nil {
        t.Errorf("Error: ", err)
    }
}
```


### まとめ

Goは良い。
