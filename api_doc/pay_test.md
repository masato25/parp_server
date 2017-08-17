### 測試停車場計費

#### 自行設定一個停車位開始計費
```
curl -X POST 'http://localhost:4000/api/avatar_start_parking' -d 'sensor_id=6C:5C:14:56:69:39'
```

`參照user.md 自行上報停車位置`

#### 自行設定一個停車位完成計費
```
curl -X POST 'http://localhost:4000/api/avatar_leave_parking' -d 'sensor_id=6C:5C:14:56:69:39'
```

`websocket 收到付費資訊`

#### 完成付費callback
```
curl 'http://localhost:4000/api/v1/pay_parking_at/382'
```
