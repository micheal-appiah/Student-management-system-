import React, { useState } from "react";
import axios from 'axios';



export const StudentInfoEntryPage = (props) => {
  const [firstName, setFirstName] = useState('');
  const [lastName, setLastName] = useState('');
  const [studentID, setStudentID] = useState('');
  const [level, setLevel] = useState('');
  const [hallOfResidence, setHallOfResidence] = useState('');
  const [department, setDepartment] = useState('');
  const [guardianName, setGuardianName] = useState('');
  const [guardianPhone, setGuardianPhone] = useState('');
  const [sex, setSex] = useState('');

  console.log('===>',props.data.email,props.data.PIN,props.data.studentID);

  const handleSubmit = (e) => {
    e.preventDefault();
    const data = {
      firstName,
      lastName,
      level,
      hallOfResidence,
      department,
      guardianName,
      guardianPhone,
      sex:sex.toString(),
      PIN:props.data.PIN,
      studentID:props.data.studentID,
      email:props.data.email,

    };

    // axios.post("http://localhost:8080/student/add", data)
    //   .then((response) => {
    //     console.log("Post successful:", response.data);
    //     // Handle any success actions if needed...
    //   })
    //   .catch((error) => {
    //     console.error("Error posting data:", error.message);
    //     // Handle any error actions if needed...
    //   });

        fetch("http://localhost:8080/student/add", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(data),
    })
      .then((response) => {
        if (!response.ok) {
          throw new Error("Network response was not ok");
        }
        return response.json();
      })
      .then((data) => {
        console.log("Post successful:", data);
        props.onFormSwitch('dashboard');
        alert("Registered Successfully")
      })
      .catch((error) => {
        console.error("Error posting data:", error.message);
        // setErrorMessage("Error registering student. Please try again later.");// Set error message in case of an error
      });
  }

  return (
    <div className="auth-form-container">
      <div className="Leftside"></div>
      <div className="Rightside">
        <h1>Please Enter Your Information</h1>
        <form className="info-entry-form" onSubmit={handleSubmit}>
          <label htmlFor="firstName">First Name</label>
          <input type="text" id="firstName" value={firstName} onChange={(e) => setFirstName(e.target.value)} required />

          <label htmlFor="lastName">Last Name</label>
          <input type="text" id="lastName" value={lastName} onChange={(e) => setLastName(e.target.value)} required />

          <label htmlFor="studentID">Student ID</label>
          <input type="text" id="studentID" value={studentID} onChange={(e) => setStudentID(e.target.value)} required />

          <label htmlFor="level">Level</label>
          <input type="text" id="level" value={level} onChange={(e) => setLevel(e.target.value)} required />

          <label htmlFor="hallOfResidence">Hall of Residence</label>
          <input type="text" id="hallOfResidence" value={hallOfResidence} onChange={(e) => setHallOfResidence(e.target.value)} required />

          <label htmlFor="department">Department</label>
          <input type="text" id="department" value={department} onChange={(e) => setDepartment(e.target.value)} required />

          <label htmlFor="guardianName">Guardian's Name</label>
          <input type="text" id="guardianName" value={guardianName} onChange={(e) => setGuardianName(e.target.value)} required />

          <label htmlFor="guardianPhone">Guardian's Phone Number</label>
          <input type="tel" id="guardianPhone" value={guardianPhone} onChange={(e) => setGuardianPhone(e.target.value)} required />

          <label htmlFor="sex">Sex</label>
          <select id="sex" value={sex} onChange={(e) => setSex(e.target.value)} required>
            <option value="">Select</option>
            <option value="male">Male</option>
            <option value="female">Female</option>
            <option value="other">Other</option>
          </select>

          <button type="submit">Submit</button>
        </form>
      </div>
    </div>
  );
};
