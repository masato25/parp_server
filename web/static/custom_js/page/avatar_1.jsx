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
}];

class Avatar1 extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      tdata: [],
      name: '',
      coordinate: '',
    }
    this.onEndChange = this.onEndChange.bind(this)
    this.fetchData = this.fetchData.bind(this)
  }
  componentWillMount(){
    this.fetchData()
  }
  fetchData(){
    const patt = document.URL.match(/\/(\d+)$/)
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
  onEndChange(){}
  render () {
    return (
      <Layout className="layout">
        <PageHeader />
        <Content style={{ padding: '0 50px' }}>
          <div style={{ background: '#fff', padding: 24, minHeight: 280 }}>
            <Row>
              <Card title="停車紀錄">
                <Table dataSource={this.state.tdata} columns={columns} />
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
