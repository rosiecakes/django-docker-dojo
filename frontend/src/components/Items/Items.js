import './Items.css'

import React from 'react';
import { Component } from 'react';


class Items extends Component {

  constructor(props) {
    super(props);
    this.state = {
      error: null,
      isLoaded: false,
      isPolling: true,
      pollSuccess: false,
      items: []
    };
  }

  // When this component mounts, it automatically polls for new information
  async componentDidMount() {
    // Set a schedule to use within the loop to get new data
    const fetchSchedule = (milliseconds) => new Promise((r) => setTimeout(r, milliseconds));
    
    // We'll need to actually set a switch for this if we ever want it to pause
    while (this.state.isPolling) {

      fetch("http://localhost:8000/api/items/")
      .then(res => res.json())
      .then(
        (itemFetchResponse) => {
          this.setState({
            pollSuccess: true,
            items: itemFetchResponse
          });
          console.log(this.state.items)
        },
        // Handle errors here instead of a catch() block so that we don't
        // swallow exceptions from actual bugs in components.
        (error) => {
          this.setState({
            isLoaded: true,
            error
          });
        }
      )
      await fetchSchedule(3000);
    }
  }

   render() {
    const { error, isPolling, items } = this.state;
    if (error) {
      return <div>Error: {error.message}</div>;
    } else if (!isPolling) {
      return <div>Loading...</div>;
    } else {

        return(
            <div className='Items Items-container'>
              <table className="Items-table">
                 <thead>
                    <tr>
                      <th>Item name</th>
                      <th>Item price</th>
                    </tr>
                  </thead>

                  <tbody>
                    {items.map((item) => (
                        <tr key={item.id}>
                          <td>{ item.name }</td>
                          <td>£{ item.price }</td>
                        </tr>
                    ))}
                  </tbody>

                </table>
            </div>
        )
    }
  }
}

export default Items