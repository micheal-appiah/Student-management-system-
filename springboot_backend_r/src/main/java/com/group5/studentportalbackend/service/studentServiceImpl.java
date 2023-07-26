package com.group5.studentportalbackend.service;

import com.group5.studentportalbackend.model.Student;
import com.group5.studentportalbackend.repository.studentRepository;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class studentServiceImpl implements studentService {

    private final studentRepository studentRepository;

    @Autowired
    public studentServiceImpl(studentRepository studentRepository) {
        this.studentRepository = studentRepository;
    }

    @Override
    public Student saveStudent(Student student) {
    	 Optional<Student> existingStudentWithID = studentRepository.findByStudentID(student.getStudentID());
         if (existingStudentWithID.isPresent()) {
             throw new IllegalArgumentException("Student with this ID already exists");
         }

         
        return studentRepository.save(student);
    }

    @Override
    public boolean authenticateStudent(String studentID, String PIN) {
        Student student = studentRepository.findByStudentIDAndPIN(studentID, PIN)
                .orElse(null);
        return student != null;
    }
}
