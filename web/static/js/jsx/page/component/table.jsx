import React from 'react';
import { Table, Icon } from 'antd';
import {ifetch} from '../../common/fetch.js';
const columns = [{
    title: 'Name',
    dataIndex: 'name',
    key: 'name',
    render: text => <a href="#">{text}</a>,
  }, {
    title: 'Age',
    dataIndex: 'age',
    key: 'age',
  }, {
    title: 'sensor_id',
    dataIndex: 'sensor_id',
    key: 'sensor_id',
  }, {
    title: 'Action',
    key: 'action',
    render: (text, record) => (
      <span>
        <a href="#">Action 一 {record.name}</a>
        <span className="ant-divider" />
        <a href="#">Delete</a>
        <span className="ant-divider" />
        <a href="#" className="ant-dropdown-link">
          More actions <Icon type="down" />
        </a>
      </span>
    ),
}];

const data = [{
  key: '1',
  name: 'John Brown',
  age: 32,
  sensor_id: 'New York No. 1 Lake Park',
}, {
  key: '2',
  name: 'Jim Green',
  age: 42,
  sensor_id: 'London No. 1 Lake Park',
}, {
  key: '3',
  name: 'Joe Black',
  age: 32,
  sensor_id: 'Sidney No. 1 Lake Park',
}];

var FalconTable = React.createClass({
  render() {
    return (
      <div>
        <Table columns={columns} dataSource={data} />
      </div>
    )
  }
})

module.exports = {FalconTable}
