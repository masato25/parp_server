import React from 'react';
import { Layout, Breadcrumb, DatePicker, Table, Icon, Row, Col, Card, Tag, Tooltip, Menu} from 'antd';
const { Header, Content, Footer } = Layout;

class PageHeader extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      selectedkey: '2',
      theme: 'dark',
      logined: false,
    }
    this.setkey = this.setkey.bind(this)
    this.getCookie = this.getCookie.bind(this)
  }
  componentWillMount(){
    if (window.location.href.includes("daily")) {
      this.setState({selectedkey: '3'})
    } else {
      this.setState({selectedkey: '2'})
    }
    const logined = this.getCookie()
    if (logined != '') {
      this.setState({
        logined: true
      })
    }else{
      this.setState({
        logined: false
      })
    }
  }
  setkey(e){
    if (e.target.value == '1') {
      this.setState({selectedkey: '2'})
    } else {
      this.setState({selectedkey: e.target.value})
    }
  }
  getCookie(){
    let a = `; ${document.cookie}`.match(`;\\s*extoken=([^;]+)`);
    return a ? a[1] : '';
  }
  render () {
    return (
      <Header>
        <div className="logo" />
        {this.state.logined &&
          <Menu
            theme={this.state.theme}
            mode="horizontal"
            selectedKeys={[this.state.selectedkey]}
            onChange={this.setkey}
            style={{ lineHeight: '64px' }}
          >
            <Menu.Item key="1">
              <span style={{position: "relative", top: "10px", right: "10px"}}>
                <a href="/">PARP</a>
              </span>
            </Menu.Item>
            <Menu.Item key="2">
              <a href="/car">影像辨識試驗區</a>
            </Menu.Item>
            <Menu.Item key="3">
              <a href="/file/ReadApp.pdf">App使用說明</a>
            </Menu.Item>
            <Menu.Item key="4">
              <a href="/file/HelloPARP_release1.apk">
                download:
                <img style={{height: "30px",  position: "relative", top: "10px"}} src="/file/android-market-store.png"></img>
              </a>
            </Menu.Item>
          </Menu>
        }
      </Header>
    )
  }
}

module.exports = {PageHeader}
