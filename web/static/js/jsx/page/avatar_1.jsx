import ReactDOM from 'react-dom';
import React from 'react';
import ifetch from '../common/fetch.js'
import { PageHeader } from '../common/page_header.jsx'
import _ from 'lodash';
import { Layout, Breadcrumb, Modal, DatePicker, Table, Icon, Row, Col, Card, Tag, Tooltip, Checkbox, Switch } from 'antd';
const { Header, Content, Footer } = Layout;
import moment from 'moment';
require("./css/falcon.scss");


class Avatar1 extends React.Component {
  constructor(props) {
    const columns = [{
      title: '狀態',
      dataIndex: 'status',
      key: 'status',
    },
    {
      title: '開始',
      dataIndex: 'start_at',
      key: 'start_at',
    }, {
      title: '離開',
      dataIndex: 'end_at',
      key: 'end_at',
    },{
      title: 'car_id',
      dataIndex: 'car_id',
      key: 'car_id',
      render: (text, record) => (
        <a href={"#"} onClick={this.showModal}>{text}</a>
      )
    }];

    super(props)
    this.state = {
      tdata: [],
      name: '',
      coordinate: '',
      visible: false,
      columns: columns,
      carInfo: {},
    }
    this.onEndChange = this.onEndChange.bind(this)
    this.fetchData = this.fetchData.bind(this)
    this.showModal = this.showModal.bind(this)
    this.handleCancel = this.handleCancel.bind(this)
    this.handleOk = this.handleOk.bind(this)
    this.genBaseEmb = this.genBaseEmb.bind(this)
  }
  componentWillMount(){
    this.fetchData()
  }
  fetchData(){
    const patt = document.URL.match(/\/(\d+).*?$/)
    let avatarId = 0;
    if(patt){
      avatarId = patt[1]
    }
    const self = this
    ifetch(`/api/avatar_get_at/${avatarId}`, 'GET')
      .then(function(stories) {
        self.setState((p, n) => {
          return {
            tdata: stories.data,
          }
        })
      })
    ifetch(`/api/avatars/${avatarId}`, 'GET')
      .then(function(stories) {
        window.init_map(stories.data.name, stories.data.coordinate)
        self.setState((p, n) => {
          return {
            name: stories.data.name,
            coordinate: stories.data.coordinate,
          }
        })
      })
  }
  showModal(e){
    self = this
    ifetch(`/api/car/${e.target.text}`, 'GET')
      .then(function(stories) {
        console.log(stories)
        self.setState((p, n) => {
          return {
            carInfo: stories.data,
          }
        })
      })
    this.setState({
      visible: true,
    });
  }
  handleOk(e){
    console.log(e);
    this.setState({
      carInfo: {},
      visible: false,
    });
  }
  handleCancel(e){
    console.log(e);
    this.setState({
      carInfo: {},
      visible: false,
    });
  }
  genBaseEmb(){
    return `data:image/png;base64,${this.state.carInfo.img}`
  }
  onEndChange(){}
  render () {
    return (
      <Layout className="layout">
        <PageHeader />
        <Content style={{ padding: '0 50px' }}>
          <div style={{ background: '#fff', padding: 24, minHeight: 280 }}>
            <Row>
              <Card title="停車紀錄">
                <Table dataSource={this.state.tdata} columns={this.state.columns} />
              </Card>
              <Card title="Map">
                <div style={{overflow: 'hidden', height: '440px', width: '700px'}}>
                  <div id='gmap_canvas' style={{height: '440px', width: '700px'}}></div>
                    <div>
                      <small>
                        <a href="http://embedgooglemaps.com">Click here to generate yourmap!</a>
                      </small>
                    </div>
                    <div>
                      <small>
                        <a href="https://premiumlinkgenerator.com/4shared-com">Check out the most trusted file hosts at premiumlinkgenerator.com!</a>
                      </small>
                    </div>
                </div>
              </Card>
            </Row>
          </div>
          <Modal
            title="Basic Modal"
            visible={this.state.visible}
            onOk={this.handleOk}
            onCancel={this.handleCancel}
          >
            <p>停車車籍資訊</p>
            <div>車牌: {this.state.carInfo.plate}</div>
            <img src={this.genBaseEmb()}/>

          </Modal>
        </Content>
        <Footer style={{ textAlign: 'center' }}>
          PARP ©2017
        </Footer>
      </Layout>
    );
  }
};

var element = document.getElementById('app');
ReactDOM.render(<Avatar1 />, element);
