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
使用 `docker run` 執行 Container
```
docker run --rm cloud-native-hw4
```
+ `--rm` 表示執行完自動移除 container。
+ 預設會執行 Main.java 中的 main() 方法，並在終端機印出訊息。

