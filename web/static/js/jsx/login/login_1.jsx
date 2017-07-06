import ReactDOM from 'react-dom';
import React from 'react';
import ifetch from '../common/fetch.js'
import _ from 'lodash';
import { Layout, Breadcrumb, DatePicker, Table, Icon, Row, Col, Card, Tag, Tooltip, Menu} from 'antd';
const { Header, Content, Footer } = Layout;
import {PageHeader} from '../common/page_header.jsx'
import {HorizontalLoginForm} from './component/form.jsx'
require("./css/login.scss");



class LoginPortal extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      status: false,
    };
  }
  render () {
    return (
      <Layout className="layout">
        <PageHeader />
        <Content style={{ padding: '0 50px'}}>
          <div style={{ padding: 24, minHeight: 280 }}>
            <Row id={"login-row2"}>
              <Col span={6}></Col>
              <Col span={12}>
                <Card title={<Tooltip placement="topLeft">帳號登入</Tooltip>}>
                  <HorizontalLoginForm />
                </Card>
              </Col>
              <Col span={6}></Col>
            </Row>
          </div>
        </Content>
        <Footer style={{ textAlign: 'center' }}>
          Owl-Dev ©2017
        </Footer>
      </Layout>
    )
  }
};

var element = document.getElementById('app');
ReactDOM.render(<LoginPortal />, element);
