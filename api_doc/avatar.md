# Avatar (車位)

## 備註:
* user_id 表示預約這個車位的使用者
* reservation_at 預約時間
* price_set 計算停車時間公式
* parking_status 停車位狀態 -> ["parking", "available"]
* name & custom_name: 依舊的情狀表示的是藍芽的名字 還有自定義的名字. 可以按照需求轉變使用
* sensor_id: sensor_id這邊表一個唯一的sensor的代碼. 可以依照需求轉變使用. 目前的作法都是用這個id去辨認一個sensor的狀態. 這個sensor基本上預設展示情境是綁定一個車位的.
* coordinate 經緯度, 用","隔開
* 其他訊息可以都不用填沒關係, 有些是之前使用藍芽模組產生的暫存狀態儲存

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
      "sensor_id": "10:C6:FC:EE:DE:9C"
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
      "sensor_id": "6C:5C:14:56:69:39"
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
  "sensor_id": "bluetooth sensor_id",
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
  "sensor_id": "bluetooth sensor_id",
  "parking_status": "available",
  "coordinate": "27.0379561,125.5687641"
  "price_set": " / 3600 * 20"
}
```

### 刪除一個車位
DELETE `/api/avatars/:id`
