# Avatar Parking (車位停車)

## 備註:


### 將停車位設定為開始停車狀況（開始計費）
POST `/api/avatar_start_parking`

curl example:
`curl -X POST 'http://localhost:4000/api/avatar_start_parking' -d 'sensor_id=10:C6:FC:EE:DE:9C'`

header: application/json

post example:
```
{
  "sensor_id": "10:C6:FC:EE:DE:9C"
}
```

response example:
```
{"message":"sensor_id: 10:C6:FC:EE:DE:9C insert one parking record successed"}
```

### 將停車位設定為車子駛離狀況（停止計費）
POST `/api/avatars`

curl example:
`curl -X POST 'http://localhost:4000/api/avatar_leave_parking' -d 'sensor_id=10:C6:FC:EE:DE:9C'`

header: application/json

post example:
```
{
  "sensor_id": "10:C6:FC:EE:DE:9C"
}
```

response example:
```
{"msg":"ok"}
```
