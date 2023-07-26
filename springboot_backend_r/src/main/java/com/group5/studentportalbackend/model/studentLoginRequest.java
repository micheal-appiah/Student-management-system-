package com.group5.studentportalbackend.model;

public class studentLoginRequest {

    private String studentID;
    private String PIN;

    public String getStudentId() {
        return studentID;
    }

    public void setStudentId(String studentId) {
        this.studentID = studentId;
    }

    public String getPIN() {
        return PIN;
    }

    public void setPassword(String password) {
        this.PIN = PIN;
    }
}
