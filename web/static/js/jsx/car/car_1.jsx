import ReactDOM from 'react-dom';
import React from 'react';
import ifetch from '../common/fetch.js'
import { PageHeader } from '../common/page_header.jsx'
import _ from 'lodash';
import { Layout, Breadcrumb, Button, DatePicker, Table, Icon, Row, Col, Card, Tag, Tooltip, Checkbox, Switch, Input } from 'antd';
const { Header, Content, Footer } = Layout;
import moment from 'moment';
require("./css/car.scss");
const Search = Input.Search;

const columns = [{
  title: 'plate',
  dataIndex: 'plate',
  key: 'plate',
},{
  title: 'img',
  dataIndex: 'img',
  render: (text, record) => (
    <img src={'data:image/png;base64, ' + record.img}/>
  )
},{
 title: 'detected_data',
 dataIndex: 'detected_data',
 key: 'detected_data',
 width: 600,
 render: (text, record) => (
   <code class="prettyprint">{record.detected_data}</code>
 )
}];

class CarPage1 extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      tdata: [],
      loading: true,
    }
    this.fetchData = this.fetchData.bind(this)
  }
  componentWillMount(){
    this.fetchData()
  }
  fetchData(){
    const self = this
    self.setState((p, n) => {
      return {
        loading: true,
      }
    })
    ifetch(`/api/v1/car`, 'GET')
      .then(function(stories) {
        self.setState((p, n) => {
          return {
            tdata: stories.data,
            loading: false,
          }
        })
      })
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
                  <Breadcrumb.Item><a href="">影像辨識區</a></Breadcrumb.Item>
                </Breadcrumb>
              </Col>
              <Col span={24}>
                <Card title="sensors" loading={this.state.loading}>
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
ReactDOM.render(<CarPage1 />, element);
