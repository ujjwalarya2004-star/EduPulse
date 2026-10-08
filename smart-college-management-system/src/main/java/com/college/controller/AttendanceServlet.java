package com.college.controller;

import com.college.dao.AttendanceDAO;
import com.college.dao.EnrollmentDAO;
import com.college.dao.SubjectDAO;
import com.college.model.Attendance;
import com.college.model.Enrollment;
import com.college.model.Subject;
import com.college.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AttendanceServlet", urlPatterns = {"/attendance"})
public class AttendanceServlet extends HttpServlet {
    private final AttendanceDAO attendanceDAO = new AttendanceDAO();
    private final SubjectDAO subjectDAO = new SubjectDAO();
    private final EnrollmentDAO enrollmentDAO = new EnrollmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("view".equalsIgnoreCase(action)) {
            // View subject-wise attendance register
            String subStr = request.getParameter("subjectId");
            Integer subId = (subStr != null && !subStr.isEmpty()) ? Integer.parseInt(subStr) : null;
            List<Attendance> summaries = attendanceDAO.getAttendanceSummaries(subId);

            request.setAttribute("summaries", summaries);
            request.setAttribute("subjects", subjectDAO.getAllSubjects());
            request.setAttribute("selectedSubjectId", subId);
            request.getRequestDispatcher("/view-attendance.jsp").forward(request, response);
            return;
        }

        // Attendance marking screen
        String subStr = request.getParameter("subjectId");
        List<Subject> subjects = subjectDAO.getAllSubjects();
        request.setAttribute("subjects", subjects);

        if (subStr != null && !subStr.isEmpty()) {
            int subId = Integer.parseInt(subStr);
            List<Enrollment> enrolledStudents = new ArrayList<>();
            for (Enrollment en : enrollmentDAO.getAllEnrollments()) {
                if (en.getSubjectId() == subId) {
                    enrolledStudents.add(en);
                }
            }
            request.setAttribute("enrolledStudents", enrolledStudents);
            request.setAttribute("selectedSubjectId", subId);
        }

        request.getRequestDispatcher("/attendance.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int subjectId = Integer.parseInt(request.getParameter("subjectId"));
        Date attDate = Date.valueOf(request.getParameter("attendanceDate"));

        String[] presentIdsStr = request.getParameterValues("presentStudents");
        String[] allStudentIdsStr = request.getParameterValues("allStudentIds");

        List<Integer> presentIds = new ArrayList<>();
        if (presentIdsStr != null) {
            for (String pid : presentIdsStr) {
                presentIds.add(Integer.parseInt(pid));
            }
        }

        List<Integer> absentIds = new ArrayList<>();
        if (allStudentIdsStr != null) {
            for (String sidStr : allStudentIdsStr) {
                int sid = Integer.parseInt(sidStr);
                if (!presentIds.contains(sid)) {
                    absentIds.add(sid);
                }
            }
        }

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        Integer facultyId = (currentUser != null) ? currentUser.getFacultyId() : null;

        boolean success = attendanceDAO.markBatchAttendance(subjectId, attDate, presentIds, absentIds, facultyId);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/attendance?action=view&subjectId=" + subjectId + "&msg=Attendance+recorded+successfully+for+" + attDate);
        } else {
            response.sendRedirect(request.getContextPath() + "/attendance?subjectId=" + subjectId + "&error=Failed+to+save+attendance.");
        }
    }
}
