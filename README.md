# Cloud-Native-HW4
This is assignment 4 for Cloud-Native

---

## Docker 指令打包
使用 `docker build` 打包應用程式
```
docker build -t cloud-native-hw4 .
```
這行指令會將當前目錄（有 `pom.xml` 和原始碼）打包成名為 cloud-native-hw4 的 Container Image。

## Docker 指令運行你Container Image
1. 使用剛剛 `docker build` 出來的本地映像檔：
```
docker run --rm cloud-native-hw4
```
2.  直接從 Docker Hub 運行已推送的 Image
```
# 先從 Docker Hub 拉取
docker pull juntinglin/2025cloud:v1.0.0

# 執行 container
docker run --rm juntinglin/2025cloud:v1.0.0
```

+ `--rm` 表示執行完自動移除 container。
+ 預設會執行 Main.java 中的 main() 方法，並在終端機印出訊息。

## 自動化邏輯
### 1. Pull Request 階段：建置測試 (CI-test)
+ 觸發時機
  + 當別的分支對 `master` 發起 Pull Request 時
+ 執行流程
  1. GitHub 讀取 [`.github/workflows/pr-build.yml`](.github/workflows/pr-build.yml)
  2. 透過 `actions/checkout@v4` 把程式碼拉下來
  3. 執行 `docker build --file Dockerfile --tag test:latest .`，只做建置驗證，不推送
+ Tag 選擇邏輯
  + 使用固定的 `test:latest`，僅用來檢查 Dockerfile 是否正確、能否成功 build
+ 結果
  + 如果 build 成功，PR 右側會綠燈，[hw-p](https://github.com/JunTingLin/Cloud-Native-HW4/pull/2)
  + 如果 build 失敗（例如故意錯誤指令），PR 右側會紅叉，提示有錯誤，[hw-f](https://github.com/JunTingLin/Cloud-Native-HW4/pull/4)

### 2. 發佈階段：正式建置與推送 (Release)

+ 觸發時機
    + 在任意分支上 push 符合 `v*` 模式的 Git 標籤（例如 `v1.0.0`）。
+ 執行流程
  1. GitHub 讀取 [`.github/workflows/release.yml`](.github/workflows/release.yml)
  2. 透過 `actions/checkout@v4` 把程式碼拉下來
  3. 使用 `docker/login-action@v2` 登入 Docker Hub（帳號寫死 `juntinglin`、密碼由 `${{ secrets.DOCKERHUB_TOKEN }}` 提供）
  4. 透過 `docker/build-push-action@v4` 做 build 並 push
     + `context: .`,`file: Dockerfile`
     + tags: `juntinglin/2025cloud:${{ github.ref_name }}`
+ Tag 選擇邏輯
    + 直接採用 Git Tag 名稱 `${{ github.ref_name }}`（如 `v1.0.0`），確保版本對應一致。

+ 結果
    + 成功後，可在 [Docker Hub 2025cloud Tags](https://hub.docker.com/r/juntinglin/2025cloud/tags) 頁面 看到對應的 image tag
    + 在 Actions Log 裡也能看到 `juntinglin/2025cloud:v1.0.0` 以及 push 的詳細輸出。

#### 簡易流程示意
```
Pull Request ──► pr-build.yml ──► docker build test:latest ──► (不推送)

Tag 推送 vX.Y.Z ─► release.yml ─► docker build & push juntinglin/2025cloud:vX.Y.Z
```