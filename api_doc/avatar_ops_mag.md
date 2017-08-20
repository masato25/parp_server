# 停車場管理api

### 拿取停車但是沒有駐記停車車牌的停車位
api request sample

`curl http://localhost:4000/api/v1/pending_parking_check`

sample response
```
{
  "avatars": [
    {
      "user_id": null,
      "sensor_id": "20:C3:8F:88:33:22",
      "reservation_at": null,
      "parking_status": "parking",
      "name": "RECAM4CHJX03451",
      "custom_name": null,
      "coordinate": "25.041581,121.5804801",
      "at_historys": [
        {
          "user_id": null,
          "status": "parking",
          "start_at": "2017-08-20T16:38:05.000000",
          "price": null,
          "parking_license": null,
          "paid_status": null,
          "id": 392,
          "end_at": null
        }
      ]
    }
  ]
}
```
### 登記停車資訊
api request sample

`curl -H 'Content-Type: application/json' -XPUT http://localhost:4000/api//v1/set_parking_license -d '{"parking_id": 392, "parking_license": "PARP-8888"}'`

* parking_id 表示停車紀錄(at_historys) 的id
* parking_license 表示要登記的車牌
