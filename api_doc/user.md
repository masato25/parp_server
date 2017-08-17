# User (使用者)

### 使用者上報停車位置
POST `/api/v1/user_report_parking`
* custom_name: 表示建立停車位時設定在停車位上的編號, 通常可能是一個數字或是代碼, 使用者透過辨識此代碼上報停車位置
* 需要在header 帶入使用者登入session ex. `{"authorization", "parpuser1 sesionaaa11112233"}`

post example:
```
{"custom_name": "S8np0750"}
```

example response:
```
{"msg": "ok"}
```


### 使用者付款完成通知
GET `/api/v1/pay_parking_at/:id`

* 使用者會在websocket 收到需要付款的資訊. 這邊fordemo情境所以簡單的就用一個url get 帶入id的方式跟後端說完成付款即可


## websocket

### 一般登入

會回覆類似以下的資訊:
```
{"level":"info","msg":"joined to: {\"topic\":\"customer:8\",\"ref\":1,\"payload\":{\"status\":\"ok\",\"response\":{\"message\":\"hello: 8\"}},\"event\":\"phx_reply\"}","time":"2017-08-17T12:45:44+08:00"}
{"level":"info","msg":"connection created","time":"2017-08-17T12:45:44+08:00"}
```

如果websocket join前上次有未付款完成的紀錄會顯示出來:
```
{"level":"info","msg":"joined to: {\"topic\":\"customer:8\",\"ref\":1,\"payload\":{\"status\":\"ok\",\"response\":{\"price_pay_info\":{\"price\":79,\"id\":388,\"avatar_id\":39},\"message\":\"hello: 8\",\"avatar\":{\"sensor_id\":\"6C:5C:14:56:69:39\",\"name\":\"S8np0750\",\"custom_name\":null,\"coordinate\":\"25.0379561,121.5687641\"}}},\"event\":\"phx_reply\"}","time":"2017-08-17T12:48:21+08:00"}
```

如果是websocket連線狀況下, 停車場完成計費動作websocket會收到:
```
{"level":"info","msg":"recv: {\"topic\":\"customer:8\",\"ref\":null,\"payload\":{\"price_pay_info\":{\"price\":29,\"id\":389,\"avatar_id\":39},\"avatar\":{\"sensor_id\":\"6C:5C:14:56:69:39\",\"name\":\"S8np0750\",\"custom_name\":null,\"coordinate\":\"25.0379561,121.5687641\"}},\"event\":\"payment_request\"}","time":"2017-08-17T12:50:44+08:00"}
```
