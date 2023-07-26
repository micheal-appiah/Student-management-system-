package com.lab2.lab_two.service;

import com.lab2.lab_two.model.Assignment;
import com.lab2.lab_two.repository.AssignmentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class AssignmentService {
    private final AssignmentRepository assignmentRepository;

    @Autowired
    public AssignmentService(AssignmentRepository assignmentRepository) {
        this.assignmentRepository = assignmentRepository;
    }

    public Assignment createAssignment(String department, String level, String title, Date dueDate) {
        Assignment assignment = new Assignment();
        assignment.setDepartment(department);
        assignment.setLevel(level);
        assignment.setTitle(title);
        assignment.setDueDate(dueDate);
        return assignmentRepository.save(assignment);
    }

    public Assignment getAssignment(int id) {
        return assignmentRepository.findById(id).orElse(null);
    }

    public List<Assignment> getAssignmentsByDepartmentAndLevel(String department, String level) {
        return assignmentRepository.findByDepartmentAndLevel(department, level);
    }

    // Additional methods for updating and deleting assignments can be implemented here
    // ...
}
