package com.college.controller;

import com.college.dao.MarksDAO;
import com.college.dao.StudentDAO;
import com.college.dao.SubjectDAO;
import com.college.model.Marks;
import com.college.model.Student;
import com.college.model.Subject;
import com.college.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "MarksServlet", urlPatterns = {"/marks"})
public class MarksServlet extends HttpServlet {
    private final MarksDAO marksDAO = new MarksDAO();
    private final SubjectDAO subjectDAO = new SubjectDAO();
    private final StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("result".equalsIgnoreCase(action)) {
            // Student Report Card / Transcript View
            int studentId = Integer.parseInt(request.getParameter("studentId"));
            Student s = studentDAO.getStudentById(studentId);
            List<Marks> transcript = marksDAO.getStudentTranscript(studentId);

            double totalMarksAll = 0;
            int totalMax = transcript.size() * 120;
            for (Marks m : transcript) {
                totalMarksAll += m.getTotalMarks();
            }
            double overallPct = totalMax > 0 ? (totalMarksAll / totalMax) * 100.0 : 0.0;

            request.setAttribute("student", s);
            request.setAttribute("transcript", transcript);
            request.setAttribute("totalMarksAll", totalMarksAll);
            request.setAttribute("totalMax", totalMax);
            request.setAttribute("overallPct", Math.round(overallPct * 10.0) / 10.0);

            request.getRequestDispatcher("/student-result.jsp").forward(request, response);
            return;
        }

        // Marks ledger entry by subject
        List<Subject> subjects = subjectDAO.getAllSubjects();
        request.setAttribute("subjects", subjects);

        String subStr = request.getParameter("subjectId");
        if (subStr != null && !subStr.isEmpty()) {
            int subId = Integer.parseInt(subStr);
            List<Marks> marksList = marksDAO.getMarksBySubject(subId);
            request.setAttribute("marksList", marksList);
            request.setAttribute("selectedSubjectId", subId);
        }

        request.setAttribute("allStudents", studentDAO.getAllStudents(null, null, null));
        request.getRequestDispatcher("/marks.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int studentId = Integer.parseInt(request.getParameter("studentId"));
        int subjectId = Integer.parseInt(request.getParameter("subjectId"));
        double assignment = Double.parseDouble(request.getParameter("assignmentMarks"));
        double internal = Double.parseDouble(request.getParameter("internalMarks"));
        double practical = Double.parseDouble(request.getParameter("practicalMarks"));
        double endSem = Double.parseDouble(request.getParameter("endSemMarks"));

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;
        Integer facultyId = (user != null) ? user.getFacultyId() : null;

        Marks m = new Marks();
        m.setStudentId(studentId);
        m.setSubjectId(subjectId);
        m.setAssignmentMarks(assignment);
        m.setInternalMarks(internal);
        m.setPracticalMarks(practical);
        m.setEndSemMarks(endSem);
        m.setEnteredBy(facultyId);

        boolean ok = marksDAO.saveOrUpdateMarks(m);
        if (ok) {
            response.sendRedirect(request.getContextPath() + "/marks?subjectId=" + subjectId + "&msg=Marks+saved+and+grade+computed+successfully.");
        } else {
            response.sendRedirect(request.getContextPath() + "/marks?subjectId=" + subjectId + "&error=Failed+to+save+marks.");
        }
    }
}
