import React from 'react';
import { Layout, Breadcrumb, DatePicker, Table, Icon, Row, Col, Card, Tag, Tooltip, Menu} from 'antd';
const { Header, Content, Footer } = Layout;

class PageHeader extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      selectedkey: '2',
      theme: 'dark',
    }
    this.setkey = this.setkey.bind(this)
  }
  componentWillMount(){
    if (window.location.href.includes("daily")) {
      this.setState({selectedkey: '3'})
    } else {
      this.setState({selectedkey: '2'})
    }
  }
  setkey(e){
    console.log(e)
    if (e.target.value == '1') {
      this.setState({selectedkey: '2'})
    } else {
      this.setState({selectedkey: e.target.value})
    }
  }
  render () {
    return (
      <Header>
        <div className="logo" />
        <Menu
          theme={this.state.theme}
          mode="horizontal"
          selectedKeys={[this.state.selectedkey]}
          onChange={this.setkey}
          style={{ lineHeight: '64px' }}
        >
          <Menu.Item key="1">
            <span style={{position: "relative", top: "10px", right: "10px"}}>
              PARP
            </span>
          </Menu.Item>
          <Menu.Item key="2"><a href="/">Index</a></Menu.Item>
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
      </Header>
    )
  }
}

module.exports = {PageHeader}
