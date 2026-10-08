package com.college.controller;

import com.college.dao.*;
import com.college.model.*;
import com.college.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet(name = "StudentServlet", urlPatterns = {"/students"})
public class StudentServlet extends HttpServlet {
    private final StudentDAO studentDAO = new StudentDAO();
    private final DepartmentDAO departmentDAO = new DepartmentDAO();
    private final EnrollmentDAO enrollmentDAO = new EnrollmentDAO();
    private final AttendanceDAO attendanceDAO = new AttendanceDAO();
    private final MarksDAO marksDAO = new MarksDAO();
    private final FeeDAO feeDAO = new FeeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "view":
                viewProfile(request, response);
                break;
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            default:
                listStudents(request, response);
                break;
        }
    }

    private void listStudents(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String query = request.getParameter("q");
        String deptStr = request.getParameter("dept");
        String semStr = request.getParameter("sem");

        Integer deptId = (deptStr != null && !deptStr.isEmpty()) ? Integer.parseInt(deptStr) : null;
        Integer semester = (semStr != null && !semStr.isEmpty()) ? Integer.parseInt(semStr) : null;

        List<Student> students = studentDAO.getAllStudents(query, deptId, semester);
        List<Department> departments = departmentDAO.getAllDepartments();

        request.setAttribute("students", students);
        request.setAttribute("departments", departments);
        request.getRequestDispatcher("/students.jsp").forward(request, response);
    }

    private void viewProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Student s = studentDAO.getStudentById(id);
        if (s == null) {
            response.sendRedirect(request.getContextPath() + "/students?error=Student+not+found");
            return;
        }

        List<Enrollment> enrollments = enrollmentDAO.getEnrollmentsByStudent(id);
        List<Attendance> attendanceHistory = attendanceDAO.getStudentAttendanceHistory(id);
        List<Marks> transcript = marksDAO.getStudentTranscript(id);
        List<FeePayment> feePayments = feeDAO.getPaymentsByStudent(id);

        request.setAttribute("student", s);
        request.setAttribute("enrollments", enrollments);
        request.setAttribute("attendanceHistory", attendanceHistory);
        request.setAttribute("transcript", transcript);
        request.setAttribute("feePayments", feePayments);

        request.getRequestDispatcher("/student-profile.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("departments", departmentDAO.getAllDepartments());
        request.getRequestDispatcher("/add-student.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Student s = studentDAO.getStudentById(id);
        request.setAttribute("student", s);
        request.setAttribute("departments", departmentDAO.getAllDepartments());
        request.getRequestDispatcher("/edit-student.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("delete".equalsIgnoreCase(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean ok = studentDAO.deleteStudent(id);
            if (ok) {
                response.sendRedirect(request.getContextPath() + "/students?msg=Student+deleted+successfully.");
            } else {
                response.sendRedirect(request.getContextPath() + "/students?error=Unable+to+delete+student+due+to+foreign+key+constraints.");
            }
            return;
        }

        String enrollmentNo = request.getParameter("enrollmentNo");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String gender = request.getParameter("gender");
        String dobStr = request.getParameter("dob");
        String address = request.getParameter("address");
        int deptId = Integer.parseInt(request.getParameter("deptId"));
        int semester = Integer.parseInt(request.getParameter("semester"));
        int admissionYear = Integer.parseInt(request.getParameter("admissionYear"));
        String status = request.getParameter("status");

        if (!ValidationUtil.isValidEmail(email) || !ValidationUtil.isValidPhone(phone)) {
            request.setAttribute("errorMessage", "Invalid email format or phone number.");
            showAddForm(request, response);
            return;
        }

        Student s = new Student();
        s.setEnrollmentNo(enrollmentNo);
        s.setName(name);
        s.setEmail(email);
        s.setPhone(phone);
        s.setGender(gender);
        s.setDob(Date.valueOf(dobStr));
        s.setAddress(address);
        s.setDeptId(deptId);
        s.setSemester(semester);
        s.setAdmissionYear(admissionYear);
        s.setStatus(status != null ? status : "ACTIVE");

        if ("edit".equalsIgnoreCase(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            s.setStudentId(id);
            if (studentDAO.updateStudent(s)) {
                response.sendRedirect(request.getContextPath() + "/students?action=view&id=" + id + "&msg=Student+updated+successfully.");
            } else {
                response.sendRedirect(request.getContextPath() + "/students?error=Failed+to+update+student.");
            }
        } else {
            if (studentDAO.addStudent(s)) {
                response.sendRedirect(request.getContextPath() + "/students?msg=Student+registered+successfully.");
            } else {
                request.setAttribute("errorMessage", "Error registering student. Check if enrollment number or email already exists.");
                showAddForm(request, response);
            }
        }
    }
}
