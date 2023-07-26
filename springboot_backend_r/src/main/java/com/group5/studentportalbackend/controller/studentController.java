package com.group5.studentportalbackend.controller;

import com.group5.studentportalbackend.model.Student;
import com.group5.studentportalbackend.model.studentLoginRequest;
import com.group5.studentportalbackend.service.studentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
// @CrossOrigin(origins = "http://localhost:3000")
@RequestMapping("/student")
public class studentController {

    @Autowired
    private studentService studentService;

    @PostMapping("/add")
    public Student add(@RequestBody Student student) {
        return studentService.saveStudent(student);
    }

    @PostMapping("/login")
    public ResponseEntity<String> login(@RequestBody studentLoginRequest loginRequest) {

        String studentID = loginRequest.getStudentId();
        String PIN = loginRequest.getPIN();

        boolean isAuthenticated = studentService.authenticateStudent(studentID,PIN);

        if (isAuthenticated) {
            return ResponseEntity.ok().body("Login successful");
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid student ID or password");
        }
    }
}
