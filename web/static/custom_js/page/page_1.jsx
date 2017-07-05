import ReactDOM from 'react-dom';
import React from 'react';
import ifetch from '../common/fetch.js'
import { PageHeader } from '../common/page_header.jsx'
import _ from 'lodash';
import { Layout, Breadcrumb, DatePicker, Table, Icon, Row, Col, Card, Tag, Tooltip, Checkbox, Switch } from 'antd';
const { Header, Content, Footer } = Layout;
import moment from 'moment';
require("./css/falcon.scss");

const columns = [{
  title: 'Name',
  dataIndex: 'name',
  key: 'name',
  render: (text, record) => (
    <a href={`/avatar/${record.id}`}>{text}</a>
  )
}, {
  title: 'Address',
  dataIndex: 'address',
  key: 'address',
}, {
  title: 'Bluetooth Status',
  dataIndex: 'bluetooth_status',
  key: 'bluetooth_status',
}, {
  title: 'latest report',
  dataIndex: 'latest_report',
  key: 'latest_report',
}, {
  title: 'Insert at',
  dataIndex: 'inserted_at',
  key: 'inserted_at',
}];

class MyPage1 extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      tdata: [],
    }
    this.onEndChange = this.onEndChange.bind(this)
    this.fetchData = this.fetchData.bind(this)
  }
  componentWillMount(){
    this.fetchData()
  }
  fetchData(){
    const self = this
    ifetch(`/api/avatars`, 'GET')
      .then(function(stories) {
        self.setState((p, n) => {
          return {
            tdata: stories.data,
          }
        })
      })
  }
  onEndChange(){}
  render () {
    return (
      <Layout className="layout">
        <PageHeader />
        <Content style={{ padding: '0 50px' }}>

          <div style={{ background: '#fff', padding: 24, minHeight: 280 }}>
            <Row>
              <Card title="sensors">
                <Table dataSource={this.state.tdata} columns={columns} />
              </Card>
            </Row>
          </div>
        </Content>
        <Footer style={{ textAlign: 'center' }}>
          PARP ©2017
        </Footer>
      </Layout>
    );
  }
};

var element = document.getElementById('app');
ReactDOM.render(<MyPage1 />, element);
