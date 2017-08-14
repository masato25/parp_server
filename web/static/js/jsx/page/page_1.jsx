import ReactDOM from 'react-dom';
import React from 'react';
import ifetch from '../common/fetch.js'
import { PageHeader } from '../common/page_header.jsx'
import _ from 'lodash';
import { Layout, Breadcrumb, Button, DatePicker, Table, Icon, Row, Col, Card, Tag, Tooltip, Checkbox, Switch, Input } from 'antd';
const { Header, Content, Footer } = Layout;
import moment from 'moment';
require("./css/falcon.scss");
const Search = Input.Search;

const columns = [{
  title: 'Name',
  dataIndex: 'name',
  key: 'name',
  render: (text, record) => (
    <a href={`/avatar/${record.id}`}>{text}</a>
  )
},{
  title: 'sensor_id',
  dataIndex: 'sensor_id',
  key: 'sensor_id',
},{
 title: 'status',
 dataIndex: 'parking_status',
 key: 'parking_status',
},{
  title: 'latest report',
  dataIndex: 'latest_report',
  key: 'latest_report',
},{
  title: 'Insert at',
  dataIndex: 'inserted_at',
  key: 'inserted_at',
}];

class MyPage1 extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      tdata: [],
      tdataTmp: [],
      fordemo: false,
    }
    this.onSearch = this.onSearch.bind(this)
    this.fetchData = this.fetchData.bind(this)
    this.filterDemo = this.filterDemo.bind(this)
    this.forDemoAct = this.forDemoAct.bind(this)
  }
  componentWillMount(){
    this.fetchData()
  }
  fetchData(){
    const self = this
    ifetch(`/api/avatars`, 'GET')
      .then(function(stories) {
        let newDstate = []
        if (self.state.fordemo) {
          newDstate = self.filterDemo(stories.data)
        } else {
          newDstate = {
            tdata: stories.data,
            tdataTmp: stories.data,
          }
        }
        self.setMap(newDstate)
        self.setState((p, n) => {
          return newDstate
        })
      })
  }
  setMap(data){
    const d = data.tdataTmp
    if(d.length == 0){
      return
    }
    const dt = _.chain(d).map((b) => {
      if(b.parking_status == "available"){
        return {
          name: b.name,
          coordinate: b.coordinate,
          color: "green"
        }
      }else{
        return {
          name: b.name,
          coordinate: b.coordinate,
          color: "red"
        }
      }
    }).sortedUniqBy((b) => { return b.coordinate}).take(50).value()
    window.init_map(dt)
  }
  onSearch(val){
    const newT = _.filter(this.state.tdataTmp, (v) => {
      if (v.name.indexOf(val) !== -1) {
        return true
      }else{
        return false
      }
    })
    this.setState((p, n) => {
      return {
        tdata: newT
      }
    })
  }
  filterDemo(data){
    const newData = _.chain(data)
    .filter((b) => {
      return b.name.indexOf("PARP") >= 0
    }).value()
    return {
      tdata: newData,
      tdataTmp: newData,
    }
  }
  forDemoAct(){
    const self = this
    self.setState((p, n) => {
      return {
        fordemo: true
      }
    })
    setInterval(function(resolve){
      console.log("aaa")
      self.fetchData()
      self.setState(self.filterDemo(self.state.tdata))
    }, 5000)
  }
  render () {
    return (
      <Layout className="layout">
        <PageHeader />
        <Content style={{ padding: '0 50px' }}>
          <div style={{ background: '#fff', padding: 24, minHeight: 280 }}>
            <Row>
              <Col span={24}>
                <Breadcrumb>
                  <Breadcrumb.Item>Home</Breadcrumb.Item>
                  <Breadcrumb.Item><a href="">停車一覽表</a></Breadcrumb.Item>
                  <Breadcrumb.Item>
                    <Button type="primary" onClick={this.forDemoAct} loading={this.state.fordemo}>For Demo</Button>
                  </Breadcrumb.Item>
                </Breadcrumb>
              </Col>
              <Col span={12}>
                <Card title="Map">
                  <div style={{overflow: 'hidden', height: '600px', width: '100%'}}>
                    <div id='gmap_canvas' style={{height: '600px', width: '100%'}}></div>
                  </div>
                </Card>
              </Col>
              <Col span={12}>
                <Card title="sensors">
                  <Search
                  placeholder="input search text"
                  style={{ width: 200 }}
                  onSearch={(value) => this.onSearch(value)}
                  />
                  <Table dataSource={this.state.tdata} columns={columns} />
                </Card>
              </Col>
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
