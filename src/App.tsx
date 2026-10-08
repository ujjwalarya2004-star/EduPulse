import React, { useState, useMemo } from 'react';
import {
  Users,
  Building,
  GraduationCap,
  BookOpen,
  CalendarCheck,
  Award,
  CreditCard,
  FileText,
  Search,
  Plus,
  Trash2,
  Eye,
  CheckCircle,
  AlertTriangle,
  Download,
  Database,
  Server,
  Layers,
  Check,
  Printer,
  X,
  Filter,
  ShieldCheck,
  Send,
  RefreshCw,
  Sliders,
  DollarSign,
  PieChart,
  UserCheck,
  FileSpreadsheet,
  Terminal,
  Activity,
  ArrowUpRight,
  Clock,
  Sparkles,
  ChevronRight,
  BookMarked
} from 'lucide-react';

// Core Types
interface StudentRecord {
  id: number;
  enrollmentNo: string;
  name: string;
  email: string;
  phone: string;
  gender: 'MALE' | 'FEMALE' | 'OTHER';
  dob: string;
  address: string;
  deptId: number;
  deptCode: string;
  semester: number;
  admissionYear: number;
  status: 'ACTIVE' | 'SUSPENDED' | 'GRADUATED';
  attendancePct: number;
  avgMarks: number;
  pendingFees: number;
}

interface DepartmentRecord {
  id: number;
  code: string;
  name: string;
  description: string;
  students: number;
  faculty: number;
  subjects: number;
}

interface FacultyRecord {
  id: number;
  empId: string;
  name: string;
  email: string;
  phone: string;
  deptId: number;
  deptCode: string;
  designation: string;
  qualification: string;
  joiningDate: string;
}

interface SubjectRecord {
  id: number;
  code: string;
  name: string;
  credits: number;
  semester: number;
  deptId: number;
  deptCode: string;
  facultyName: string;
}

interface EnrollmentRecord {
  id: number;
  studentId: number;
  studentName: string;
  enrollmentNo: string;
  subjectId: number;
  subjectCode: string;
  subjectName: string;
  academicYear: string;
}

interface AttendanceSession {
  subjectId: number;
  subjectCode: string;
  subjectName: string;
  studentId: number;
  studentName: string;
  enrollmentNo: string;
  totalClasses: number;
  attended: number;
  percentage: number;
}

interface MarksRecord {
  studentId: number;
  studentName: string;
  enrollmentNo: string;
  subjectId: number;
  subjectCode: string;
  subjectName: string;
  assignment: number;
  internal: number;
  practical: number;
  endSem: number;
  total: number;
  grade: string;
}

interface FeeRecord {
  id: number;
  studentId: number;
  studentName: string;
  enrollmentNo: string;
  deptCode: string;
  semester: number;
  total: number;
  paid: number;
  pending: number;
  status: 'PAID' | 'PARTIAL' | 'PENDING';
  dueDate: string;
}

interface LeaveRecord {
  id: number;
  studentId: number;
  studentName: string;
  enrollmentNo: string;
  fromDate: string;
  toDate: string;
  reason: string;
  status: 'PENDING' | 'APPROVED' | 'REJECTED';
  appliedDate: string;
  reviewerRemarks?: string;
}

export default function App() {
  const [currentModule, setCurrentModule] = useState<string>('dashboard');
  const [currentRole, setCurrentRole] = useState<'ADMIN' | 'FACULTY'>('ADMIN');
  const [toastMessage, setToastMessage] = useState<string | null>(null);
  const [showDevConsole, setShowDevConsole] = useState<boolean>(false);

  // Global Quick Search
  const [globalSearch, setGlobalSearch] = useState('');
  const [isSearchOpen, setIsSearchOpen] = useState(false);

  // Primary interactive data states
  const [students, setStudents] = useState<StudentRecord[]>([
    { id: 1, enrollmentNo: 'EN2024CS01', name: 'Aarav Patel', email: 'aarav.patel@student.college.edu', phone: '9811100001', gender: 'MALE', dob: '2004-03-12', address: '101 MG Road, Bangalore', deptId: 1, deptCode: 'CSE', semester: 4, admissionYear: 2024, status: 'ACTIVE', attendancePct: 90.0, avgMarks: 104.2, pendingFees: 0 },
    { id: 2, enrollmentNo: 'EN2024CS02', name: 'Diya Sharma', email: 'diya.sharma@student.college.edu', phone: '9811100002', gender: 'FEMALE', dob: '2004-07-25', address: '204 Park View, Mumbai', deptId: 1, deptCode: 'CSE', semester: 4, admissionYear: 2024, status: 'ACTIVE', attendancePct: 100.0, avgMarks: 114.5, pendingFees: 0 },
    { id: 3, enrollmentNo: 'EN2024CS03', name: 'Rahul Verma', email: 'rahul.verma@student.college.edu', phone: '9811100003', gender: 'MALE', dob: '2003-11-14', address: '15 Civil Lines, Jaipur', deptId: 1, deptCode: 'CSE', semester: 4, admissionYear: 2024, status: 'ACTIVE', attendancePct: 60.0, avgMarks: 47.5, pendingFees: 30000 },
    { id: 4, enrollmentNo: 'EN2024CS04', name: 'Ananya Gupta', email: 'ananya.gupta@student.college.edu', phone: '9811100004', gender: 'FEMALE', dob: '2004-05-19', address: '88 Sector 18, Noida', deptId: 1, deptCode: 'CSE', semester: 4, admissionYear: 2024, status: 'ACTIVE', attendancePct: 80.0, avgMarks: 91.0, pendingFees: 0 },
    { id: 5, enrollmentNo: 'EN2024CS05', name: 'Rohan Mehta', email: 'rohan.mehta@student.college.edu', phone: '9811100005', gender: 'MALE', dob: '2004-01-08', address: '45 Satellite, Ahmedabad', deptId: 1, deptCode: 'CSE', semester: 4, admissionYear: 2024, status: 'ACTIVE', attendancePct: 50.0, avgMarks: 58.0, pendingFees: 50000 },
    { id: 6, enrollmentNo: 'EN2024CS06', name: 'Isha Sen', email: 'isha.sen@student.college.edu', phone: '9811100006', gender: 'FEMALE', dob: '2004-09-30', address: '12 Salt Lake, Kolkata', deptId: 1, deptCode: 'CSE', semester: 4, admissionYear: 2024, status: 'ACTIVE', attendancePct: 90.0, avgMarks: 108.0, pendingFees: 0 },
    { id: 7, enrollmentNo: 'EN2024IT01', name: 'Kavya Reddy', email: 'kavya.reddy@student.college.edu', phone: '9811100007', gender: 'FEMALE', dob: '2004-04-10', address: '77 Jubilee Hills, Hyderabad', deptId: 2, deptCode: 'IT', semester: 4, admissionYear: 2024, status: 'ACTIVE', attendancePct: 88.0, avgMarks: 100.5, pendingFees: 0 },
    { id: 8, enrollmentNo: 'EN2024IT02', name: 'Aditya Joshi', email: 'aditya.joshi@student.college.edu', phone: '9811100008', gender: 'MALE', dob: '2003-12-05', address: '32 FC Road, Pune', deptId: 2, deptCode: 'IT', semester: 4, admissionYear: 2024, status: 'ACTIVE', attendancePct: 85.0, avgMarks: 106.0, pendingFees: 23500 },
    { id: 9, enrollmentNo: 'EN2024IT03', name: 'Pooja Iyer', email: 'pooja.iyer@student.college.edu', phone: '9811100009', gender: 'FEMALE', dob: '2004-08-22', address: '14 Anna Nagar, Chennai', deptId: 2, deptCode: 'IT', semester: 4, admissionYear: 2024, status: 'ACTIVE', attendancePct: 92.0, avgMarks: 98.0, pendingFees: 0 },
    { id: 10, enrollmentNo: 'EN2024IT04', name: 'Sameer Khan', email: 'sameer.khan@student.college.edu', phone: '9811100010', gender: 'MALE', dob: '2004-02-18', address: '56 Hazratganj, Lucknow', deptId: 2, deptCode: 'IT', semester: 4, admissionYear: 2024, status: 'ACTIVE', attendancePct: 84.0, avgMarks: 94.0, pendingFees: 33500 },
    { id: 11, enrollmentNo: 'EN2024EC01', name: 'Tanvi Saxena', email: 'tanvi.saxena@student.college.edu', phone: '9811100011', gender: 'FEMALE', dob: '2004-06-15', address: '23 Arera Colony, Bhopal', deptId: 3, deptCode: 'ECE', semester: 4, admissionYear: 2024, status: 'ACTIVE', attendancePct: 89.0, avgMarks: 102.0, pendingFees: 0 },
    { id: 12, enrollmentNo: 'EN2024EC02', name: 'Manish Choudhary', email: 'manish.c@student.college.edu', phone: '9811100012', gender: 'MALE', dob: '2003-10-28', address: '90 Tonk Road, Jaipur', deptId: 3, deptCode: 'ECE', semester: 4, admissionYear: 2024, status: 'ACTIVE', attendancePct: 86.0, avgMarks: 95.0, pendingFees: 0 }
  ]);

  const [departments] = useState<DepartmentRecord[]>([
    { id: 1, code: 'CSE', name: 'Computer Science & Engineering', description: 'Computing Algorithms, AI, Systems, and Software', students: 6, faculty: 2, subjects: 4 },
    { id: 2, code: 'IT', name: 'Information Technology', description: 'Cloud Computing, DevOps, and Full-Stack Engineering', students: 4, faculty: 2, subjects: 2 },
    { id: 3, code: 'ECE', name: 'Electronics & Communication', description: 'VLSI Design, Signal Processing, and Embedded Systems', students: 2, faculty: 2, subjects: 2 },
    { id: 4, code: 'ME', name: 'Mechanical Engineering', description: 'Thermodynamics, Robotics, Fluid Mechanics, CAD/CAM', students: 2, faculty: 1, subjects: 1 },
    { id: 5, code: 'CE', name: 'Civil Engineering', description: 'Structural Engineering, Transportation, Geotechnical', students: 2, faculty: 1, subjects: 1 }
  ]);

  const [faculty] = useState<FacultyRecord[]>([
    { id: 1, empId: 'FAC001', name: 'Dr. Rajesh Sharma', email: 'rajesh.sharma@college.edu', phone: '9876543210', deptId: 1, deptCode: 'CSE', designation: 'Professor & HOD', qualification: 'Ph.D in Computer Science', joiningDate: '2016-07-15' },
    { id: 2, empId: 'FAC002', name: 'Prof. Priya Nair', email: 'priya.nair@college.edu', phone: '9876543211', deptId: 1, deptCode: 'CSE', designation: 'Associate Professor', qualification: 'M.Tech in Software Engg', joiningDate: '2018-08-01' },
    { id: 3, empId: 'FAC003', name: 'Dr. Amit Verma', email: 'amit.verma@college.edu', phone: '9876543212', deptId: 2, deptCode: 'IT', designation: 'Professor', qualification: 'Ph.D in Information Tech', joiningDate: '2015-06-20' },
    { id: 4, empId: 'FAC004', name: 'Prof. Sneha Kulkarni', email: 'sneha.kulkarni@college.edu', phone: '9876543213', deptId: 2, deptCode: 'IT', designation: 'Assistant Professor', qualification: 'M.Tech in Data Science', joiningDate: '2020-01-10' },
    { id: 5, empId: 'FAC005', name: 'Dr. Vikram Malhotra', email: 'vikram.malhotra@college.edu', phone: '9876543214', deptId: 3, deptCode: 'ECE', designation: 'Associate Professor', qualification: 'Ph.D in VLSI Systems', joiningDate: '2017-09-05' },
    { id: 6, empId: 'FAC006', name: 'Prof. Ananya Roy', email: 'ananya.roy@college.edu', phone: '9876543215', deptId: 3, deptCode: 'ECE', designation: 'Assistant Professor', qualification: 'M.Tech in Microelectronics', joiningDate: '2021-03-15' },
    { id: 7, empId: 'FAC007', name: 'Dr. Ramesh Patil', email: 'ramesh.patil@college.edu', phone: '9876543216', deptId: 4, deptCode: 'ME', designation: 'Professor & HOD', qualification: 'Ph.D in Thermal Engg', joiningDate: '2014-04-12' },
    { id: 8, empId: 'FAC008', name: 'Dr. Sunita Deshmukh', email: 'sunita.deshmukh@college.edu', phone: '9876543217', deptId: 5, deptCode: 'CE', designation: 'Associate Professor', qualification: 'Ph.D in Structural Engg', joiningDate: '2016-11-01' }
  ]);

  const [subjects] = useState<SubjectRecord[]>([
    { id: 1, code: 'CS401', name: 'Database Management Systems', credits: 4, semester: 4, deptId: 1, deptCode: 'CSE', facultyName: 'Dr. Rajesh Sharma' },
    { id: 2, code: 'CS402', name: 'Operating Systems', credits: 4, semester: 4, deptId: 1, deptCode: 'CSE', facultyName: 'Prof. Priya Nair' },
    { id: 3, code: 'CS403', name: 'Design & Analysis of Algorithms', credits: 4, semester: 4, deptId: 1, deptCode: 'CSE', facultyName: 'Dr. Rajesh Sharma' },
    { id: 4, code: 'CS404', name: 'Computer Networks', credits: 3, semester: 4, deptId: 1, deptCode: 'CSE', facultyName: 'Prof. Priya Nair' },
    { id: 5, code: 'IT401', name: 'Web Technologies & Frameworks', credits: 4, semester: 4, deptId: 2, deptCode: 'IT', facultyName: 'Dr. Amit Verma' },
    { id: 6, code: 'IT402', name: 'Cloud Computing & DevOps', credits: 3, semester: 4, deptId: 2, deptCode: 'IT', facultyName: 'Prof. Sneha Kulkarni' },
    { id: 7, code: 'EC401', name: 'Digital Signal Processing', credits: 4, semester: 4, deptId: 3, deptCode: 'ECE', facultyName: 'Dr. Vikram Malhotra' },
    { id: 8, code: 'EC402', name: 'Microprocessors & Microcontrollers', credits: 4, semester: 4, deptId: 3, deptCode: 'ECE', facultyName: 'Prof. Ananya Roy' },
    { id: 9, code: 'ME401', name: 'Fluid Mechanics & Machinery', credits: 4, semester: 4, deptId: 4, deptCode: 'ME', facultyName: 'Dr. Ramesh Patil' },
    { id: 10, code: 'CE401', name: 'Structural Analysis & Design', credits: 4, semester: 4, deptId: 5, deptCode: 'CE', facultyName: 'Dr. Sunita Deshmukh' }
  ]);

  const [enrollments] = useState<EnrollmentRecord[]>([
    { id: 1, studentId: 1, studentName: 'Aarav Patel', enrollmentNo: 'EN2024CS01', subjectId: 1, subjectCode: 'CS401', subjectName: 'Database Management Systems', academicYear: '2025-2026' },
    { id: 2, studentId: 1, studentName: 'Aarav Patel', enrollmentNo: 'EN2024CS01', subjectId: 2, subjectCode: 'CS402', subjectName: 'Operating Systems', academicYear: '2025-2026' },
    { id: 3, studentId: 2, studentName: 'Diya Sharma', enrollmentNo: 'EN2024CS02', subjectId: 1, subjectCode: 'CS401', subjectName: 'Database Management Systems', academicYear: '2025-2026' },
    { id: 4, studentId: 3, studentName: 'Rahul Verma', enrollmentNo: 'EN2024CS03', subjectId: 1, subjectCode: 'CS401', subjectName: 'Database Management Systems', academicYear: '2025-2026' },
    { id: 5, studentId: 4, studentName: 'Ananya Gupta', enrollmentNo: 'EN2024CS04', subjectId: 1, subjectCode: 'CS401', subjectName: 'Database Management Systems', academicYear: '2025-2026' },
    { id: 6, studentId: 5, studentName: 'Rohan Mehta', enrollmentNo: 'EN2024CS05', subjectId: 1, subjectCode: 'CS401', subjectName: 'Database Management Systems', academicYear: '2025-2026' },
    { id: 7, studentId: 6, studentName: 'Isha Sen', enrollmentNo: 'EN2024CS06', subjectId: 1, subjectCode: 'CS401', subjectName: 'Database Management Systems', academicYear: '2025-2026' }
  ]);

  const [attendanceList, setAttendanceList] = useState<AttendanceSession[]>([
    { subjectId: 1, subjectCode: 'CS401', subjectName: 'Database Management Systems', studentId: 1, studentName: 'Aarav Patel', enrollmentNo: 'EN2024CS01', totalClasses: 10, attended: 9, percentage: 90.0 },
    { subjectId: 1, subjectCode: 'CS401', subjectName: 'Database Management Systems', studentId: 2, studentName: 'Diya Sharma', enrollmentNo: 'EN2024CS02', totalClasses: 10, attended: 10, percentage: 100.0 },
    { subjectId: 1, subjectCode: 'CS401', subjectName: 'Database Management Systems', studentId: 3, studentName: 'Rahul Verma', enrollmentNo: 'EN2024CS03', totalClasses: 10, attended: 6, percentage: 60.0 },
    { subjectId: 1, subjectCode: 'CS401', subjectName: 'Database Management Systems', studentId: 4, studentName: 'Ananya Gupta', enrollmentNo: 'EN2024CS04', totalClasses: 10, attended: 8, percentage: 80.0 },
    { subjectId: 1, subjectCode: 'CS401', subjectName: 'Database Management Systems', studentId: 5, studentName: 'Rohan Mehta', enrollmentNo: 'EN2024CS05', totalClasses: 10, attended: 5, percentage: 50.0 },
    { subjectId: 1, subjectCode: 'CS401', subjectName: 'Database Management Systems', studentId: 6, studentName: 'Isha Sen', enrollmentNo: 'EN2024CS06', totalClasses: 10, attended: 9, percentage: 90.0 }
  ]);

  const [marksList] = useState<MarksRecord[]>([
    { studentId: 1, studentName: 'Aarav Patel', enrollmentNo: 'EN2024CS01', subjectId: 1, subjectCode: 'CS401', subjectName: 'Database Management Systems', assignment: 18, internal: 26.5, practical: 18.5, endSem: 44, total: 107, grade: 'A+' },
    { studentId: 1, studentName: 'Aarav Patel', enrollmentNo: 'EN2024CS01', subjectId: 2, subjectCode: 'CS402', subjectName: 'Operating Systems', assignment: 17.5, internal: 25, practical: 17, endSem: 42, total: 101.5, grade: 'A' },
    { studentId: 2, studentName: 'Diya Sharma', enrollmentNo: 'EN2024CS02', subjectId: 1, subjectCode: 'CS401', subjectName: 'Database Management Systems', assignment: 19.5, internal: 29, practical: 19.5, endSem: 48, total: 116, grade: 'A+' },
    { studentId: 3, studentName: 'Rahul Verma', enrollmentNo: 'EN2024CS03', subjectId: 1, subjectCode: 'CS401', subjectName: 'Database Management Systems', assignment: 8, internal: 11, practical: 7.5, endSem: 19, total: 45.5, grade: 'F' },
    { studentId: 4, studentName: 'Ananya Gupta', enrollmentNo: 'EN2024CS04', subjectId: 1, subjectCode: 'CS401', subjectName: 'Database Management Systems', assignment: 15, internal: 22, practical: 16, endSem: 38, total: 91, grade: 'B' },
    { studentId: 5, studentName: 'Rohan Mehta', enrollmentNo: 'EN2024CS05', subjectId: 1, subjectCode: 'CS401', subjectName: 'Database Management Systems', assignment: 10, internal: 14, practical: 10, endSem: 24, total: 58, grade: 'D' }
  ]);

  const [fees, setFees] = useState<FeeRecord[]>([
    { id: 1, studentId: 1, studentName: 'Aarav Patel', enrollmentNo: 'EN2024CS01', deptCode: 'CSE', semester: 4, total: 50000, paid: 50000, pending: 0, status: 'PAID', dueDate: '2026-01-15' },
    { id: 2, studentId: 2, studentName: 'Diya Sharma', enrollmentNo: 'EN2024CS02', deptCode: 'CSE', semester: 4, total: 50000, paid: 50000, pending: 0, status: 'PAID', dueDate: '2026-01-15' },
    { id: 3, studentId: 3, studentName: 'Rahul Verma', enrollmentNo: 'EN2024CS03', deptCode: 'CSE', semester: 4, total: 50000, paid: 20000, pending: 30000, status: 'PARTIAL', dueDate: '2026-01-15' },
    { id: 4, studentId: 4, studentName: 'Ananya Gupta', enrollmentNo: 'EN2024CS04', deptCode: 'CSE', semester: 4, total: 50000, paid: 50000, pending: 0, status: 'PAID', dueDate: '2026-01-15' },
    { id: 5, studentId: 5, studentName: 'Rohan Mehta', enrollmentNo: 'EN2024CS05', deptCode: 'CSE', semester: 4, total: 50000, paid: 0, pending: 50000, status: 'PENDING', dueDate: '2026-01-15' },
    { id: 6, studentId: 8, studentName: 'Aditya Joshi', enrollmentNo: 'EN2024IT02', deptCode: 'IT', semester: 4, total: 48500, paid: 25000, pending: 23500, status: 'PARTIAL', dueDate: '2026-01-15' },
    { id: 7, studentId: 10, studentName: 'Sameer Khan', enrollmentNo: 'EN2024IT04', deptCode: 'IT', semester: 4, total: 48500, paid: 15000, pending: 33500, status: 'PARTIAL', dueDate: '2026-01-15' }
  ]);

  const [leaves, setLeaves] = useState<LeaveRecord[]>([
    { id: 1, studentId: 1, studentName: 'Aarav Patel', enrollmentNo: 'EN2024CS01', fromDate: '2026-03-12', toDate: '2026-03-12', reason: 'Viral fever, medical certificate submitted', status: 'APPROVED', appliedDate: '2026-03-11', reviewerRemarks: 'Medical certificate verified. Approved.' },
    { id: 2, studentId: 6, studentName: 'Isha Sen', enrollmentNo: 'EN2024CS06', fromDate: '2026-03-20', toDate: '2026-03-21', reason: 'Family ceremony attendance', status: 'APPROVED', appliedDate: '2026-03-18', reviewerRemarks: 'Family event leave granted.' },
    { id: 3, studentId: 3, studentName: 'Rahul Verma', enrollmentNo: 'EN2024CS03', fromDate: '2026-03-25', toDate: '2026-03-28', reason: 'Inter-college tech symposium participation', status: 'PENDING', appliedDate: '2026-03-24' },
    { id: 4, studentId: 5, studentName: 'Rohan Mehta', enrollmentNo: 'EN2024CS05', fromDate: '2026-03-26', toDate: '2026-03-30', reason: 'Personal travel', status: 'REJECTED', appliedDate: '2026-03-23', reviewerRemarks: 'Cannot grant personal leave during mid-term examination week.' }
  ]);

  // Modal / Drawer States
  const [showAddStudentModal, setShowAddStudentModal] = useState(false);
  const [viewProfileStudentId, setViewProfileStudentId] = useState<number | null>(null);
  const [showPayModal, setShowPayModal] = useState<number | null>(null);
  const [payAmountInput, setPayAmountInput] = useState<number>(10000);
  const [riskAlertSentStudentId, setRiskAlertSentStudentId] = useState<number | null>(null);

  // New Student Form State
  const [newStudent, setNewStudent] = useState({
    name: '',
    enrollmentNo: '',
    email: '',
    phone: '',
    gender: 'MALE' as 'MALE' | 'FEMALE' | 'OTHER',
    dob: '2004-01-01',
    address: '',
    deptId: 1,
    deptCode: 'CSE',
    semester: 1,
    admissionYear: 2026,
  });

  // Filters
  const [studentDeptFilter, setStudentDeptFilter] = useState('');
  const [studentStatusFilter, setStudentStatusFilter] = useState('');

  // Attendance Marking Interactive State
  const [attSelectedSubject, setAttSelectedSubject] = useState<number>(1);
  const [attSelectedDate, setAttSelectedDate] = useState<string>('2026-03-30');
  const [attCheckboxes, setAttCheckboxes] = useState<Record<number, boolean>>({
    1: true, 2: true, 3: false, 4: true, 5: false, 6: true
  });

  // SQL Console Interactive State
  const [sqlQuery, setSqlQuery] = useState<string>('SELECT * FROM students WHERE status = "ACTIVE" ORDER BY student_id DESC;');
  const [sqlResult, setSqlResult] = useState<any[] | null>(null);

  // Trigger Toast Notification
  const showToast = (msg: string) => {
    setToastMessage(msg);
    setTimeout(() => setToastMessage(null), 3500);
  };

  // Filtered Students
  const filteredStudents = useMemo(() => {
    return students.filter(s => {
      const matchQuery = !globalSearch || 
        s.name.toLowerCase().includes(globalSearch.toLowerCase()) ||
        s.enrollmentNo.toLowerCase().includes(globalSearch.toLowerCase()) ||
        s.email.toLowerCase().includes(globalSearch.toLowerCase()) ||
        s.deptCode.toLowerCase().includes(globalSearch.toLowerCase());
      const matchDept = !studentDeptFilter || s.deptCode === studentDeptFilter;
      const matchStatus = !studentStatusFilter || s.status === studentStatusFilter;
      return matchQuery && matchDept && matchStatus;
    });
  }, [students, globalSearch, studentDeptFilter, studentStatusFilter]);

  // Omni-Search Categorized Results
  const searchResults = useMemo(() => {
    const q = globalSearch.trim().toLowerCase();
    if (!q) return null;

    const matchedStudents = students.filter(s =>
      s.name.toLowerCase().includes(q) ||
      s.enrollmentNo.toLowerCase().includes(q) ||
      s.email.toLowerCase().includes(q) ||
      s.deptCode.toLowerCase().includes(q)
    );

    const matchedFaculty = faculty.filter(f =>
      f.name.toLowerCase().includes(q) ||
      f.empId.toLowerCase().includes(q) ||
      f.deptCode.toLowerCase().includes(q) ||
      f.designation.toLowerCase().includes(q)
    );

    const matchedSubjects = subjects.filter(sub =>
      sub.code.toLowerCase().includes(q) ||
      sub.name.toLowerCase().includes(q) ||
      sub.deptCode.toLowerCase().includes(q)
    );

    const matchedDepartments = departments.filter(d =>
      d.code.toLowerCase().includes(q) ||
      d.name.toLowerCase().includes(q)
    );

    const total = matchedStudents.length + matchedFaculty.length + matchedSubjects.length + matchedDepartments.length;

    return {
      students: matchedStudents,
      faculty: matchedFaculty,
      subjects: matchedSubjects,
      departments: matchedDepartments,
      total
    };
  }, [globalSearch, students, faculty, subjects, departments]);

  // Handle Search Submit / Button Click
  const handleSearchSubmit = (e?: React.FormEvent) => {
    if (e) e.preventDefault();
    if (!globalSearch.trim()) return;
    setIsSearchOpen(false);
    setCurrentModule('students');
    showToast(`🔍 Showing ${filteredStudents.length} student results for "${globalSearch}"`);
  };

  // Academic Risk Filter
  const riskStudents = useMemo(() => {
    return students.filter(s => s.attendancePct < 75.0 || (s.avgMarks > 0 && s.avgMarks < 60.0) || s.pendingFees > 0);
  }, [students]);

  // Handle Add Student Submit
  const handleAddStudentSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!newStudent.name || !newStudent.enrollmentNo || !newStudent.email) {
      showToast('⚠️ Please fill in all required fields.');
      return;
    }

    const deptObj = departments.find(d => d.id === Number(newStudent.deptId)) || departments[0];

    const studentToAdd: StudentRecord = {
      id: Date.now(),
      enrollmentNo: newStudent.enrollmentNo.toUpperCase(),
      name: newStudent.name,
      email: newStudent.email,
      phone: newStudent.phone || '9876500000',
      gender: newStudent.gender,
      dob: newStudent.dob,
      address: newStudent.address || 'Campus Residence',
      deptId: deptObj.id,
      deptCode: deptObj.code,
      semester: Number(newStudent.semester),
      admissionYear: Number(newStudent.admissionYear),
      status: 'ACTIVE',
      attendancePct: 100.0,
      avgMarks: 0.0,
      pendingFees: 50000
    };

    setStudents(prev => [studentToAdd, ...prev]);
    
    setFees(prev => [{
      id: Date.now(),
      studentId: studentToAdd.id,
      studentName: studentToAdd.name,
      enrollmentNo: studentToAdd.enrollmentNo,
      deptCode: studentToAdd.deptCode,
      semester: studentToAdd.semester,
      total: 50000,
      paid: 0,
      pending: 50000,
      status: 'PENDING',
      dueDate: '2026-05-30'
    }, ...prev]);

    setShowAddStudentModal(false);
    showToast(`✅ Student ${studentToAdd.name} enrolled successfully!`);
    setNewStudent({
      name: '',
      enrollmentNo: '',
      email: '',
      phone: '',
      gender: 'MALE',
      dob: '2004-01-01',
      address: '',
      deptId: 1,
      deptCode: 'CSE',
      semester: 1,
      admissionYear: 2026,
    });
  };

  // Handle Attendance Save
  const handleSaveAttendance = () => {
    setAttendanceList(prev => prev.map(item => {
      if (item.subjectId === attSelectedSubject) {
        const isPresent = attCheckboxes[item.studentId] !== false;
        const newTotal = item.totalClasses + 1;
        const newAttended = isPresent ? item.attended + 1 : item.attended;
        const newPct = Math.round((newAttended / newTotal * 100.0) * 10.0) / 10.0;
        return {
          ...item,
          totalClasses: newTotal,
          attended: newAttended,
          percentage: newPct
        };
      }
      return item;
    }));

    setStudents(prev => prev.map(s => {
      const isPresent = attCheckboxes[s.id] !== false;
      const curAtt = attendanceList.find(a => a.studentId === s.id && a.subjectId === attSelectedSubject);
      if (curAtt) {
        const newTotal = curAtt.totalClasses + 1;
        const newAttended = isPresent ? curAtt.attended + 1 : curAtt.attended;
        return {
          ...s,
          attendancePct: Math.round((newAttended / newTotal * 100.0) * 10.0) / 10.0
        };
      }
      return s;
    }));

    showToast(`✅ Attendance recorded for ${attSelectedDate} & updated in database.`);
  };

  // Handle Fee Payment
  const handlePayFee = (feeId: number) => {
    setFees(prev => prev.map(f => {
      if (f.id === feeId) {
        const newPaid = f.paid + payAmountInput;
        const newPending = Math.max(0, f.total - newPaid);
        const newStatus = newPending === 0 ? 'PAID' : 'PARTIAL';
        return { ...f, paid: newPaid, pending: newPending, status: newStatus };
      }
      return f;
    }));

    const currentFee = fees.find(f => f.id === feeId);
    if (currentFee) {
      setStudents(prev => prev.map(s => {
        if (s.id === currentFee.studentId) {
          const newPending = Math.max(0, s.pendingFees - payAmountInput);
          return { ...s, pendingFees: newPending };
        }
        return s;
      }));
    }

    setShowPayModal(null);
    showToast(`💳 Payment of ₹${payAmountInput.toLocaleString()} recorded successfully!`);
  };

  // Handle Leave Status
  const handleUpdateLeaveStatus = (leaveId: number, newStatus: 'APPROVED' | 'REJECTED') => {
    setLeaves(prev => prev.map(l => {
      if (l.id === leaveId) {
        return {
          ...l,
          status: newStatus,
          reviewerRemarks: newStatus === 'APPROVED' ? 'Approved by Academic Office.' : 'Declined per departmental policy.'
        };
      }
      return l;
    }));
    showToast(`Leave request ${newStatus.toLowerCase()} successfully.`);
  };

  // Send Academic Risk Alert Notice
  const handleSendRiskNotice = (student: StudentRecord) => {
    setRiskAlertSentStudentId(student.id);
    setTimeout(() => {
      setRiskAlertSentStudentId(null);
      showToast(`📩 Formal Academic Advisory Notice dispatched to ${student.email}`);
    }, 1200);
  };

  // Run Mock/Live SQL
  const handleRunSQL = () => {
    const q = sqlQuery.toLowerCase();
    if (q.includes('students')) {
      setSqlResult(students.slice(0, 8));
    } else if (q.includes('faculty')) {
      setSqlResult(faculty);
    } else if (q.includes('departments')) {
      setSqlResult(departments);
    } else if (q.includes('fees') || q.includes('student_fees')) {
      setSqlResult(fees);
    } else {
      setSqlResult(students.slice(0, 5));
    }
    showToast('⚡ Query executed successfully (0.003s)');
  };

  // Navigation Items
  const navItems = [
    { id: 'dashboard', label: 'Dashboard', icon: Layers },
    { id: 'students', label: 'Students', icon: Users, count: students.length },
    { id: 'academic-risk', label: 'Risk Radar', icon: AlertTriangle, badge: riskStudents.length, badgeColor: 'bg-rose-100 text-rose-700 border border-rose-200' },
    { id: 'attendance', label: 'Attendance', icon: CalendarCheck },
    { id: 'marks', label: 'Exams & Grades', icon: Award },
    { id: 'fees', label: 'Fees & Finance', icon: CreditCard },
    { id: 'leaves', label: 'Leave Desk', icon: FileText, badge: leaves.filter(l => l.status === 'PENDING').length, badgeColor: 'bg-amber-100 text-amber-800 border border-amber-200' },
    { divider: true, label: 'Academic Structure' },
    { id: 'departments', label: 'Departments', icon: Building, count: departments.length },
    { id: 'faculty', label: 'Faculty Directory', icon: GraduationCap, count: faculty.length },
    { id: 'subjects', label: 'Courses & Curriculum', icon: BookOpen, count: subjects.length },
    { id: 'enrollments', label: 'Course Registrations', icon: BookMarked },
    { divider: true, label: 'Analytics & Tools' },
    { id: 'reports', label: 'Academic Insights', icon: PieChart },
    { id: 'sql-console', label: 'SQL Studio', icon: Terminal },
  ];

  // Active Profile Student Data
  const profileStudent = viewProfileStudentId ? students.find(s => s.id === viewProfileStudentId) : null;
  const profileStudentFees = profileStudent ? fees.filter(f => f.studentId === profileStudent.id) : [];
  const profileStudentMarks = profileStudent ? marksList.filter(m => m.studentId === profileStudent.id) : [];
  const profileStudentAttendance = profileStudent ? attendanceList.filter(a => a.studentId === profileStudent.id) : [];

  return (
    <div className="min-h-screen bg-[#f8fafc] text-slate-800 flex flex-col font-sans selection:bg-[#009f9f] selection:text-white">
      
      {/* ========================================================================= */}
      {/* TOP HEADER: BRANDING, SEARCH, LIVE DB STATUS, ROLE SWITCHER & CONTROLS    */}
      {/* ========================================================================= */}
      <header className="sticky top-0 z-40 bg-white/95 backdrop-blur-md border-b border-slate-200/90 px-4 sm:px-6 py-3 shadow-xs">
        <div className="max-w-[1600px] mx-auto flex items-center justify-between gap-4">
          
          {/* Logo & Brand */}
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl bg-[#009f9f] flex items-center justify-center text-white shadow-md shadow-[#009f9f]/25 border border-[#009f9f]/30">
              <GraduationCap className="w-6 h-6" />
            </div>
            <div>
              <div className="flex items-center gap-2">
                <span className="font-bold text-base tracking-tight text-slate-900 flex items-center gap-1.5">
                  EduPulse <span className="text-[#009f9f] font-extrabold text-sm px-1.5 py-0.5 rounded bg-[#ecfeff] border border-[#a5f3fc]">SIS</span>
                </span>
                <span className="text-[11px] font-medium text-slate-500 hidden sm:inline-block">Smart College ERP</span>
              </div>
              <p className="text-[11px] text-slate-500">Academic Administration & Student Information System</p>
            </div>
          </div>

          {/* Quick Search with Interactive Search Button & Omni-Results Dropdown */}
          <div className="relative flex-1 max-w-lg hidden md:block">
            <form onSubmit={handleSearchSubmit} className="relative flex items-center">
              <Search className="w-4 h-4 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2 pointer-events-none" />
              <input
                type="text"
                value={globalSearch}
                onFocus={() => setIsSearchOpen(true)}
                onChange={(e) => {
                  setGlobalSearch(e.target.value);
                  setIsSearchOpen(true);
                }}
                placeholder="Search students, faculty, enrollment #, course..."
                className="w-full bg-slate-50 border border-slate-200 rounded-xl pl-9 pr-24 py-1.5 text-xs text-slate-800 placeholder-slate-400 focus:outline-none focus:bg-white focus:border-[#009f9f] focus:ring-1 focus:ring-[#009f9f] transition shadow-2xs"
              />
              <div className="absolute right-1.5 top-1/2 -translate-y-1/2 flex items-center gap-1">
                {globalSearch && (
                  <button
                    type="button"
                    onClick={() => {
                      setGlobalSearch('');
                      setIsSearchOpen(false);
                    }}
                    className="p-1 text-slate-400 hover:text-slate-700 cursor-pointer"
                    title="Clear search"
                  >
                    <X className="w-3.5 h-3.5" />
                  </button>
                )}
                <button
                  type="submit"
                  className="inline-flex items-center gap-1 px-2.5 py-1 bg-[#009f9f] hover:bg-[#008787] active:scale-95 text-white text-[11px] font-semibold rounded-lg shadow-2xs transition cursor-pointer"
                  title="Submit Search"
                >
                  <Search className="w-3 h-3" />
                  <span>Search</span>
                </button>
              </div>
            </form>

            {/* Omni-Search Live Dropdown */}
            {isSearchOpen && searchResults && (
              <div className="absolute left-0 right-0 top-full mt-2 bg-white border border-slate-200 rounded-xl shadow-xl z-50 overflow-hidden text-xs divide-y divide-slate-100 max-h-[420px] overflow-y-auto animate-in fade-in duration-100">
                <div className="p-2.5 bg-slate-50 flex items-center justify-between text-[11px]">
                  <span className="font-semibold text-slate-600">
                    Search Results ({searchResults.total} matches for "{globalSearch}")
                  </span>
                  <button
                    type="button"
                    onClick={() => setIsSearchOpen(false)}
                    className="text-slate-400 hover:text-slate-700 cursor-pointer font-medium"
                  >
                    Close (Esc)
                  </button>
                </div>

                {searchResults.total === 0 ? (
                  <div className="p-4 text-center text-slate-500">
                    No students, faculty, or courses matching "{globalSearch}".
                  </div>
                ) : (
                  <>
                    {/* Matching Students */}
                    {searchResults.students.length > 0 && (
                      <div className="p-2">
                        <div className="px-2 py-1 text-[10px] font-bold uppercase text-slate-400 tracking-wider">
                          Students ({searchResults.students.length})
                        </div>
                        <div className="space-y-0.5">
                          {searchResults.students.slice(0, 4).map(s => (
                            <div
                              key={s.id}
                              onClick={() => {
                                setIsSearchOpen(false);
                                setCurrentModule('students');
                                setViewProfileStudentId(s.id);
                              }}
                              className="p-2 hover:bg-[#ecfeff]/60 rounded-lg flex items-center justify-between cursor-pointer transition"
                            >
                              <div>
                                <span className="font-bold text-slate-900">{s.name}</span>
                                <span className="text-[11px] text-slate-500 ml-1.5 font-mono">({s.enrollmentNo})</span>
                                <div className="text-[10px] text-slate-400">{s.deptCode} • Sem {s.semester} • Attendance: {s.attendancePct}%</div>
                              </div>
                              <span className="text-[#009f9f] font-semibold text-[11px] hover:underline">
                                View Profile &rarr;
                              </span>
                            </div>
                          ))}
                        </div>
                      </div>
                    )}

                    {/* Matching Faculty */}
                    {searchResults.faculty.length > 0 && (
                      <div className="p-2">
                        <div className="px-2 py-1 text-[10px] font-bold uppercase text-slate-400 tracking-wider">
                          Faculty ({searchResults.faculty.length})
                        </div>
                        <div className="space-y-0.5">
                          {searchResults.faculty.slice(0, 3).map(f => (
                            <div
                              key={f.id}
                              onClick={() => {
                                setIsSearchOpen(false);
                                setCurrentModule('faculty');
                              }}
                              className="p-2 hover:bg-slate-50 rounded-lg flex items-center justify-between cursor-pointer transition"
                            >
                              <div>
                                <span className="font-bold text-slate-900">{f.name}</span>
                                <div className="text-[10px] text-slate-500">{f.designation} • {f.deptCode}</div>
                              </div>
                              <span className="text-slate-500 text-[11px]">Faculty &rarr;</span>
                            </div>
                          ))}
                        </div>
                      </div>
                    )}

                    {/* Matching Courses */}
                    {searchResults.subjects.length > 0 && (
                      <div className="p-2">
                        <div className="px-2 py-1 text-[10px] font-bold uppercase text-slate-400 tracking-wider">
                          Courses ({searchResults.subjects.length})
                        </div>
                        <div className="space-y-0.5">
                          {searchResults.subjects.slice(0, 3).map(sub => (
                            <div
                              key={sub.id}
                              onClick={() => {
                                setIsSearchOpen(false);
                                setCurrentModule('subjects');
                              }}
                              className="p-2 hover:bg-slate-50 rounded-lg flex items-center justify-between cursor-pointer transition"
                            >
                              <div>
                                <span className="font-mono font-bold text-[#009f9f]">{sub.code}</span> - <span className="font-semibold text-slate-900">{sub.name}</span>
                                <div className="text-[10px] text-slate-500">{sub.deptCode} • {sub.credits} Credits</div>
                              </div>
                              <span className="text-slate-500 text-[11px]">Courses &rarr;</span>
                            </div>
                          ))}
                        </div>
                      </div>
                    )}

                    {/* Footer Quick Action */}
                    <div className="p-2 bg-slate-50 text-center">
                      <button
                        type="button"
                        onClick={handleSearchSubmit}
                        className="text-[#009f9f] hover:text-[#007070] font-semibold text-xs cursor-pointer inline-flex items-center gap-1"
                      >
                        <span>View all matching results in Students directory</span>
                        <ChevronRight className="w-3.5 h-3.5" />
                      </button>
                    </div>
                  </>
                )}
              </div>
            )}
          </div>

          {/* Right Status Indicators & User Controls */}
          <div className="flex items-center gap-2.5">
            {/* Live Database Sync Indicator */}
            <div className="hidden lg:flex items-center gap-2 px-3 py-1.5 rounded-lg bg-emerald-50 border border-emerald-200 text-emerald-700 text-xs font-medium">
              <span className="w-2 h-2 rounded-full bg-emerald-500 animate-pulse" />
              <span>MySQL 8.0 Connected</span>
            </div>

            {/* Quick Add Action */}
            <button
              onClick={() => {
                setCurrentModule('students');
                setShowAddStudentModal(true);
              }}
              className="inline-flex items-center gap-1.5 px-3.5 py-1.5 bg-[#009f9f] hover:bg-[#008787] active:scale-95 text-white text-xs font-semibold rounded-lg shadow-sm shadow-[#009f9f]/30 transition cursor-pointer"
            >
              <Plus className="w-3.5 h-3.5" />
              <span className="hidden sm:inline">Add Student</span>
            </button>

            {/* Role Switcher Pill */}
            <div className="flex items-center bg-slate-100 border border-slate-200 p-0.5 rounded-lg">
              <button
                onClick={() => {
                  setCurrentRole('ADMIN');
                  showToast('Switched to Administrator Workspace');
                }}
                className={`px-2.5 py-1 text-xs font-semibold rounded-md transition cursor-pointer ${
                  currentRole === 'ADMIN'
                    ? 'bg-white text-[#009f9f] shadow-xs'
                    : 'text-slate-500 hover:text-slate-800'
                }`}
              >
                Admin
              </button>
              <button
                onClick={() => {
                  setCurrentRole('FACULTY');
                  showToast('Switched to Faculty Portal');
                }}
                className={`px-2.5 py-1 text-xs font-semibold rounded-md transition cursor-pointer ${
                  currentRole === 'FACULTY'
                    ? 'bg-white text-[#009f9f] shadow-xs'
                    : 'text-slate-500 hover:text-slate-800'
                }`}
              >
                Faculty
              </button>
            </div>

            {/* Developer / Project Tools Modal Trigger */}
            <button
              onClick={() => setShowDevConsole(true)}
              title="System & Developer Tools"
              className="p-2 text-slate-500 hover:text-[#009f9f] bg-slate-50 hover:bg-slate-100 border border-slate-200 rounded-lg transition cursor-pointer"
            >
              <Sliders className="w-4 h-4 text-[#009f9f]" />
            </button>
          </div>
        </div>
      </header>

      {/* Toast Notification Banner */}
      {toastMessage && (
        <div className="fixed bottom-6 right-6 z-50 flex items-center gap-2.5 px-4 py-3 bg-white border border-[#009f9f]/40 text-slate-800 text-xs font-medium rounded-xl shadow-xl animate-in fade-in slide-in-from-bottom-3 duration-200">
          <Sparkles className="w-4 h-4 text-[#009f9f] shrink-0" />
          <span>{toastMessage}</span>
        </div>
      )}

      {/* ========================================================================= */}
      {/* MAIN BODY: SIDEBAR NAVIGATION + CONTENT AREA                              */}
      {/* ========================================================================= */}
      <div className="flex-1 max-w-[1600px] w-full mx-auto p-4 sm:p-6 flex flex-col lg:flex-row gap-6">
        
        {/* SIDEBAR NAVIGATION */}
        <aside className="w-full lg:w-64 shrink-0 flex flex-col">
          <div className="bg-white border border-slate-200 rounded-2xl p-3.5 shadow-sm sticky top-20">
            
            {/* User Profile Card in Sidebar */}
            <div className="p-3 mb-3 bg-[#f0fdfa] rounded-xl border border-[#ccfbf1] flex items-center justify-between">
              <div className="flex items-center gap-2.5">
                <div className="w-8 h-8 rounded-lg bg-[#009f9f] flex items-center justify-center font-bold text-white text-xs shadow-xs">
                  {currentRole === 'ADMIN' ? 'AD' : 'FC'}
                </div>
                <div>
                  <div className="text-xs font-bold text-slate-900">
                    {currentRole === 'ADMIN' ? 'Administrator' : 'Dr. Rajesh Sharma'}
                  </div>
                  <div className="text-[10px] text-slate-500">
                    {currentRole === 'ADMIN' ? 'Super Admin' : 'HOD • Computer Science'}
                  </div>
                </div>
              </div>
              <span className="inline-block w-2 h-2 rounded-full bg-[#009f9f]" />
            </div>

            {/* Nav Menu */}
            <nav className="space-y-0.5 text-xs">
              {navItems.map((item, idx) => {
                if (item.divider) {
                  return (
                    <div key={idx} className="pt-3 pb-1.5 px-3 text-[10px] font-bold text-slate-400 uppercase tracking-wider">
                      {item.label}
                    </div>
                  );
                }

                const Icon = item.icon!;
                const isActive = currentModule === item.id;

                return (
                  <button
                    key={item.id}
                    onClick={() => {
                      setCurrentModule(item.id!);
                      setViewProfileStudentId(null);
                    }}
                    className={`w-full flex items-center justify-between px-3 py-2 rounded-xl font-medium transition cursor-pointer ${
                      isActive
                        ? 'bg-[#009f9f] text-white font-semibold shadow-sm shadow-[#009f9f]/30'
                        : 'text-slate-600 hover:bg-slate-100 hover:text-slate-900'
                    }`}
                  >
                    <div className="flex items-center gap-2.5">
                      <Icon className={`w-4 h-4 ${isActive ? 'text-white' : 'text-slate-400'}`} />
                      <span>{item.label}</span>
                    </div>
                    {item.badge !== undefined && item.badge > 0 && (
                      <span className={`px-1.5 py-0.5 rounded-full text-[10px] font-bold ${item.badgeColor || 'bg-[#ccfbf1] text-[#007070]'}`}>
                        {item.badge}
                      </span>
                    )}
                    {item.count !== undefined && (
                      <span className={`text-[10px] font-mono ${isActive ? 'text-white/80' : 'text-slate-400'}`}>
                        {item.count}
                      </span>
                    )}
                  </button>
                );
              })}
            </nav>
          </div>
        </aside>

        {/* MAIN CONTENT AREA */}
        <main className="flex-1 min-w-0 bg-white border border-slate-200 rounded-2xl p-5 sm:p-7 shadow-sm">
          
          {/* ========================================================================= */}
          {/* VIEW: EXECUTIVE DASHBOARD                                                 */}
          {/* ========================================================================= */}
          {currentModule === 'dashboard' && (
            <div className="space-y-6">
              {/* Dashboard Header */}
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-4 border-b border-slate-200">
                <div>
                  <h1 className="text-xl font-bold text-slate-900 tracking-tight">Institutional Overview</h1>
                  <p className="text-xs text-slate-500">Live operational metrics, student welfare alerts, and academic analytics.</p>
                </div>
                <div className="flex items-center gap-2">
                  <button
                    onClick={() => setCurrentModule('attendance')}
                    className="px-3 py-1.5 bg-slate-50 hover:bg-slate-100 text-slate-700 border border-slate-200 rounded-lg text-xs font-semibold flex items-center gap-1.5 transition cursor-pointer"
                  >
                    <CalendarCheck className="w-3.5 h-3.5 text-[#009f9f]" />
                    <span>Take Attendance</span>
                  </button>
                  <button
                    onClick={() => {
                      setCurrentModule('students');
                      setShowAddStudentModal(true);
                    }}
                    className="px-3.5 py-1.5 bg-[#009f9f] hover:bg-[#008787] text-white rounded-lg text-xs font-semibold flex items-center gap-1.5 shadow-sm shadow-[#009f9f]/20 transition cursor-pointer"
                  >
                    <Plus className="w-3.5 h-3.5" />
                    <span>Enroll Student</span>
                  </button>
                </div>
              </div>

              {/* 4 Core Metric KPI Cards */}
              <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
                <div className="bg-slate-50/60 border border-slate-200 rounded-xl p-4.5 hover:border-[#009f9f]/40 transition">
                  <div className="flex justify-between items-start">
                    <span className="text-[11px] font-semibold text-slate-500 uppercase tracking-wider">Total Students</span>
                    <div className="p-2 bg-[#ecfeff] text-[#009f9f] rounded-lg border border-[#a5f3fc]">
                      <Users className="w-4 h-4" />
                    </div>
                  </div>
                  <div className="text-2xl font-extrabold text-slate-900 mt-2">{students.length}</div>
                  <div className="flex items-center gap-1.5 mt-2 text-[11px] text-emerald-600 font-medium">
                    <CheckCircle className="w-3.5 h-3.5" />
                    <span>100% Verified Records</span>
                  </div>
                </div>

                <div className="bg-slate-50/60 border border-slate-200 rounded-xl p-4.5 hover:border-[#009f9f]/40 transition">
                  <div className="flex justify-between items-start">
                    <span className="text-[11px] font-semibold text-slate-500 uppercase tracking-wider">Faculty Members</span>
                    <div className="p-2 bg-emerald-50 text-emerald-600 rounded-lg border border-emerald-200">
                      <GraduationCap className="w-4 h-4" />
                    </div>
                  </div>
                  <div className="text-2xl font-extrabold text-slate-900 mt-2">{faculty.length}</div>
                  <div className="text-[11px] text-slate-500 mt-2">Across 5 Active Departments</div>
                </div>

                <div className="bg-slate-50/60 border border-slate-200 rounded-xl p-4.5 hover:border-[#009f9f]/40 transition">
                  <div className="flex justify-between items-start">
                    <span className="text-[11px] font-semibold text-slate-500 uppercase tracking-wider">Fee Collection</span>
                    <div className="p-2 bg-emerald-50 text-emerald-600 rounded-lg border border-emerald-200">
                      <DollarSign className="w-4 h-4" />
                    </div>
                  </div>
                  <div className="text-2xl font-extrabold text-slate-900 mt-2">
                    ₹{(fees.reduce((acc, f) => acc + f.paid, 0) / 1000).toFixed(1)}k
                  </div>
                  <div className="text-[11px] text-slate-500 mt-2">
                    Pending: ₹{(fees.reduce((acc, f) => acc + f.pending, 0) / 1000).toFixed(1)}k
                  </div>
                </div>

                <div className="bg-slate-50/60 border border-slate-200 rounded-xl p-4.5 hover:border-[#009f9f]/40 transition">
                  <div className="flex justify-between items-start">
                    <span className="text-[11px] font-semibold text-slate-500 uppercase tracking-wider">Attendance Health</span>
                    <div className="p-2 bg-[#ecfeff] text-[#009f9f] rounded-lg border border-[#a5f3fc]">
                      <Activity className="w-4 h-4" />
                    </div>
                  </div>
                  <div className="text-2xl font-extrabold text-slate-900 mt-2">
                    {(students.reduce((acc, s) => acc + s.attendancePct, 0) / students.length).toFixed(1)}%
                  </div>
                  <div className="text-[11px] text-slate-500 mt-2">Campus Average</div>
                </div>
              </div>

              {/* Attention / Risk Early Warning Banner */}
              <div className="bg-white border border-slate-200 rounded-xl overflow-hidden shadow-xs">
                <div className="p-4 bg-rose-50/70 border-b border-rose-100 flex items-center justify-between">
                  <div className="flex items-center gap-2.5 text-rose-700 font-semibold text-sm">
                    <AlertTriangle className="w-4 h-4 text-rose-500" />
                    <span>Academic Early Warning Radar ({riskStudents.length} Students Requiring Intervention)</span>
                  </div>
                  <button
                    onClick={() => setCurrentModule('academic-risk')}
                    className="text-xs text-rose-700 hover:text-rose-900 font-semibold flex items-center gap-1 cursor-pointer"
                  >
                    <span>View Risk Matrix</span>
                    <ChevronRight className="w-3.5 h-3.5" />
                  </button>
                </div>
                <div className="p-4 overflow-x-auto">
                  <table className="w-full text-xs text-left">
                    <thead>
                      <tr className="text-slate-500 border-b border-slate-200">
                        <th className="pb-2.5 font-semibold">Student</th>
                        <th className="pb-2.5 font-semibold">Department</th>
                        <th className="pb-2.5 font-semibold">Attendance</th>
                        <th className="pb-2.5 font-semibold">Average Marks</th>
                        <th className="pb-2.5 font-semibold">Fee Arrears</th>
                        <th className="pb-2.5 font-semibold text-right">Action</th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-slate-100">
                      {riskStudents.map(s => (
                        <tr key={s.id} className="hover:bg-slate-50 transition">
                          <td className="py-3 font-semibold text-slate-900">
                            <div>{s.name}</div>
                            <div className="text-[11px] text-slate-500 font-mono">{s.enrollmentNo}</div>
                          </td>
                          <td className="py-3 text-slate-600">{s.deptCode} (Sem {s.semester})</td>
                          <td className="py-3">
                            <span className={`px-2 py-0.5 rounded font-bold ${
                              s.attendancePct < 75 ? 'bg-rose-100 text-rose-700 border border-rose-200' : 'text-slate-600'
                            }`}>
                              {s.attendancePct}%
                            </span>
                          </td>
                          <td className="py-3">
                            <span className={s.avgMarks < 60 ? 'text-rose-600 font-semibold' : 'text-slate-600'}>
                              {s.avgMarks} / 120
                            </span>
                          </td>
                          <td className="py-3 text-rose-600 font-semibold">
                            {s.pendingFees > 0 ? `₹${s.pendingFees.toLocaleString()}` : 'Cleared'}
                          </td>
                          <td className="py-3 text-right">
                            <button
                              onClick={() => {
                                setCurrentModule('students');
                                setViewProfileStudentId(s.id);
                              }}
                              className="text-[#009f9f] hover:text-[#007070] font-semibold cursor-pointer"
                            >
                              View Profile &rarr;
                            </button>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </div>

              {/* Quick Summary Grid */}
              <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
                {/* Department Distribution */}
                <div className="bg-slate-50/50 border border-slate-200 rounded-xl p-4.5">
                  <h3 className="text-sm font-bold text-slate-900 mb-3 flex items-center gap-2">
                    <Building className="w-4 h-4 text-[#009f9f]" />
                    <span>Departmental Enrollment</span>
                  </h3>
                  <div className="space-y-3">
                    {departments.map(d => {
                      const deptStudents = students.filter(s => s.deptCode === d.code).length;
                      const pct = Math.round((deptStudents / students.length) * 100);
                      return (
                        <div key={d.id} className="space-y-1">
                          <div className="flex justify-between text-xs">
                            <span className="text-slate-700 font-medium">{d.name} ({d.code})</span>
                            <span className="text-slate-500 font-mono">{deptStudents} students ({pct}%)</span>
                          </div>
                          <div className="w-full bg-slate-200 h-1.5 rounded-full overflow-hidden">
                            <div className="bg-[#009f9f] h-full rounded-full transition-all duration-500" style={{ width: `${pct}%` }} />
                          </div>
                        </div>
                      );
                    })}
                  </div>
                </div>

                {/* Pending Leave Requests */}
                <div className="bg-slate-50/50 border border-slate-200 rounded-xl p-4.5">
                  <div className="flex justify-between items-center mb-3">
                    <h3 className="text-sm font-bold text-slate-900 flex items-center gap-2">
                      <FileText className="w-4 h-4 text-amber-500" />
                      <span>Pending Student Requests</span>
                    </h3>
                    <button
                      onClick={() => setCurrentModule('leaves')}
                      className="text-xs text-[#009f9f] hover:text-[#007070] font-semibold cursor-pointer"
                    >
                      View All ({leaves.length})
                    </button>
                  </div>
                  <div className="space-y-2.5">
                    {leaves.filter(l => l.status === 'PENDING').length === 0 ? (
                      <div className="text-xs text-slate-400 py-4 text-center">No pending leave applications.</div>
                    ) : (
                      leaves.filter(l => l.status === 'PENDING').map(l => (
                        <div key={l.id} className="p-3 bg-white border border-slate-200 rounded-lg flex items-center justify-between gap-3 shadow-2xs">
                          <div>
                            <div className="text-xs font-bold text-slate-900">{l.studentName}</div>
                            <div className="text-[11px] text-slate-500 line-clamp-1">{l.reason}</div>
                            <div className="text-[10px] text-slate-400 mt-0.5 font-mono">{l.fromDate} to {l.toDate}</div>
                          </div>
                          <div className="flex items-center gap-1.5">
                            <button
                              onClick={() => handleUpdateLeaveStatus(l.id, 'APPROVED')}
                              className="px-2.5 py-1 bg-emerald-50 hover:bg-emerald-100 text-emerald-700 border border-emerald-200 rounded text-xs font-semibold cursor-pointer"
                            >
                              Approve
                            </button>
                            <button
                              onClick={() => handleUpdateLeaveStatus(l.id, 'REJECTED')}
                              className="px-2.5 py-1 bg-rose-50 hover:bg-rose-100 text-rose-700 border border-rose-200 rounded text-xs font-semibold cursor-pointer"
                            >
                              Decline
                            </button>
                          </div>
                        </div>
                      ))
                    )}
                  </div>
                </div>
              </div>
            </div>
          )}

          {/* ========================================================================= */}
          {/* VIEW: STUDENTS DIRECTORY & MANAGEMENT                                     */}
          {/* ========================================================================= */}
          {currentModule === 'students' && (
            <div className="space-y-5">
              {/* Header & Controls */}
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-4 border-b border-slate-200">
                <div>
                  <h1 className="text-xl font-bold text-slate-900 tracking-tight">Student Directory</h1>
                  <p className="text-xs text-slate-500">Total {students.length} enrolled students across 5 departments.</p>
                </div>
                <div className="flex items-center gap-2">
                  <button
                    onClick={() => setShowAddStudentModal(true)}
                    className="px-3.5 py-1.5 bg-[#009f9f] hover:bg-[#008787] text-white rounded-lg text-xs font-semibold flex items-center gap-1.5 shadow-sm shadow-[#009f9f]/20 transition cursor-pointer"
                  >
                    <Plus className="w-3.5 h-3.5" />
                    <span>Add New Student</span>
                  </button>
                </div>
              </div>

              {/* Filters Bar */}
              <div className="flex flex-wrap items-center gap-3 bg-slate-50 border border-slate-200 p-3 rounded-xl">
                <div className="flex items-center gap-2 text-xs text-slate-500">
                  <Filter className="w-3.5 h-3.5 text-[#009f9f]" />
                  <span>Filter:</span>
                </div>
                <select
                  value={studentDeptFilter}
                  onChange={(e) => setStudentDeptFilter(e.target.value)}
                  className="bg-white border border-slate-200 rounded-lg px-2.5 py-1 text-xs text-slate-700 focus:outline-none focus:border-[#009f9f]"
                >
                  <option value="">All Departments</option>
                  {departments.map(d => (
                    <option key={d.code} value={d.code}>{d.name} ({d.code})</option>
                  ))}
                </select>

                <select
                  value={studentStatusFilter}
                  onChange={(e) => setStudentStatusFilter(e.target.value)}
                  className="bg-white border border-slate-200 rounded-lg px-2.5 py-1 text-xs text-slate-700 focus:outline-none focus:border-[#009f9f]"
                >
                  <option value="">All Statuses</option>
                  <option value="ACTIVE">Active</option>
                  <option value="SUSPENDED">Suspended</option>
                  <option value="GRADUATED">Graduated</option>
                </select>

                <div className="ml-auto text-xs text-slate-500">
                  Showing <span className="text-slate-900 font-bold">{filteredStudents.length}</span> of {students.length}
                </div>
              </div>

              {/* Students Table */}
              <div className="bg-white border border-slate-200 rounded-xl overflow-hidden shadow-2xs">
                <div className="overflow-x-auto">
                  <table className="w-full text-xs text-left">
                    <thead className="bg-slate-50 text-slate-600 font-semibold border-b border-slate-200">
                      <tr>
                        <th className="p-3">Student</th>
                        <th className="p-3">Contact</th>
                        <th className="p-3">Department</th>
                        <th className="p-3">Attendance</th>
                        <th className="p-3">Status</th>
                        <th className="p-3">Fee Due</th>
                        <th className="p-3 text-right">Actions</th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-slate-100">
                      {filteredStudents.map(s => (
                        <tr key={s.id} className="hover:bg-slate-50 transition">
                          <td className="p-3">
                            <div className="font-bold text-slate-900">{s.name}</div>
                            <div className="text-[11px] text-slate-500 font-mono">{s.enrollmentNo}</div>
                          </td>
                          <td className="p-3">
                            <div className="text-slate-700">{s.email}</div>
                            <div className="text-[11px] text-slate-400">{s.phone}</div>
                          </td>
                          <td className="p-3">
                            <span className="px-2 py-0.5 rounded bg-slate-100 text-slate-700 font-medium border border-slate-200">
                              {s.deptCode} • Sem {s.semester}
                            </span>
                          </td>
                          <td className="p-3">
                            <span className={`px-2 py-0.5 rounded font-bold ${
                              s.attendancePct < 75 ? 'bg-rose-100 text-rose-700 border border-rose-200' : 'bg-emerald-100 text-emerald-700'
                            }`}>
                              {s.attendancePct}%
                            </span>
                          </td>
                          <td className="p-3">
                            <span className={`px-2 py-0.5 rounded text-[10px] font-bold ${
                              s.status === 'ACTIVE' ? 'bg-emerald-100 text-emerald-700' : 'bg-rose-100 text-rose-700'
                            }`}>
                              {s.status}
                            </span>
                          </td>
                          <td className="p-3">
                            <span className={s.pendingFees > 0 ? 'text-rose-600 font-semibold' : 'text-emerald-600'}>
                              {s.pendingFees > 0 ? `₹${s.pendingFees.toLocaleString()}` : 'Cleared'}
                            </span>
                          </td>
                          <td className="p-3 text-right">
                            <div className="flex items-center justify-end gap-2">
                              <button
                                onClick={() => setViewProfileStudentId(s.id)}
                                className="px-2.5 py-1 bg-slate-100 hover:bg-slate-200 text-[#009f9f] rounded text-xs font-semibold cursor-pointer"
                              >
                                360° Profile
                              </button>
                            </div>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          )}

          {/* ========================================================================= */}
          {/* VIEW: ACADEMIC RISK RADAR                                                 */}
          {/* ========================================================================= */}
          {currentModule === 'academic-risk' && (
            <div className="space-y-5">
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-4 border-b border-slate-200">
                <div>
                  <h1 className="text-xl font-bold text-rose-600 tracking-tight flex items-center gap-2">
                    <AlertTriangle className="w-5 h-5 text-rose-500" />
                    <span>Academic Risk & Early Intervention Radar</span>
                  </h1>
                  <p className="text-xs text-slate-500">
                    Automated intelligence engine flagging students under threshold in Attendance (&lt;75%), Grades (&lt;50%), or Outstanding Fees.
                  </p>
                </div>
              </div>

              {/* Risk Policy Cards */}
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div className="p-3.5 bg-rose-50 border border-rose-200 rounded-xl">
                  <div className="text-xs font-bold text-rose-700">1. Attendance Shortage</div>
                  <div className="text-[11px] text-slate-600 mt-1">Students with attendance &lt; 75% are ineligible for semester exams.</div>
                </div>
                <div className="p-3.5 bg-amber-50 border border-amber-200 rounded-xl">
                  <div className="text-xs font-bold text-amber-700">2. Academic Underperformance</div>
                  <div className="text-[11px] text-slate-600 mt-1">Students scoring &lt; 50% average across assessments require remedial classes.</div>
                </div>
                <div className="p-3.5 bg-[#ecfeff] border border-[#a5f3fc] rounded-xl">
                  <div className="text-xs font-bold text-[#008282]">3. Fee Balances</div>
                  <div className="text-[11px] text-slate-600 mt-1">Unsettled fee balances require clearance prior to hall ticket generation.</div>
                </div>
              </div>

              {/* At-Risk Students Grid */}
              <div className="space-y-3">
                {riskStudents.map(s => {
                  const flags: string[] = [];
                  if (s.attendancePct < 75) flags.push(`Low Attendance (${s.attendancePct}%)`);
                  if (s.avgMarks < 60) flags.push(`Low Marks (${s.avgMarks}/120)`);
                  if (s.pendingFees > 0) flags.push(`Pending Fees (₹${s.pendingFees.toLocaleString()})`);

                  return (
                    <div key={s.id} className="p-4 bg-white border border-slate-200 hover:border-rose-300 rounded-xl transition flex flex-col md:flex-row md:items-center justify-between gap-4 shadow-2xs">
                      <div>
                        <div className="flex items-center gap-2">
                          <span className="font-bold text-sm text-slate-900">{s.name}</span>
                          <span className="text-xs font-mono text-slate-500">({s.enrollmentNo})</span>
                          <span className="px-2 py-0.5 bg-slate-100 text-slate-700 text-[10px] font-bold rounded">
                            {s.deptCode} • Sem {s.semester}
                          </span>
                        </div>
                        <div className="flex flex-wrap items-center gap-2 mt-2">
                          {flags.map((f, i) => (
                            <span key={i} className="px-2 py-0.5 rounded bg-rose-50 text-rose-700 border border-rose-200 text-[11px] font-semibold">
                              ⚠️ {f}
                            </span>
                          ))}
                        </div>
                      </div>

                      <div className="flex items-center gap-2">
                        <button
                          onClick={() => handleSendRiskNotice(s)}
                          disabled={riskAlertSentStudentId === s.id}
                          className="px-3 py-1.5 bg-rose-50 hover:bg-rose-100 text-rose-700 border border-rose-200 rounded-lg text-xs font-semibold flex items-center gap-1.5 transition cursor-pointer"
                        >
                          <Send className="w-3.5 h-3.5" />
                          <span>{riskAlertSentStudentId === s.id ? 'Dispatching...' : 'Dispatch Alert Notice'}</span>
                        </button>
                        <button
                          onClick={() => {
                            setCurrentModule('students');
                            setViewProfileStudentId(s.id);
                          }}
                          className="px-3 py-1.5 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-lg text-xs font-semibold cursor-pointer"
                        >
                          Review File
                        </button>
                      </div>
                    </div>
                  );
                })}
              </div>
            </div>
          )}

          {/* ========================================================================= */}
          {/* VIEW: ATTENDANCE DESK                                                     */}
          {/* ========================================================================= */}
          {currentModule === 'attendance' && (
            <div className="space-y-5">
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-4 border-b border-slate-200">
                <div>
                  <h1 className="text-xl font-bold text-slate-900 tracking-tight">Attendance Register</h1>
                  <p className="text-xs text-slate-500">Real-time class presence tracking with automated cumulative recalculation.</p>
                </div>
                <div className="flex items-center gap-2">
                  <button
                    onClick={handleSaveAttendance}
                    className="px-4 py-1.5 bg-[#009f9f] hover:bg-[#008787] text-white rounded-lg text-xs font-semibold flex items-center gap-1.5 shadow-md shadow-[#009f9f]/20 transition cursor-pointer"
                  >
                    <CheckCircle className="w-4 h-4" />
                    <span>Submit & Sync Attendance</span>
                  </button>
                </div>
              </div>

              {/* Class Selector Bar */}
              <div className="grid grid-cols-1 md:grid-cols-3 gap-3 bg-slate-50 border border-slate-200 p-3.5 rounded-xl">
                <div>
                  <label className="text-[11px] font-semibold text-slate-600 block mb-1">Subject / Course</label>
                  <select
                    value={attSelectedSubject}
                    onChange={(e) => setAttSelectedSubject(Number(e.target.value))}
                    className="w-full bg-white border border-slate-200 rounded-lg px-3 py-1.5 text-xs text-slate-700 focus:outline-none focus:border-[#009f9f]"
                  >
                    {subjects.map(sub => (
                      <option key={sub.id} value={sub.id}>
                        {sub.code} - {sub.name} ({sub.deptCode})
                      </option>
                    ))}
                  </select>
                </div>

                <div>
                  <label className="text-[11px] font-semibold text-slate-600 block mb-1">Session Date</label>
                  <input
                    type="date"
                    value={attSelectedDate}
                    onChange={(e) => setAttSelectedDate(e.target.value)}
                    className="w-full bg-white border border-slate-200 rounded-lg px-3 py-1.5 text-xs text-slate-700 focus:outline-none focus:border-[#009f9f]"
                  />
                </div>

                <div className="flex items-end">
                  <div className="w-full flex items-center justify-between p-2 bg-white rounded-lg border border-slate-200 text-xs">
                    <span className="text-slate-500">Quick Toggle:</span>
                    <button
                      onClick={() => {
                        const allTrue: Record<number, boolean> = {};
                        attendanceList.forEach(a => allTrue[a.studentId] = true);
                        setAttCheckboxes(allTrue);
                        showToast('All marked Present');
                      }}
                      className="text-[#009f9f] hover:text-[#007070] font-semibold cursor-pointer"
                    >
                      Mark All Present
                    </button>
                  </div>
                </div>
              </div>

              {/* Attendance Roster Table */}
              <div className="bg-white border border-slate-200 rounded-xl overflow-hidden shadow-2xs">
                <table className="w-full text-xs text-left">
                  <thead className="bg-slate-50 text-slate-600 font-semibold border-b border-slate-200">
                    <tr>
                      <th className="p-3 w-16 text-center">Status</th>
                      <th className="p-3">Student Name</th>
                      <th className="p-3">Enrollment No</th>
                      <th className="p-3">Classes Attended</th>
                      <th className="p-3">Cumulative %</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-slate-100">
                    {attendanceList
                      .filter(a => a.subjectId === attSelectedSubject)
                      .map(att => {
                        const isChecked = attCheckboxes[att.studentId] !== false;
                        return (
                          <tr key={att.studentId} className="hover:bg-slate-50 transition">
                            <td className="p-3 text-center">
                              <input
                                type="checkbox"
                                checked={isChecked}
                                onChange={(e) => {
                                  setAttCheckboxes(prev => ({
                                    ...prev,
                                    [att.studentId]: e.target.checked
                                  }));
                                }}
                                className="w-4 h-4 rounded text-[#009f9f] focus:ring-[#009f9f] cursor-pointer"
                              />
                            </td>
                            <td className="p-3 font-semibold text-slate-900">{att.studentName}</td>
                            <td className="p-3 font-mono text-slate-500">{att.enrollmentNo}</td>
                            <td className="p-3 text-slate-700">
                              {att.attended} / {att.totalClasses} sessions
                            </td>
                            <td className="p-3">
                              <span className={`px-2 py-0.5 rounded font-bold ${
                                att.percentage < 75 ? 'bg-rose-100 text-rose-700 border border-rose-200' : 'bg-emerald-100 text-emerald-700'
                              }`}>
                                {att.percentage}%
                              </span>
                            </td>
                          </tr>
                        );
                      })}
                  </tbody>
                </table>
              </div>
            </div>
          )}

          {/* ========================================================================= */}
          {/* VIEW: EXAMS & MARKS                                                       */}
          {/* ========================================================================= */}
          {currentModule === 'marks' && (
            <div className="space-y-5">
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-4 border-b border-slate-200">
                <div>
                  <h1 className="text-xl font-bold text-slate-900 tracking-tight">Examination & Marks Ledger</h1>
                  <p className="text-xs text-slate-500">Continuous evaluation breakdown: Assignments (20), Internals (30), Practical (20), End-Sem (50).</p>
                </div>
              </div>

              <div className="bg-white border border-slate-200 rounded-xl overflow-hidden shadow-2xs">
                <div className="overflow-x-auto">
                  <table className="w-full text-xs text-left">
                    <thead className="bg-slate-50 text-slate-600 font-semibold border-b border-slate-200">
                      <tr>
                        <th className="p-3">Student</th>
                        <th className="p-3">Subject</th>
                        <th className="p-3 text-center">Assignment (20)</th>
                        <th className="p-3 text-center">Internal (30)</th>
                        <th className="p-3 text-center">Practical (20)</th>
                        <th className="p-3 text-center">End Sem (50)</th>
                        <th className="p-3 text-center">Total (120)</th>
                        <th className="p-3 text-center">Grade</th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-slate-100">
                      {marksList.map((m, idx) => (
                        <tr key={idx} className="hover:bg-slate-50 transition">
                          <td className="p-3">
                            <div className="font-bold text-slate-900">{m.studentName}</div>
                            <div className="text-[11px] text-slate-500 font-mono">{m.enrollmentNo}</div>
                          </td>
                          <td className="p-3 text-slate-700">{m.subjectCode} - {m.subjectName}</td>
                          <td className="p-3 text-center font-mono text-slate-700">{m.assignment}</td>
                          <td className="p-3 text-center font-mono text-slate-700">{m.internal}</td>
                          <td className="p-3 text-center font-mono text-slate-700">{m.practical}</td>
                          <td className="p-3 text-center font-mono text-slate-700">{m.endSem}</td>
                          <td className="p-3 text-center font-bold text-slate-900">{m.total}</td>
                          <td className="p-3 text-center">
                            <span className={`px-2 py-0.5 rounded font-bold ${
                              m.grade === 'A+' || m.grade === 'A'
                                ? 'bg-emerald-100 text-emerald-700'
                                : m.grade === 'F'
                                ? 'bg-rose-100 text-rose-700'
                                : 'bg-[#ecfeff] text-[#007070]'
                            }`}>
                              {m.grade}
                            </span>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          )}

          {/* ========================================================================= */}
          {/* VIEW: FEES & FINANCE                                                      */}
          {/* ========================================================================= */}
          {currentModule === 'fees' && (
            <div className="space-y-5">
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-4 border-b border-slate-200">
                <div>
                  <h1 className="text-xl font-bold text-slate-900 tracking-tight">Tuition & Accounts Ledger</h1>
                  <p className="text-xs text-slate-500">Institutional fee collection, balance tracking, and instant receipt generation.</p>
                </div>
              </div>

              {/* Financial Summary */}
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div className="p-4 bg-slate-50/60 border border-slate-200 rounded-xl">
                  <span className="text-[11px] font-semibold text-slate-500 uppercase">Total Billed</span>
                  <div className="text-xl font-bold text-slate-900 mt-1">
                    ₹{fees.reduce((acc, f) => acc + f.total, 0).toLocaleString()}
                  </div>
                </div>

                <div className="p-4 bg-emerald-50/60 border border-emerald-200 rounded-xl">
                  <span className="text-[11px] font-semibold text-emerald-700 uppercase">Total Collected</span>
                  <div className="text-xl font-bold text-emerald-700 mt-1">
                    ₹{fees.reduce((acc, f) => acc + f.paid, 0).toLocaleString()}
                  </div>
                </div>

                <div className="p-4 bg-rose-50/60 border border-rose-200 rounded-xl">
                  <span className="text-[11px] font-semibold text-rose-700 uppercase">Outstanding Balance</span>
                  <div className="text-xl font-bold text-rose-700 mt-1">
                    ₹{fees.reduce((acc, f) => acc + f.pending, 0).toLocaleString()}
                  </div>
                </div>
              </div>

              {/* Fees Table */}
              <div className="bg-white border border-slate-200 rounded-xl overflow-hidden shadow-2xs">
                <div className="overflow-x-auto">
                  <table className="w-full text-xs text-left">
                    <thead className="bg-slate-50 text-slate-600 font-semibold border-b border-slate-200">
                      <tr>
                        <th className="p-3">Student</th>
                        <th className="p-3">Department</th>
                        <th className="p-3">Total Fee</th>
                        <th className="p-3">Paid</th>
                        <th className="p-3">Balance Due</th>
                        <th className="p-3">Status</th>
                        <th className="p-3 text-right">Action</th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-slate-100">
                      {fees.map(f => (
                        <tr key={f.id} className="hover:bg-slate-50 transition">
                          <td className="p-3">
                            <div className="font-bold text-slate-900">{f.studentName}</div>
                            <div className="text-[11px] text-slate-500 font-mono">{f.enrollmentNo}</div>
                          </td>
                          <td className="p-3 text-slate-700">{f.deptCode} (Sem {f.semester})</td>
                          <td className="p-3 text-slate-700">₹{f.total.toLocaleString()}</td>
                          <td className="p-3 text-emerald-700 font-semibold">₹{f.paid.toLocaleString()}</td>
                          <td className="p-3">
                            <span className={f.pending > 0 ? 'text-rose-700 font-bold' : 'text-slate-500'}>
                              ₹{f.pending.toLocaleString()}
                            </span>
                          </td>
                          <td className="p-3">
                            <span className={`px-2 py-0.5 rounded text-[10px] font-bold ${
                              f.status === 'PAID'
                                ? 'bg-emerald-100 text-emerald-700'
                                : f.status === 'PARTIAL'
                                ? 'bg-amber-100 text-amber-800'
                                : 'bg-rose-100 text-rose-700'
                            }`}>
                              {f.status}
                            </span>
                          </td>
                          <td className="p-3 text-right">
                            {f.pending > 0 ? (
                              <button
                                onClick={() => {
                                  setShowPayModal(f.id);
                                  setPayAmountInput(Math.min(10000, f.pending));
                                }}
                                className="px-2.5 py-1 bg-[#009f9f] hover:bg-[#008787] text-white rounded text-xs font-semibold cursor-pointer"
                              >
                                Record Payment
                              </button>
                            ) : (
                              <span className="text-emerald-700 text-xs font-medium flex items-center justify-end gap-1">
                                <Check className="w-3.5 h-3.5" /> Cleared
                              </span>
                            )}
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          )}

          {/* ========================================================================= */}
          {/* VIEW: LEAVE DESK                                                          */}
          {/* ========================================================================= */}
          {currentModule === 'leaves' && (
            <div className="space-y-5">
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-4 border-b border-slate-200">
                <div>
                  <h1 className="text-xl font-bold text-slate-900 tracking-tight">Student Leave Desk</h1>
                  <p className="text-xs text-slate-500">Review medical, personal, and academic leave requests.</p>
                </div>
              </div>

              <div className="space-y-3">
                {leaves.map(l => (
                  <div key={l.id} className="p-4 bg-white border border-slate-200 rounded-xl flex flex-col md:flex-row md:items-center justify-between gap-4 shadow-2xs">
                    <div>
                      <div className="flex items-center gap-2">
                        <span className="font-bold text-slate-900">{l.studentName}</span>
                        <span className="text-xs text-slate-500 font-mono">({l.enrollmentNo})</span>
                        <span className={`px-2 py-0.5 text-[10px] font-bold rounded ${
                          l.status === 'APPROVED' ? 'bg-emerald-100 text-emerald-700' :
                          l.status === 'REJECTED' ? 'bg-rose-100 text-rose-700' :
                          'bg-amber-100 text-amber-800'
                        }`}>
                          {l.status}
                        </span>
                      </div>
                      <p className="text-xs text-slate-700 mt-1">{l.reason}</p>
                      <div className="text-[11px] text-slate-500 mt-1 flex items-center gap-3">
                        <span>Period: <strong className="text-slate-800">{l.fromDate}</strong> to <strong className="text-slate-800">{l.toDate}</strong></span>
                        <span>Applied: {l.appliedDate}</span>
                      </div>
                      {l.reviewerRemarks && (
                        <div className="text-[11px] text-[#008282] mt-1.5 italic">
                          Remark: "{l.reviewerRemarks}"
                        </div>
                      )}
                    </div>

                    {l.status === 'PENDING' && (
                      <div className="flex items-center gap-2">
                        <button
                          onClick={() => handleUpdateLeaveStatus(l.id, 'APPROVED')}
                          className="px-3 py-1.5 bg-emerald-600 hover:bg-emerald-700 text-white rounded-lg text-xs font-semibold cursor-pointer"
                        >
                          Approve
                        </button>
                        <button
                          onClick={() => handleUpdateLeaveStatus(l.id, 'REJECTED')}
                          className="px-3 py-1.5 bg-rose-600 hover:bg-rose-700 text-white rounded-lg text-xs font-semibold cursor-pointer"
                        >
                          Decline
                        </button>
                      </div>
                    )}
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* ========================================================================= */}
          {/* VIEW: DEPARTMENTS                                                         */}
          {/* ========================================================================= */}
          {currentModule === 'departments' && (
            <div className="space-y-5">
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-4 border-b border-slate-200">
                <div>
                  <h1 className="text-xl font-bold text-slate-900 tracking-tight">Academic Departments</h1>
                  <p className="text-xs text-slate-500">Departmental faculties, student strength, and accredited programs.</p>
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                {departments.map(d => (
                  <div key={d.id} className="p-4.5 bg-slate-50/50 border border-slate-200 hover:border-[#009f9f]/40 rounded-xl transition space-y-3">
                    <div className="flex justify-between items-start">
                      <div>
                        <div className="text-xs font-bold text-[#009f9f] tracking-wider font-mono">{d.code}</div>
                        <h3 className="text-sm font-bold text-slate-900 mt-0.5">{d.name}</h3>
                      </div>
                      <div className="p-2 bg-[#ecfeff] text-[#009f9f] rounded-lg border border-[#a5f3fc]">
                        <Building className="w-4 h-4" />
                      </div>
                    </div>
                    <p className="text-xs text-slate-600 line-clamp-2">{d.description}</p>
                    <div className="grid grid-cols-3 gap-2 pt-3 border-t border-slate-200 text-center">
                      <div>
                        <div className="text-xs font-bold text-slate-900">{students.filter(s => s.deptCode === d.code).length}</div>
                        <div className="text-[10px] text-slate-500">Students</div>
                      </div>
                      <div>
                        <div className="text-xs font-bold text-slate-900">{faculty.filter(f => f.deptCode === d.code).length}</div>
                        <div className="text-[10px] text-slate-500">Faculty</div>
                      </div>
                      <div>
                        <div className="text-xs font-bold text-slate-900">{subjects.filter(s => s.deptCode === d.code).length}</div>
                        <div className="text-[10px] text-slate-500">Courses</div>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* ========================================================================= */}
          {/* VIEW: FACULTY DIRECTORY                                                   */}
          {/* ========================================================================= */}
          {currentModule === 'faculty' && (
            <div className="space-y-5">
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-4 border-b border-slate-200">
                <div>
                  <h1 className="text-xl font-bold text-slate-900 tracking-tight">Faculty Directory</h1>
                  <p className="text-xs text-slate-500">Academic staff, designations, and departmental leadership.</p>
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                {faculty.map(f => (
                  <div key={f.id} className="p-4 bg-slate-50/50 border border-slate-200 rounded-xl flex items-start gap-3.5 shadow-2xs">
                    <div className="w-10 h-10 rounded-xl bg-[#009f9f] flex items-center justify-center font-bold text-white text-sm shrink-0 shadow-xs">
                      {f.name.split(' ').map(n => n[0]).slice(0, 2).join('')}
                    </div>
                    <div className="flex-1 min-w-0">
                      <div className="flex items-center justify-between">
                        <h3 className="text-sm font-bold text-slate-900 truncate">{f.name}</h3>
                        <span className="px-2 py-0.5 rounded bg-slate-100 text-slate-700 text-[10px] font-mono font-semibold">
                          {f.deptCode}
                        </span>
                      </div>
                      <div className="text-xs text-[#008282] font-semibold">{f.designation}</div>
                      <div className="text-[11px] text-slate-500 mt-1">{f.qualification}</div>
                      <div className="text-[11px] text-slate-500 mt-1 flex items-center gap-3">
                        <span>✉️ {f.email}</span>
                        <span>📞 {f.phone}</span>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* ========================================================================= */}
          {/* VIEW: SUBJECTS & CURRICULUM                                               */}
          {/* ========================================================================= */}
          {currentModule === 'subjects' && (
            <div className="space-y-5">
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-4 border-b border-slate-200">
                <div>
                  <h1 className="text-xl font-bold text-slate-900 tracking-tight">Courses & Curriculum</h1>
                  <p className="text-xs text-slate-500">Credit distributions, course codes, and assigned faculty.</p>
                </div>
              </div>

              <div className="bg-white border border-slate-200 rounded-xl overflow-hidden shadow-2xs">
                <table className="w-full text-xs text-left">
                  <thead className="bg-slate-50 text-slate-600 font-semibold border-b border-slate-200">
                    <tr>
                      <th className="p-3">Course Code</th>
                      <th className="p-3">Course Title</th>
                      <th className="p-3">Department</th>
                      <th className="p-3">Semester</th>
                      <th className="p-3">Credits</th>
                      <th className="p-3">Assigned Faculty</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-slate-100">
                    {subjects.map(s => (
                      <tr key={s.id} className="hover:bg-slate-50 transition">
                        <td className="p-3 font-mono font-bold text-[#009f9f]">{s.code}</td>
                        <td className="p-3 font-semibold text-slate-900">{s.name}</td>
                        <td className="p-3 text-slate-600">{s.deptCode}</td>
                        <td className="p-3 text-slate-600">Semester {s.semester}</td>
                        <td className="p-3">
                          <span className="px-2 py-0.5 rounded bg-slate-100 text-slate-700 font-bold border border-slate-200">
                            {s.credits} Credits
                          </span>
                        </td>
                        <td className="p-3 text-slate-700">{s.facultyName}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          )}

          {/* ========================================================================= */}
          {/* VIEW: ENROLLMENTS                                                         */}
          {/* ========================================================================= */}
          {currentModule === 'enrollments' && (
            <div className="space-y-5">
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-4 border-b border-slate-200">
                <div>
                  <h1 className="text-xl font-bold text-slate-900 tracking-tight">Course Registrations</h1>
                  <p className="text-xs text-slate-500">Relational mapping linking students to their active semester courses.</p>
                </div>
              </div>

              <div className="bg-white border border-slate-200 rounded-xl overflow-hidden shadow-2xs">
                <table className="w-full text-xs text-left">
                  <thead className="bg-slate-50 text-slate-600 font-semibold border-b border-slate-200">
                    <tr>
                      <th className="p-3">Registration ID</th>
                      <th className="p-3">Student Name</th>
                      <th className="p-3">Enrollment No</th>
                      <th className="p-3">Course</th>
                      <th className="p-3">Academic Year</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-slate-100">
                    {enrollments.map(e => (
                      <tr key={e.id} className="hover:bg-slate-50 transition">
                        <td className="p-3 font-mono text-slate-400">#{e.id.toString().padStart(4, '0')}</td>
                        <td className="p-3 font-semibold text-slate-900">{e.studentName}</td>
                        <td className="p-3 font-mono text-slate-600">{e.enrollmentNo}</td>
                        <td className="p-3 text-slate-700">{e.subjectCode} - {e.subjectName}</td>
                        <td className="p-3 text-slate-500">{e.academicYear}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          )}

          {/* ========================================================================= */}
          {/* VIEW: REPORTS & INSIGHTS                                                  */}
          {/* ========================================================================= */}
          {currentModule === 'reports' && (
            <div className="space-y-5">
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-4 border-b border-slate-200">
                <div>
                  <h1 className="text-xl font-bold text-slate-900 tracking-tight">Academic Analytics & Insights</h1>
                  <p className="text-xs text-slate-500">Performance percentiles, fee settlement ratios, and department health metrics.</p>
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div className="p-4.5 bg-slate-50/60 border border-slate-200 rounded-xl space-y-2">
                  <div className="text-xs font-semibold text-slate-500">Attendance Compliance</div>
                  <div className="text-2xl font-bold text-emerald-600">
                    {Math.round((students.filter(s => s.attendancePct >= 75).length / students.length) * 100)}%
                  </div>
                  <p className="text-[11px] text-slate-500">
                    {students.filter(s => s.attendancePct >= 75).length} of {students.length} students satisfy the 75% examination threshold.
                  </p>
                </div>

                <div className="p-4.5 bg-slate-50/60 border border-slate-200 rounded-xl space-y-2">
                  <div className="text-xs font-semibold text-slate-500">Fee Clearance Ratio</div>
                  <div className="text-2xl font-bold text-[#009f9f]">
                    {Math.round((fees.filter(f => f.status === 'PAID').length / fees.length) * 100)}%
                  </div>
                  <p className="text-[11px] text-slate-500">
                    {fees.filter(f => f.status === 'PAID').length} fully cleared accounts out of {fees.length} active ledgers.
                  </p>
                </div>

                <div className="p-4.5 bg-slate-50/60 border border-slate-200 rounded-xl space-y-2">
                  <div className="text-xs font-semibold text-slate-500">Pass Rate Index</div>
                  <div className="text-2xl font-bold text-[#0891b2]">
                    {Math.round((marksList.filter(m => m.grade !== 'F').length / marksList.length) * 100)}%
                  </div>
                  <p className="text-[11px] text-slate-500">
                    Based on internal evaluations and continuous assessments.
                  </p>
                </div>
              </div>
            </div>
          )}

          {/* ========================================================================= */}
          {/* VIEW: SQL CONSOLE                                                         */}
          {/* ========================================================================= */}
          {currentModule === 'sql-console' && (
            <div className="space-y-5">
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-4 border-b border-slate-200">
                <div>
                  <h1 className="text-xl font-bold text-slate-900 tracking-tight flex items-center gap-2">
                    <Terminal className="w-5 h-5 text-[#009f9f]" />
                    <span>SQL Query Studio</span>
                  </h1>
                  <p className="text-xs text-slate-500">Execute and test queries against the live schema and view execution benchmarks.</p>
                </div>
                <button
                  onClick={handleRunSQL}
                  className="px-4 py-1.5 bg-[#009f9f] hover:bg-[#008787] text-white rounded-lg text-xs font-semibold flex items-center gap-1.5 shadow-sm shadow-[#009f9f]/20 transition cursor-pointer"
                >
                  <Terminal className="w-3.5 h-3.5" />
                  <span>Run Query</span>
                </button>
              </div>

              {/* Editor Box */}
              <div className="bg-slate-50 border border-slate-200 rounded-xl p-3">
                <textarea
                  value={sqlQuery}
                  onChange={(e) => setSqlQuery(e.target.value)}
                  rows={3}
                  className="w-full bg-white font-mono text-xs text-[#008282] p-3 rounded-lg border border-slate-200 focus:outline-none focus:border-[#009f9f]"
                />
              </div>

              {/* Sample Queries */}
              <div className="flex flex-wrap items-center gap-2 text-xs">
                <span className="text-slate-500 text-[11px] font-semibold">Quick Presets:</span>
                {[
                  'SELECT * FROM students WHERE status = "ACTIVE";',
                  'SELECT * FROM v_academic_risk;',
                  'SELECT dept_code, COUNT(*) FROM students GROUP BY dept_code;',
                  'SELECT * FROM student_fees WHERE pending_amount > 0;'
                ].map((preset, i) => (
                  <button
                    key={i}
                    onClick={() => {
                      setSqlQuery(preset);
                    }}
                    className="px-2.5 py-1 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded font-mono text-[10px] cursor-pointer"
                  >
                    {preset.split(' ')[3] || preset}
                  </button>
                ))}
              </div>

              {/* Result Area */}
              {sqlResult && (
                <div className="bg-white border border-slate-200 rounded-xl p-4 overflow-x-auto shadow-2xs">
                  <div className="text-xs font-bold text-slate-800 mb-2">Query Output ({sqlResult.length} rows returned)</div>
                  <pre className="text-[11px] font-mono text-slate-800 bg-slate-50 p-3 rounded-lg border border-slate-200 overflow-x-auto">
                    {JSON.stringify(sqlResult, null, 2)}
                  </pre>
                </div>
              )}
            </div>
          )}

        </main>
      </div>

      {/* ========================================================================= */}
      {/* MODAL: ADD STUDENT WIZARD                                                 */}
      {/* ========================================================================= */}
      {showAddStudentModal && (
        <div className="fixed inset-0 z-50 bg-black/40 backdrop-blur-xs flex items-center justify-center p-4">
          <div className="bg-white border border-slate-200 rounded-2xl w-full max-w-lg overflow-hidden shadow-2xl animate-in zoom-in-95 duration-150">
            <div className="p-4 bg-slate-50 border-b border-slate-200 flex items-center justify-between">
              <div className="flex items-center gap-2">
                <div className="p-2 bg-[#ecfeff] text-[#009f9f] rounded-lg">
                  <Plus className="w-4 h-4" />
                </div>
                <h3 className="text-sm font-bold text-slate-900">Enroll New Student</h3>
              </div>
              <button
                onClick={() => setShowAddStudentModal(false)}
                className="text-slate-400 hover:text-slate-700 cursor-pointer"
              >
                <X className="w-4 h-4" />
              </button>
            </div>

            <form onSubmit={handleAddStudentSubmit} className="p-5 space-y-4 text-xs">
              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="text-[11px] font-semibold text-slate-700 block mb-1">Full Name *</label>
                  <input
                    type="text"
                    required
                    value={newStudent.name}
                    onChange={(e) => setNewStudent({ ...newStudent, name: e.target.value })}
                    placeholder="e.g. Maya Krishnan"
                    className="w-full bg-white border border-slate-200 rounded-lg px-3 py-1.5 text-slate-900 focus:outline-none focus:border-[#009f9f]"
                  />
                </div>
                <div>
                  <label className="text-[11px] font-semibold text-slate-700 block mb-1">Enrollment No *</label>
                  <input
                    type="text"
                    required
                    value={newStudent.enrollmentNo}
                    onChange={(e) => setNewStudent({ ...newStudent, enrollmentNo: e.target.value })}
                    placeholder="e.g. EN2026CS15"
                    className="w-full bg-white border border-slate-200 rounded-lg px-3 py-1.5 text-slate-900 font-mono focus:outline-none focus:border-[#009f9f]"
                  />
                </div>
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="text-[11px] font-semibold text-slate-700 block mb-1">Email Address *</label>
                  <input
                    type="email"
                    required
                    value={newStudent.email}
                    onChange={(e) => setNewStudent({ ...newStudent, email: e.target.value })}
                    placeholder="student@college.edu"
                    className="w-full bg-white border border-slate-200 rounded-lg px-3 py-1.5 text-slate-900 focus:outline-none focus:border-[#009f9f]"
                  />
                </div>
                <div>
                  <label className="text-[11px] font-semibold text-slate-700 block mb-1">Phone Number</label>
                  <input
                    type="tel"
                    value={newStudent.phone}
                    onChange={(e) => setNewStudent({ ...newStudent, phone: e.target.value })}
                    placeholder="9876543210"
                    className="w-full bg-white border border-slate-200 rounded-lg px-3 py-1.5 text-slate-900 focus:outline-none focus:border-[#009f9f]"
                  />
                </div>
              </div>

              <div className="grid grid-cols-3 gap-3">
                <div>
                  <label className="text-[11px] font-semibold text-slate-700 block mb-1">Department</label>
                  <select
                    value={newStudent.deptId}
                    onChange={(e) => setNewStudent({ ...newStudent, deptId: Number(e.target.value) })}
                    className="w-full bg-white border border-slate-200 rounded-lg px-2.5 py-1.5 text-slate-800 focus:outline-none focus:border-[#009f9f]"
                  >
                    {departments.map(d => (
                      <option key={d.id} value={d.id}>{d.code} - {d.name}</option>
                    ))}
                  </select>
                </div>
                <div>
                  <label className="text-[11px] font-semibold text-slate-700 block mb-1">Semester</label>
                  <select
                    value={newStudent.semester}
                    onChange={(e) => setNewStudent({ ...newStudent, semester: Number(e.target.value) })}
                    className="w-full bg-white border border-slate-200 rounded-lg px-2.5 py-1.5 text-slate-800 focus:outline-none focus:border-[#009f9f]"
                  >
                    {[1, 2, 3, 4, 5, 6, 7, 8].map(s => (
                      <option key={s} value={s}>Sem {s}</option>
                    ))}
                  </select>
                </div>
                <div>
                  <label className="text-[11px] font-semibold text-slate-700 block mb-1">Gender</label>
                  <select
                    value={newStudent.gender}
                    onChange={(e) => setNewStudent({ ...newStudent, gender: e.target.value as any })}
                    className="w-full bg-white border border-slate-200 rounded-lg px-2.5 py-1.5 text-slate-800 focus:outline-none focus:border-[#009f9f]"
                  >
                    <option value="MALE">Male</option>
                    <option value="FEMALE">Female</option>
                    <option value="OTHER">Other</option>
                  </select>
                </div>
              </div>

              <div className="flex justify-end gap-2 pt-3 border-t border-slate-200">
                <button
                  type="button"
                  onClick={() => setShowAddStudentModal(false)}
                  className="px-4 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-lg font-semibold cursor-pointer"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="px-4 py-2 bg-[#009f9f] hover:bg-[#008787] text-white rounded-lg font-semibold shadow-sm shadow-[#009f9f]/30 cursor-pointer"
                >
                  Confirm Enrollment
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* ========================================================================= */}
      {/* MODAL: RECORD FEE PAYMENT                                                 */}
      {/* ========================================================================= */}
      {showPayModal !== null && (
        <div className="fixed inset-0 z-50 bg-black/40 backdrop-blur-xs flex items-center justify-center p-4">
          <div className="bg-white border border-slate-200 rounded-2xl w-full max-w-md overflow-hidden shadow-2xl animate-in zoom-in-95 duration-150">
            <div className="p-4 bg-slate-50 border-b border-slate-200 flex items-center justify-between">
              <div className="flex items-center gap-2">
                <CreditCard className="w-4 h-4 text-[#009f9f]" />
                <h3 className="text-sm font-bold text-slate-900">Record Tuition Fee Payment</h3>
              </div>
              <button
                onClick={() => setShowPayModal(null)}
                className="text-slate-400 hover:text-slate-700 cursor-pointer"
              >
                <X className="w-4 h-4" />
              </button>
            </div>

            <div className="p-5 space-y-4 text-xs">
              {(() => {
                const feeRecord = fees.find(f => f.id === showPayModal);
                if (!feeRecord) return null;
                return (
                  <>
                    <div className="p-3 bg-slate-50 rounded-xl border border-slate-200 space-y-1">
                      <div className="font-bold text-slate-900 text-sm">{feeRecord.studentName}</div>
                      <div className="text-slate-500 font-mono text-[11px]">{feeRecord.enrollmentNo} • {feeRecord.deptCode} Sem {feeRecord.semester}</div>
                      <div className="text-rose-600 font-bold pt-1">
                        Outstanding Balance: ₹{feeRecord.pending.toLocaleString()}
                      </div>
                    </div>

                    <div>
                      <label className="text-[11px] font-semibold text-slate-700 block mb-1">Payment Amount (₹)</label>
                      <input
                        type="number"
                        min="1"
                        max={feeRecord.pending}
                        value={payAmountInput}
                        onChange={(e) => setPayAmountInput(Number(e.target.value))}
                        className="w-full bg-white border border-slate-200 rounded-lg px-3 py-2 text-slate-900 font-bold text-base focus:outline-none focus:border-[#009f9f]"
                      />
                    </div>

                    <div className="flex justify-end gap-2 pt-3 border-t border-slate-200">
                      <button
                        onClick={() => setShowPayModal(null)}
                        className="px-4 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-lg font-semibold cursor-pointer"
                      >
                        Cancel
                      </button>
                      <button
                        onClick={() => handlePayFee(feeRecord.id)}
                        className="px-4 py-2 bg-[#009f9f] hover:bg-[#008787] text-white rounded-lg font-semibold shadow-md shadow-[#009f9f]/30 cursor-pointer"
                      >
                        Submit Receipt
                      </button>
                    </div>
                  </>
                );
              })()}
            </div>
          </div>
        </div>
      )}

      {/* ========================================================================= */}
      {/* DRAWER / MODAL: STUDENT 360° PROFILE VIEW                                 */}
      {/* ========================================================================= */}
      {profileStudent && (
        <div className="fixed inset-0 z-50 bg-black/40 backdrop-blur-xs flex items-center justify-end">
          <div className="bg-white border-l border-slate-200 w-full max-w-2xl h-full overflow-y-auto p-6 space-y-6 shadow-2xl animate-in slide-in-from-right duration-200">
            <div className="flex items-center justify-between pb-4 border-b border-slate-200">
              <div className="flex items-center gap-3">
                <div className="w-12 h-12 rounded-xl bg-[#009f9f] flex items-center justify-center font-bold text-white text-lg shadow-md">
                  {profileStudent.name.split(' ').map(n => n[0]).slice(0, 2).join('')}
                </div>
                <div>
                  <h2 className="text-base font-bold text-slate-900">{profileStudent.name}</h2>
                  <div className="text-xs text-slate-500 font-mono">{profileStudent.enrollmentNo} • {profileStudent.deptCode}</div>
                </div>
              </div>
              <button
                onClick={() => setViewProfileStudentId(null)}
                className="p-2 text-slate-400 hover:text-slate-700 rounded-lg hover:bg-slate-100 cursor-pointer"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            {/* Overview Stats */}
            <div className="grid grid-cols-3 gap-3">
              <div className="p-3 bg-slate-50 rounded-xl border border-slate-200 text-center">
                <div className="text-[10px] uppercase font-semibold text-slate-500">Attendance</div>
                <div className={`text-lg font-bold mt-1 ${profileStudent.attendancePct < 75 ? 'text-rose-600' : 'text-emerald-600'}`}>
                  {profileStudent.attendancePct}%
                </div>
              </div>
              <div className="p-3 bg-slate-50 rounded-xl border border-slate-200 text-center">
                <div className="text-[10px] uppercase font-semibold text-slate-500">Academic Avg</div>
                <div className="text-lg font-bold text-[#009f9f] mt-1">
                  {profileStudent.avgMarks || 'Pending'}
                </div>
              </div>
              <div className="p-3 bg-slate-50 rounded-xl border border-slate-200 text-center">
                <div className="text-[10px] uppercase font-semibold text-slate-500">Fee Balance</div>
                <div className={`text-lg font-bold mt-1 ${profileStudent.pendingFees > 0 ? 'text-rose-600' : 'text-emerald-600'}`}>
                  ₹{profileStudent.pendingFees.toLocaleString()}
                </div>
              </div>
            </div>

            {/* Student Details Grid */}
            <div className="bg-slate-50 border border-slate-200 rounded-xl p-4 space-y-2 text-xs">
              <h3 className="font-bold text-slate-900 mb-2">Demographic Particulars</h3>
              <div className="grid grid-cols-2 gap-2 text-slate-600">
                <div>Email: <span className="text-slate-900 font-medium">{profileStudent.email}</span></div>
                <div>Phone: <span className="text-slate-900 font-medium">{profileStudent.phone}</span></div>
                <div>Gender: <span className="text-slate-900 font-medium">{profileStudent.gender}</span></div>
                <div>DOB: <span className="text-slate-900 font-medium">{profileStudent.dob}</span></div>
                <div className="col-span-2">Address: <span className="text-slate-900 font-medium">{profileStudent.address}</span></div>
              </div>
            </div>

            {/* Enrolled Courses / Attendance */}
            <div className="space-y-3">
              <h3 className="font-bold text-slate-900 text-xs">Registered Courses & Attendance</h3>
              <div className="bg-white border border-slate-200 rounded-xl overflow-hidden text-xs shadow-2xs">
                <table className="w-full text-left">
                  <thead className="bg-slate-50 text-slate-600 font-semibold border-b border-slate-200">
                    <tr>
                      <th className="p-2.5">Course</th>
                      <th className="p-2.5">Attended</th>
                      <th className="p-2.5 text-right">Percentage</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-slate-100">
                    {profileStudentAttendance.length === 0 ? (
                      <tr><td colSpan={3} className="p-3 text-center text-slate-400">No session logs found.</td></tr>
                    ) : (
                      profileStudentAttendance.map((a, i) => (
                        <tr key={i}>
                          <td className="p-2.5 text-slate-900 font-medium">{a.subjectCode} - {a.subjectName}</td>
                          <td className="p-2.5 text-slate-600">{a.attended} / {a.totalClasses}</td>
                          <td className="p-2.5 text-right font-bold text-emerald-600">{a.percentage}%</td>
                        </tr>
                      ))
                    )}
                  </tbody>
                </table>
              </div>
            </div>

            {/* Fee Records */}
            <div className="space-y-3">
              <h3 className="font-bold text-slate-900 text-xs">Financial Fee Status</h3>
              <div className="space-y-2">
                {profileStudentFees.map(f => (
                  <div key={f.id} className="p-3 bg-white border border-slate-200 rounded-xl flex items-center justify-between text-xs shadow-2xs">
                    <div>
                      <div className="font-bold text-slate-900">Semester {f.semester} Fee Ledger</div>
                      <div className="text-[11px] text-slate-500">Paid: ₹{f.paid.toLocaleString()} | Due: ₹{f.pending.toLocaleString()}</div>
                    </div>
                    <span className={`px-2 py-0.5 rounded text-[10px] font-bold ${
                      f.status === 'PAID' ? 'bg-emerald-100 text-emerald-700' : 'bg-rose-100 text-rose-700'
                    }`}>
                      {f.status}
                    </span>
                  </div>
                ))}
              </div>
            </div>

            <div className="pt-4 border-t border-slate-200 flex justify-end">
              <button
                onClick={() => setViewProfileStudentId(null)}
                className="px-4 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-lg text-xs font-semibold cursor-pointer"
              >
                Close File
              </button>
            </div>
          </div>
        </div>
      )}

      {/* ========================================================================= */}
      {/* MODAL: DEVELOPER & SYSTEM CONTROL STUDIO                                  */}
      {/* ========================================================================= */}
      {showDevConsole && (
        <div className="fixed inset-0 z-50 bg-black/40 backdrop-blur-xs flex items-center justify-center p-4">
          <div className="bg-white border border-slate-200 rounded-2xl w-full max-w-3xl overflow-hidden shadow-2xl animate-in zoom-in-95 duration-150">
            <div className="p-4 bg-slate-50 border-b border-slate-200 flex items-center justify-between">
              <div className="flex items-center gap-2">
                <Sliders className="w-4 h-4 text-[#009f9f]" />
                <h3 className="text-sm font-bold text-slate-900">System, Deployment & Database Console</h3>
              </div>
              <button
                onClick={() => setShowDevConsole(false)}
                className="text-slate-400 hover:text-slate-700 cursor-pointer"
              >
                <X className="w-4 h-4" />
              </button>
            </div>

            <div className="p-6 space-y-5 text-xs text-slate-600 max-h-[80vh] overflow-y-auto">
              {/* Architecture Specs */}
              <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
                <div className="p-3 bg-slate-50 rounded-xl border border-slate-200">
                  <span className="text-[10px] uppercase font-bold text-slate-500">Database</span>
                  <div className="font-bold text-slate-900 mt-0.5">MySQL 8.0 (3NF)</div>
                  <div className="text-[10px] text-emerald-600 mt-1">12 Tables • 4 Views</div>
                </div>
                <div className="p-3 bg-slate-50 rounded-xl border border-slate-200">
                  <span className="text-[10px] uppercase font-bold text-slate-500">Backend Server</span>
                  <div className="font-bold text-slate-900 mt-0.5">Node.js / Express</div>
                  <div className="text-[10px] text-[#009f9f] mt-1">Port 3000 Active</div>
                </div>
                <div className="p-3 bg-slate-50 rounded-xl border border-slate-200">
                  <span className="text-[10px] uppercase font-bold text-slate-500">Enterprise Java</span>
                  <div className="font-bold text-slate-900 mt-0.5">Jakarta 10 EE</div>
                  <div className="text-[10px] text-slate-500 mt-1">Tomcat 10.1 WAR Ready</div>
                </div>
                <div className="p-3 bg-slate-50 rounded-xl border border-slate-200">
                  <span className="text-[10px] uppercase font-bold text-slate-500">Container</span>
                  <div className="font-bold text-slate-900 mt-0.5">Docker Ready</div>
                  <div className="text-[10px] text-emerald-600 mt-1">docker compose up -d</div>
                </div>
              </div>

              {/* Deployment Assets & Direct Downloads */}
              <div>
                <h4 className="font-bold text-slate-900 text-xs mb-2">Deployment Artifacts & SQL Files</h4>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                  <a
                    href="/smart_college_db.sql"
                    download="smart_college_db.sql"
                    className="p-3 bg-slate-50 hover:bg-slate-100 border border-slate-200 rounded-xl flex items-center justify-between text-slate-700 transition"
                  >
                    <div className="flex items-center gap-2">
                      <Database className="w-4 h-4 text-[#009f9f]" />
                      <div>
                        <div className="font-bold text-slate-900">smart_college_db.sql</div>
                        <div className="text-[10px] text-slate-500">Complete MySQL Schema & Seed Data</div>
                      </div>
                    </div>
                    <Download className="w-4 h-4 text-slate-400" />
                  </a>

                  <a
                    href="/smart-college-management-system.zip"
                    download="smart-college-management-system.zip"
                    className="p-3 bg-slate-50 hover:bg-slate-100 border border-slate-200 rounded-xl flex items-center justify-between text-slate-700 transition"
                  >
                    <div className="flex items-center gap-2">
                      <Server className="w-4 h-4 text-[#0891b2]" />
                      <div>
                        <div className="font-bold text-slate-900">Java EE WAR Source (.zip)</div>
                        <div className="text-[10px] text-slate-500">Maven + Servlets + Tomcat 10.1</div>
                      </div>
                    </div>
                    <Download className="w-4 h-4 text-slate-400" />
                  </a>
                </div>
              </div>

              {/* Database Verification Terminal */}
              <div className="p-4 bg-slate-900 text-slate-100 border border-slate-800 rounded-xl space-y-2">
                <div className="flex items-center justify-between">
                  <span className="font-bold text-emerald-400 font-mono text-[11px]">$ npm run setup:db</span>
                  <span className="text-[10px] text-slate-400">Auto-migrator status</span>
                </div>
                <p className="text-[11px] text-slate-400">
                  Run <code className="text-[#a5f3fc]">setup-db.bat</code> or <code className="text-[#a5f3fc]">npm run setup:db</code> anytime to create/re-seed the MySQL database automatically.
                </p>
              </div>
            </div>

            <div className="p-4 bg-slate-50 border-t border-slate-200 flex justify-end">
              <button
                onClick={() => setShowDevConsole(false)}
                className="px-4 py-2 bg-[#009f9f] hover:bg-[#008787] text-white rounded-lg font-semibold cursor-pointer"
              >
                Done
              </button>
            </div>
          </div>
        </div>
      )}

    </div>
  );
}
