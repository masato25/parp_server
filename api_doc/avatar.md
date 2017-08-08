# Avatar (車位)

### 取得avatar list
GET `/api/avatars`

```
{
  "data": [
    {
      "user_id": null,
      "reservation_at": null,
      "price_set": " / 3600 * 20",
      "parking_status": "available",
      "name": "Drive+",
      "latest_report": "2017-07-18 09:02:11",
      "inserted_at": "2017-07-18 09:02:11",
      "id": 22,
      "custom_name": null,
      "coordinate": "25.0405821,121.5686972",
      "bluetooth_type": 1,
      "bluetooth_status": 10,
      "address": "10:C6:FC:EE:DE:9C"
    },
    {
      "user_id": null,
      "reservation_at": null,
      "price_set": " / 3600 * 20",
      "parking_status": "available",
      "name": "S8np0750",
      "latest_report": "2017-07-18 09:21:06",
      "inserted_at": "2017-07-18 09:21:06",
      "id": 39,
      "custom_name": null,
      "coordinate": "25.0379561,121.5687641",
      "bluetooth_type": 1,
      "bluetooth_status": 10,
      "address": "6C:5C:14:56:69:39"
    }]
}
```

### 新增一個車位
POST `/api/avatars`

header: application/json

post example:
```
{
  "name": "sensor-a",
  "custom_name": "測試A",
  "address": "bluetooth address",
  "parking_status": "available",
  "coordinate": "25.0379561,121.5687641"
  "price_set": " / 3600 * 20"
}
```

### 更新一個車位
PUT `/api/avatars/:id`

header: application/json

post example:
```
{
  "name": "sensor-a",
  "custom_name": "測試A",
  "address": "bluetooth address",
  "parking_status": "available",
  "coordinate": "27.0379561,125.5687641"
  "price_set": " / 3600 * 20"
}
```

### 刪除一個車位
DELETE `/api/avatars/:id`
