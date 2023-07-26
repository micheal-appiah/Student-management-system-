import React, { useState } from "react";
import logo from './logo.svg';
import './App.css';
import { LoginPage } from './LoginPage';
import { StudentRegistration } from './StudentRegistration';
import { StudentInfoEntryPage } from './StudentInfoEntryPage';
import { Dashboard } from './Dashboard';

function App() {
  const [currentForm, setCurrentForm] = useState('login');
  const [studentDetails, setStudentDetails] = useState(null);
  const [data, setData] = useState(null);


  const handleFormSwitch = (formName) => {
    setCurrentForm(formName);
  }

  const handleInfoSubmit = (details) => {
    setStudentDetails(details);
    setCurrentForm('dashboard');
  }

  return (
    <div className="App">
      {currentForm === 'login' && <LoginPage className="loginpage" onFormSwitch={handleFormSwitch}   />}
      {currentForm === 'registration' && <StudentRegistration className="studentregistration" onFormSwitch={handleFormSwitch} setData={setData} />}
      {currentForm === 'infoEntry' && <StudentInfoEntryPage className="studentinfoentry" onSubmit={handleInfoSubmit} onFormSwitch={handleFormSwitch} data={data} />}
      {currentForm === 'dashboard' && <Dashboard className="dashboard" studentDetails={studentDetails} />}
    </div>
  );
}

export default App;
