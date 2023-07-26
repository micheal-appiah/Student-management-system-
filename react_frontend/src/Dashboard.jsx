import React from 'react';
import './Dashboard.css'; // Import the CSS file for styling
import ESUGLOGO from './ESUGLOGO.jpg';

const Dashboard = () => {
  return (
    <div className="main">
      <div className="menu">
        
        <a href="">Home</a>
        <a href="">Courses</a>
        <a href="">Assignments</a>
        <a href="">Grade Book</a>
        <a href="./LoginPage">LOG OUT</a>
      </div>
      <div className="header with-image">
        <img className="logo" src= {ESUGLOGO} alt="ESUGLOGO" />
        <h1>Welcome to your Dashboard</h1>
        <p className="main-text">
    "Science can amuse and fascinate us all, but it is engineering that
    changes the world." "The engineer has been, and is, a maker of history."
    "Scientists study the world as it is; engineers create the world that has
    never been." "The way to succeed is to double your failure rate."
  </p>
  <section className="attendance">
                <div className="attendance-list">
                <h1>TIMETABLE</h1>
                <table className="table">
                    <thead>
                    <tr>
                        <th>Course ID</th>
                        <th>Course Name</th>
                        <th>Venue</th>
                        <th>Days</th>
                        <th>Start Time</th>
                        <th>End Time</th>
                        <th>Lecturer</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td>SENG 201</td>
                        <td>Calculus I</td>
                        <td>NNB 2</td>
                        <td>Wednesday</td>
                        <td>8:00AM</td>
                        <td>10:00AM</td>
                        <td>Dr Aboagye</td>
                    </tr>
                    <tr className="active">
                        <td>CPEN 202</td>
                        <td>Digital Circuit</td>
                        <td>SF-F2</td>
                        <td>Tuesday</td>
                        <td>10:00AM</td>
                        <td>12:00AM</td>
                        <td>Dr Mills</td>
                    </tr>
                    <tr>
                        <td>CPEN 203</td>
                        <td>Software Engineering</td>
                        <td>JQB</td>
                        <td>Friday</td>
                        <td>8:00AM</td>
                        <td>10:00AM</td>
                        <td>Dr Aboagye</td>
                    </tr>
                    <tr>
                        <td>CPEN 204</td>
                        <td>Database</td>
                        <td>Huawei Lab</td>
                        <td>Monday</td>
                        <td>8:00AM</td>
                        <td>10:00AM</td>
                        <td>Dr Aboagye</td>
                    </tr>
                    <tr >
                        <td>SENG 205</td>
                        <td>Calculus II</td>
                        <td>GCB</td>
                        <td>Wednesday</td>
                        <td>8:00AM</td>
                        <td>10:00AM</td>
                        <td>Dr Alfred</td>
                    </tr>
                    <tr >
                        <td>CPEN 206</td>
                        <td>Data Communication</td>
                        <td>Electronics Lab</td>
                        <td>Wednesday</td>
                        <td>8:00AM</td>
                        <td>10:00AM</td>
                        <td>Dr Aboagye</td>
                    </tr>
                    </tbody>
                </table>
                </div>
            </section>
            

        
      </div>
    </div>
  );
};

export {Dashboard};
