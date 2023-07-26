import React, { useState } from "react";
import uglogo from './uglogo.jpg';
import webappbackgroundpic from './webappbackgroundpic.jpeg';

export const LoginPage = (props) => {
  const [email, setEmail] = useState('');
  const [PIN, setPIN] = useState('');

  const handleSubmit = async (e) => {
    e.preventDefault();
    const data = {
      email,
      PIN,
    };

    try {
      const response = await fetch("http://localhost:8080/api/login", {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(data),
      });

      if (response.ok) {
        const result = await response.json();
        const isValidLogin = result.isValid;
        if (isValidLogin) {
          props.onFormSwitch('dashboard');
        } else {
          console.log("Invalid login");
        }
      } else {
        console.error("Login request failed:", response.status, response.statusText);
      }
    } catch (error) {
      console.error("Error during login:", error);
    }
  };

  return (
    <div className="auth-form-container">
      <div className="Leftside">
      </div>
      <div className="Rightside">
        <div>
          <img className="logo" src={uglogo} alt="UG Logo" />
        </div>
        <div className="Message">
          <h1>WELCOME TO THE SCHOOL OF ENGINEERING SCIENCES STUDENT PORTAL</h1>
          <h2>LOG IN TO ACCESS YOUR DASHBOARD</h2>
        </div>

        <form className="loginpage-form" onSubmit={handleSubmit}>
          <label htmlFor="email">Email</label>
          <input
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            type="email"
            placeholder="youremail@st.ug.edu.gh"
            id="email"
            name="email"
            required
          />
          <label htmlFor="password">PIN</label>
          <input
            value={PIN}
            onChange={(e) => setPIN(e.target.value)}
            type="password"
            placeholder="**********"
            id="PIN"
            name="PIN"
            required
          />
          <button className="login-btn" type="submit">Log In</button>
          <button
            className="link-btn"
            onClick={() => props.onFormSwitch('registration')}
          >
            Don't have an account? Register here
          </button>
        </form>

      </div>
    </div>
  );
};

export default LoginPage;
