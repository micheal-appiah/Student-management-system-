import React, { useState} from "react";
import webappbackgroundpic from './webappbackgroundpic.jpeg';
import { parseJSON } from "jquery";
// import {useHistory} from 'react-router-dom'

export const StudentRegistration = (props) => {
  const [email, setEmail] = useState("");
  const [PIN, setPIN] = useState("");
  const [studentID, setStudentID] = useState("");
  const [errorMessage, setErrorMessage] = useState(""); // State variable to store error message
  // const history = useHistory()

  console.log('This is ',props);

  const handleStudentIDChange = (e) => {
    setStudentID(e.target.value);
  };

  const handleEmailChange = (e) => {
    setEmail(e.target.value);
  };

  const handlePINChange = (e) => {
    setPIN(e.target.value);
  };

  const onFormSwitched =() =>{
  //   history.pushState({
  //     parthName: `/LoginPage`,
  //     state:data
  // })
  }
  const handleSubmit = (e) => {
    e.preventDefault();

    const data = {
      email,
      PIN,
      studentID,
     
    };
      props.setData(data)
    // fetch("http://localhost:8080/student/add", {
    //   method: "POST",
    //   headers: {
    //     "Content-Type": "application/json",
    //   },
    //   body: JSON.stringify(data),
    // })
    //   .then((response) => {
    //     if (!response.ok) {
    //       throw new Error("Network response was not ok");
    //     }
    //     return response.json();
    //   })
    //   .then((data) => {
    //     console.log("Post successful:", data);
        props.onFormSwitch('infoEntry');
    //   })
    //   .catch((error) => {
    //     console.error("Error posting data:", error);
    //     setErrorMessage("Error registering student. Please try again later."); // Set error message in case of an error
    //   });
  };

  const handleFormSwitch = () => {
    props.onFormSwitch("LoginPage");
  };

  return (
    <div className="auth-form-container">
      <div className="Leftside">
         
      </div>
      <div className="Rightside">
        <h1>CREATE YOUR STUDENT ACCOUNT</h1>
        <br></br>
        <br></br>
        <br></br>
        {/* Render error message if there is one */}
        {errorMessage && <div className="error-message">{errorMessage}</div>}
        <form className="studentregistration-form" onSubmit={handleSubmit}>
          <label htmlFor="studentID">Student ID</label>
          <input
            value={studentID}
            type="number"
            name="studentID"
            placeholder="Enter Student ID"
            id="studentID"
            onChange={handleStudentIDChange}
            autoComplete="off"
            required
          />
          <label htmlFor="email">Email</label>
          <input
            value={email}
            type="email"
            placeholder="youremail@st.ug.edu.gh"
            id="email"
            name="email"
            onChange={handleEmailChange}
            autoComplete="email"
            required
          />
          <label htmlFor="PIN">PIN</label>
          <input
            value={PIN}
            type="password"
            placeholder="**********"
            id="PIN"
            name="PIN"
            onChange={handlePINChange}
            autoComplete="new-PIN"
            required
          />
          <button type="submit">Log In</button>
        </form>
        <button className="link-btn" onClick={() => onFormSwitched()}>
          Already have an account? Log in here
        </button>
      </div>
    </div>
  );
};

export default StudentRegistration;
