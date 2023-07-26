package com.group5.studentportalbackend.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.group5.studentportalbackend.model.Student;

@Repository
public interface studentRepository extends JpaRepository<Student, Long> {
    Optional<Student> findByStudentIDAndPIN(String studentID, String PIN);

    Optional<Student> findByStudentID(String studentID);
}
