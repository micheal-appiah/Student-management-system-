package com.group5.studentportalbackend.service;

import com.group5.studentportalbackend.model.Student;

public interface studentService {
    Student saveStudent(Student student);

    boolean authenticateStudent(String studentID, String PIN);
}
