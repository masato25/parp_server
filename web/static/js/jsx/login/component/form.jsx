import ReactDOM from 'react-dom';
import React from 'react';
import { Form, Icon, Input, Button, Alert } from 'antd';
const FormItem = Form.Item;
import ifetch from '../../common/fetch.js'

function hasErrors(fieldsError) {
  return Object.keys(fieldsError).some(field => fieldsError[field]);
}

class HorizontalLoginForm extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      name: "",
      password: "",
      message: "",
    }
    this.setName = this.setName.bind(this);
    this.setPasswd = this.setPasswd.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }
  componentDidMount() {
    // To disabled submit button at the beginning.
  }
  handleSubmit(e){
    e.preventDefault();
    this.setState({
      message: ""
    })
    this.loginApi()
  }
  delete_cookie(name){
    document.cookie = name + '=;expires=Thu, 01 Jan 1970 00:00:01 GMT;';
  }
  loginApi(){
    const self = this
    ifetch(`/api/v1/login?passwd=${this.state.password}`, 'GET')
      .then(function(stories) {
          if(stories.data.error){
            self.setState({
              message: stories.data.error.message,
            })
          }else{
            self.delete_cookie("extoken");
            document.cookie = "extoken=" + stories.data.extoken;
            window.location.replace("/");
          }
          return stories
      })
      .catch(function(){
        self.setState({
          message: "connection timeout, please try again."
        })
      })
  }
  setName(e){
    const self = this;
    e.preventDefault();
    self.setState({
      name: e.target.value
    })
  }
  setPasswd(e){
    const self = this;
    e.preventDefault();
    self.setState({
      password: e.target.value
    })
  }
  render() {
    let alert = null
    if(this.state.message != ""){
      alert = <Alert message={this.state.message} type="error" />
    }
    return (
      <div>
        {alert}
        <Form inline onSubmit={this.handleSubmit}>
          <FormItem>
            <Input addonBefore={<Icon type="lock" />} type="password" placeholder="Password" onChange={this.setPasswd} />
          </FormItem>
          <FormItem>
            <Button
              type="primary"
              htmlType="submit"
            >
              Log in
            </Button>
          </FormItem>
        </Form>
      </div>
    );
  }
}

module.exports = {HorizontalLoginForm}
