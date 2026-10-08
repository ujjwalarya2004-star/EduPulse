package com.college.model;

import java.io.Serializable;
import java.sql.Date;
import java.sql.Timestamp;

public class FeePayment implements Serializable {
    private static final long serialVersionUID = 1L;

    private int paymentId;
    private int studentFeeId;
    private String receiptNo;
    private double amountPaid;
    private String paymentMethod; // ONLINE, CHEQUE, CASH, UPI
    private String transactionRef;
    private Date paymentDate;
    private String remarks;
    private Timestamp createdAt;

    // Display
    private String studentName;
    private String enrollmentNo;

    public FeePayment() {}

    public int getPaymentId() { return paymentId; }
    public void setPaymentId(int paymentId) { this.paymentId = paymentId; }

    public int getStudentFeeId() { return studentFeeId; }
    public void setStudentFeeId(int studentFeeId) { this.studentFeeId = studentFeeId; }

    public String getReceiptNo() { return receiptNo; }
    public void setReceiptNo(String receiptNo) { this.receiptNo = receiptNo; }

    public double getAmountPaid() { return amountPaid; }
    public void setAmountPaid(double amountPaid) { this.amountPaid = amountPaid; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getTransactionRef() { return transactionRef; }
    public void setTransactionRef(String transactionRef) { this.transactionRef = transactionRef; }

    public Date getPaymentDate() { return paymentDate; }
    public void setPaymentDate(Date paymentDate) { this.paymentDate = paymentDate; }

    public String getRemarks() { return remarks; }
    public void setRemarks(String remarks) { this.remarks = remarks; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getEnrollmentNo() { return enrollmentNo; }
    public void setEnrollmentNo(String enrollmentNo) { this.enrollmentNo = enrollmentNo; }
}
