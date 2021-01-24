# Seq with GELF input + 定時rsync備份
這是從屬於 [jim60105/docker-ReverseProxy](https://github.com/jim60105/docker-ReverseProxy) 的 Seq 方案，必須在上述伺服器運行正常後再做\
用ssh rsync做定時備份功能，參考[這裡](https://blog.maki0419.com/2020/08/docker-opencart.html#rsync-server%E8%A8%AD%E5%AE%9A%E5%92%8C%E5%82%99%E4%BB%BD%E9%82%84%E5%8E%9F)做設定

## 架構
WWW\
│\
├ Reverse Proxy (nginx Server) (SSL證書申請、Renew)\
│ ├ Seq (Log Server)\
│ │ └ Jobber (Cron) (定時備份Docker volume，備份完送至rsync server) \
└ Seq-input-gelf (Input Server)

## 部屬
1. 請參考`.env_sample`建立`.env`
	* LETSENCRYPT_EMAIL=你的email
	* HOST=你的Seq UI網址
	* BACKUP_FOLDER=備份路徑
	* BACKUP_RSYNC_URI=rsync server路徑
	* BACKUP_RSYNC_PORT=rsync server ssh port
2. rsync ssh passwd 明碼放在 `/root/ssh.pas`，chown root，chmod 600
5. `docker-compose up -d`
6. 都正常後修改 `.env` 中的 `LETSENCRYPT_TEST`為`false`再重新up，此設定為SSL測試證書

## LICENSE
Seq使用遵照 [Seq End-User License Agreement](https://datalust.co/doc/eula-current.pdf)\
說明請參考 [Seq Pricing](https://datalust.co/pricing)