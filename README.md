# Seq with GELF input + 定時rsync備份
>這是從屬於 [jim60105/docker-ReverseProxy](https://github.com/jim60105/docker-ReverseProxy) 的 Seq 方案，必須在上述伺服器運行正常後再做

Seq其實是有內建備份機制([官方文件](https://docs.datalust.co/docs/backup-and-restore))，但這功能有幾個原因讓我不想用它
1. 持有master-key才能還原，每次全新安裝這個就會不一樣
2. 還原時要把備份檔docker cp或是bind進container使用
3. 還原時要把seq service停止，但又不能停掉seq container，因為需要使用seq的cli做還原。所以不能直接使用seq的image，要換掉它的Entrypoint，否則container會和seq service一起停掉

說的直接點，這是個**還原難度有點高**(:confused:?)的備份機制\
既然這裡已經用了docker做部屬，那最簡單的還是直接備份docker volume，還原整個直接倒回去就行\
另外我用了ssh rsync做異地上傳功能，參考[這裡](https://blog.maki0419.com/2020/08/docker-opencart.html#rsync-server%E8%A8%AD%E5%AE%9A%E5%92%8C%E5%82%99%E4%BB%BD%E9%82%84%E5%8E%9F)做設定

## 架構
WWW\
│\
├ Reverse Proxy (nginx Server) (SSL證書申請、Renew)\
│ ├ Seq (Log Server)\
│ │ └ Jobber (Cron) (定時備份Docker volume，備份完送至rsync server) \
└ Seq-input-gelf (GELF input bridge Server)

## 部屬
1. 請參考`.env_sample`建立`.env`
	* LETSENCRYPT_EMAIL=你的email
	* HOST=你的Seq UI網址
	* BACKUP_FOLDER=備份路徑，**必須使用絕對路徑**
	* BACKUP_RSYNC_URI=rsync server路徑
	* BACKUP_RSYNC_PORT=rsync server ssh port
2. rsync ssh passwd 明碼放在 `/root/ssh.pas`，chown root，chmod 600
5. `docker-compose up -d`
6. 都正常後修改 `.env` 中的 `LETSENCRYPT_TEST`為`false`再重新up，此設定為SSL測試證書

## LICENSE
Seq使用遵照 [Seq End-User License Agreement](https://datalust.co/doc/eula-current.pdf)，解釋請參考 [Seq Pricing](https://datalust.co/pricing)\
其餘部份(docker-compose file & jobber)為MIT LICENSE
