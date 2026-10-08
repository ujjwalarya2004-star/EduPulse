package com.college.controller;

import com.college.dao.FeeDAO;
import com.college.model.FeePayment;
import com.college.model.StudentFee;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet(name = "FeeServlet", urlPatterns = {"/fees"})
public class FeeServlet extends HttpServlet {
    private final FeeDAO feeDAO = new FeeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("pay".equalsIgnoreCase(action)) {
            int feeId = Integer.parseInt(request.getParameter("id"));
            request.setAttribute("studentFeeId", feeId);
            request.getRequestDispatcher("/add-payment.jsp").forward(request, response);
            return;
        }

        String filter = request.getParameter("status");
        List<StudentFee> feeRecords = feeDAO.getAllStudentFees(filter);
        request.setAttribute("feeRecords", feeRecords);
        request.setAttribute("currentFilter", filter);
        request.getRequestDispatcher("/fees.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int studentFeeId = Integer.parseInt(request.getParameter("studentFeeId"));
        String receiptNo = request.getParameter("receiptNo");
        double amount = Double.parseDouble(request.getParameter("amountPaid"));
        String method = request.getParameter("paymentMethod");
        String ref = request.getParameter("transactionRef");
        Date date = Date.valueOf(request.getParameter("paymentDate"));
        String remarks = request.getParameter("remarks");

        FeePayment p = new FeePayment();
        p.setStudentFeeId(studentFeeId);
        p.setReceiptNo(receiptNo);
        p.setAmountPaid(amount);
        p.setPaymentMethod(method);
        p.setTransactionRef(ref);
        p.setPaymentDate(date);
        p.setRemarks(remarks);

        boolean ok = feeDAO.recordPayment(p);
        if (ok) {
            response.sendRedirect(request.getContextPath() + "/fees?msg=Payment+recorded+and+remaining+fee+adjusted+successfully.");
        } else {
            response.sendRedirect(request.getContextPath() + "/fees?error=Failed+to+record+payment.+Check+duplicate+receipt+number.");
        }
    }
}
