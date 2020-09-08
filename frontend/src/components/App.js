import React, { Component } from 'react';
import logo from '../img/logo.svg';
import '../css/App.css';

import Items from '../components/Items/Items'


class App extends Component {
  render() {
    return (
      <div className="App">
        <header className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
        </header>
        <Items/>
      </div>
    );
  }
}

export default App;
