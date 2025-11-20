/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import static DAO.DBConnection.getConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import model.Exam;
import model.QuestionBank;
import model.Subjects;
import model.Tests;


public class ExamDAO extends DBConnection {

    public List<Exam> searchExamsByKeyword(String keyword) {
        String query = "SELECT * FROM Exam WHERE exam_name LIKE N'%' + ? + '%'";
        List<Exam> list = new ArrayList<>();
        try (Connection con = getConnection()) {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1,keyword);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Exam exam = new Exam();
                exam.setExamID(rs.getInt(1));
                exam.setExamName(rs.getString(2));
                exam.setCreateDate(rs.getString(3));
                exam.setUserID(rs.getInt(4));
                exam.setSubjectID(rs.getInt(5));
                exam.setTimer(rs.getInt(6));
                exam.setPrice(rs.getInt(7));
                exam.setLikes(rs.getInt(8));
                exam.setViews(rs.getInt(9));
                exam.setIsAprroved(rs.getBoolean(10));
                list.add(exam);;
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    public List<Exam> searchExamsBySubjectAndKeyword(int subjectID, String keyword) {
        String query = "SELECT * FROM Exam WHERE subject_id = ? AND exam_name LIKE N'%' + ? + '%'";
        List<Exam> list = new ArrayList<>();
        try (Connection con = getConnection()) {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, subjectID);
            ps.setString(2, keyword);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Exam exam = new Exam();
                exam.setExamID(rs.getInt(1));
                exam.setExamName(rs.getString(2));
                exam.setCreateDate(rs.getString(3));
                exam.setUserID(rs.getInt(4));
                exam.setSubjectID(rs.getInt(5));
                exam.setTimer(rs.getInt(6));
                exam.setPrice(rs.getInt(7));
                exam.setLikes(rs.getInt(8));
                exam.setViews(rs.getInt(9));
                exam.setIsAprroved(rs.getBoolean(10));
                list.add(exam);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    public List<Exam> searchExamsByStatusAndKeyword(boolean isApproved, String keyword) {
        String query = "SELECT * FROM Exam WHERE is_approved = ? AND exam_name LIKE N'%' + ? + '%'";
        List<Exam> list = new ArrayList<>();
        try (Connection con = getConnection()) {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setBoolean(1, isApproved);
            ps.setString(2, keyword);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Exam exam = new Exam();
                exam.setExamID(rs.getInt(1));
                exam.setExamName(rs.getString(2));
                exam.setCreateDate(rs.getString(3));
                exam.setUserID(rs.getInt(4));
                exam.setSubjectID(rs.getInt(5));
                exam.setTimer(rs.getInt(6));
                exam.setPrice(rs.getInt(7));
                exam.setLikes(rs.getInt(8));
                exam.setViews(rs.getInt(9));
                exam.setIsAprroved(rs.getBoolean(10));
                list.add(exam);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    public List<Exam> searchExamsBySubjectStatusAndKeyword(int subjectID, boolean isApproved, String keyword) {
        String query = "SELECT * FROM Exam WHERE subject_id = ? AND is_approved = ? AND exam_name LIKE N'%' + ? + '%'";
        List<Exam> list = new ArrayList<>();
        try (Connection con = getConnection()) {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, subjectID);
            ps.setBoolean(2, isApproved);
            ps.setString(3, keyword);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Exam exam = new Exam();
                exam.setExamID(rs.getInt(1));
                exam.setExamName(rs.getString(2));
                exam.setCreateDate(rs.getString(3));
                exam.setUserID(rs.getInt(4));
                exam.setSubjectID(rs.getInt(5));
                exam.setTimer(rs.getInt(6));
                exam.setPrice(rs.getInt(7));
                exam.setLikes(rs.getInt(8));
                exam.setViews(rs.getInt(9));
                exam.setIsAprroved(rs.getBoolean(10));
                list.add(exam);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    //Delete question
    public void deleteQuestion(int questionID) {
        String query = "delete from ExamQuestion where question_id = ?"
                + "delete from StudentChoice where question_id = ?"
                + "delete from QuestionBank where question_id = ? DBCC CHECKIDENT (QuestionBank, RESEED, 0); DBCC CHECKIDENT (QuestionBank, RESEED);";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, questionID);
            ps.setInt(2, questionID);
            ps.setInt(3, questionID);
            try {
                ps.executeUpdate();
            } catch (SQLException e) {
                System.out.println(e);
            }
        } catch (Exception err) {
            System.out.println(err);
        }

    }

    //Add exam
    public void addExam(String examName, int userID, int subjectID, int examTime, int price) {
        String query = "DBCC CHECKIDENT (Exam, RESEED, 0); DBCC CHECKIDENT (Exam, RESEED); insert into Exam(exam_name, create_date, userID, subject_id, timer, price) values(?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, examName);
            String timeStamp = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss").format(new java.util.Date());
            ps.setString(2, timeStamp);
            ps.setInt(3, userID);
            ps.setInt(4, subjectID);
            ps.setInt(5, examTime);
            ps.setInt(6, price);
            try {
                ps.executeUpdate();
            } catch (SQLException e) {
                System.out.println(e);
            }
        } catch (Exception err) {
            System.out.println(err);
        }
    }

    public List<Exam> getAllExam() {
        String query = "SELECT * FROM Exam";
        List<Exam> list = new ArrayList<>();
        try (Connection con = getConnection()) {
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Exam exam = new Exam();
                exam.setExamID(rs.getInt(1));
                exam.setExamName(rs.getString(2));
                exam.setCreateDate(rs.getString(3));
                exam.setUserID(rs.getInt(4));
                exam.setSubjectID(rs.getInt(5));
                exam.setTimer(rs.getInt(6));
                exam.setPrice(rs.getInt(7));
                exam.setLikes(rs.getInt(8));
                exam.setViews(rs.getInt(9));
                exam.setIsAprroved(rs.getBoolean(10));
                list.add(exam);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    public List<Exam> getAllExams() {
        String query = "SELECT * FROM Exam Where is_approved = 'true'";
        List<Exam> list = new ArrayList<>();
        try (Connection con = getConnection()) {
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Exam exam = new Exam();
                exam.setExamID(rs.getInt(1));
                exam.setExamName(rs.getString(2));
                exam.setCreateDate(rs.getString(3));
                exam.setUserID(rs.getInt(4));
                exam.setSubjectID(rs.getInt(5));
                exam.setTimer(rs.getInt(6));
                exam.setPrice(rs.getInt(7));
                exam.setLikes(rs.getInt(8));
                exam.setViews(rs.getInt(9));
                exam.setIsAprroved(rs.getBoolean(10));
                list.add(exam);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    public List<Exam> getAllExamsNotApproved() {
        String query = "SELECT * FROM Exam Where is_approved = 'false'";
        List<Exam> list = new ArrayList<>();
        try (Connection con = getConnection()) {
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Exam exam = new Exam();
                exam.setExamID(rs.getInt(1));
                exam.setExamName(rs.getString(2));
                exam.setCreateDate(rs.getString(3));
                exam.setUserID(rs.getInt(4));
                exam.setSubjectID(rs.getInt(5));
                exam.setTimer(rs.getInt(6));
                exam.setPrice(rs.getInt(7));
                exam.setLikes(rs.getInt(8));
                exam.setViews(rs.getInt(9));
                exam.setIsAprroved(rs.getBoolean(10));
                list.add(exam);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    public List<Exam> getExamsBySubjectAndStatus(int subjectID, boolean isApproved) {
        List<Exam> exams = new ArrayList<>();
        String sql = "SELECT * FROM Exam WHERE subject_id = ? AND is_approved = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, subjectID);
            ps.setBoolean(2, isApproved);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Exam exam = new Exam();
                exam.setExamID(rs.getInt(1));
                exam.setExamName(rs.getString(2));
                exam.setCreateDate(rs.getString(3));
                exam.setUserID(rs.getInt(4));
                exam.setSubjectID(rs.getInt(5));
                exam.setTimer(rs.getInt(6));
                exam.setPrice(rs.getInt(7));
                exam.setLikes(rs.getInt(8));
                exam.setViews(rs.getInt(9));
                exam.setIsAprroved(rs.getBoolean(10));
                exams.add(exam);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return exams;
    }

    public List<Exam> getExamsBySubject(int subjectID) {
        List<Exam> exams = new ArrayList<>();
        String sql = "SELECT * FROM Exam WHERE subject_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, subjectID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Exam exam = new Exam();
                exam.setExamID(rs.getInt(1));
                exam.setExamName(rs.getString(2));
                exam.setCreateDate(rs.getString(3));
                exam.setUserID(rs.getInt(4));
                exam.setSubjectID(rs.getInt(5));
                exam.setTimer(rs.getInt(6));
                exam.setPrice(rs.getInt(7));
                exam.setLikes(rs.getInt(8));
                exam.setViews(rs.getInt(9));
                exam.setIsAprroved(rs.getBoolean(10));
                exams.add(exam);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return exams;
    }

    public void updatePrice(int examID, int price) {
        String query = "UPDATE Exam SET price = ? and is_approved = 'false' WHERE exam_id = ?";
        try (Connection con = getConnection()) {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, price);
            ps.setInt(2, examID);
            int rowsAffected = ps.executeUpdate(); // Sử dụng executeUpdate thay vì executeQuery để cập nhật dữ liệu
            System.out.println(rowsAffected + " rows updated.");
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    public List<Exam> getAllExamsByStatus(boolean isApproved) {
        List<Exam> exams = new ArrayList<>();
        String sql = "SELECT * FROM Exam WHERE is_approved = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, isApproved);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Exam exam = new Exam();
                exam.setExamID(rs.getInt(1));
                exam.setExamName(rs.getString(2));
                exam.setCreateDate(rs.getString(3));
                exam.setUserID(rs.getInt(4));
                exam.setSubjectID(rs.getInt(5));
                exam.setTimer(rs.getInt(6));
                exam.setPrice(rs.getInt(7));
                exam.setLikes(rs.getInt(8));
                exam.setViews(rs.getInt(9));
                exam.setIsAprroved(rs.getBoolean(10));
                exams.add(exam);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return exams;
    }

    //Get all exam by userID
    public List<Exam> getAllExamByUserID(int userID) {
        String query = "SELECT * FROM Exam Where userID = ?";
        List<Exam> list = new ArrayList<>();
        try (Connection con = getConnection()) {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, userID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Exam exam = new Exam();
                exam.setExamID(rs.getInt(1));
                exam.setExamName(rs.getString(2));
                exam.setCreateDate(rs.getString(3));
                exam.setUserID(rs.getInt(4));
                exam.setSubjectID(rs.getInt(5));
                exam.setTimer(rs.getInt(6));
                exam.setPrice(rs.getInt(7));
                exam.setLikes(rs.getInt(8));
                exam.setViews(rs.getInt(9));
                exam.setIsAprroved(rs.getBoolean(10));
                list.add(exam);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    //Get all exam by userID
    public List<Exam> getAllExamIsApprovedByUserID(int userID) {
        String query = "SELECT * FROM Exam Where userID = ? and is_approved = 'true'";
        List<Exam> list = new ArrayList<>();
        try (Connection con = getConnection()) {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, userID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Exam exam = new Exam();
                exam.setExamID(rs.getInt(1));
                exam.setExamName(rs.getString(2));
                exam.setCreateDate(rs.getString(3));
                exam.setUserID(rs.getInt(4));
                exam.setSubjectID(rs.getInt(5));
                exam.setTimer(rs.getInt(6));
                exam.setPrice(rs.getInt(7));
                exam.setLikes(rs.getInt(8));
                exam.setViews(rs.getInt(9));
                exam.setIsAprroved(rs.getBoolean(10));
                list.add(exam);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    public List<Exam> getAllExamNotApprovedByUserID(int userID) {
        String query = "SELECT * FROM Exam Where userID = ? and is_approved = 'false'";
        List<Exam> list = new ArrayList<>();
        try (Connection con = getConnection()) {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, userID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Exam exam = new Exam();
                exam.setExamID(rs.getInt(1));
                exam.setExamName(rs.getString(2));
                exam.setCreateDate(rs.getString(3));
                exam.setUserID(rs.getInt(4));
                exam.setSubjectID(rs.getInt(5));
                exam.setTimer(rs.getInt(6));
                exam.setPrice(rs.getInt(7));
                exam.setLikes(rs.getInt(8));
                exam.setViews(rs.getInt(9));
                exam.setIsAprroved(rs.getBoolean(10));
                list.add(exam);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    public void approvedExam(int examID) {
        String query = "UPDATE Exam SET is_approved = 'true' WHERE exam_id = ?";
        try (Connection con = getConnection()) {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, examID);
            int rowsAffected = ps.executeUpdate(); // Sử dụng executeUpdate thay vì executeQuery để cập nhật dữ liệu
            System.out.println(rowsAffected + " rows updated.");
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    public void notApprovedExam(int examID) {
        String query = "UPDATE Exam SET is_approved = 'false' WHERE exam_id = ?";

        try (Connection con = getConnection()) {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, examID);
            int rowsAffected = ps.executeUpdate(); // Sử dụng executeUpdate thay vì executeQuery để cập nhật dữ liệu
            System.out.println(rowsAffected + " rows updated.");
        } catch (Exception e) {
            System.out.println(e);
        }

    }
    //Get exam by examID

    public Exam getExamByID(int examID) {
        String query = "SELECT * FROM Exam Where exam_id = ?";
        Exam exam = new Exam();
        try (Connection con = getConnection()) {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, examID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                exam.setExamID(rs.getInt(1));
                exam.setExamName(rs.getString(2));
                exam.setCreateDate(rs.getString(3));
                exam.setUserID(rs.getInt(4));
                exam.setSubjectID(rs.getInt(5));
                exam.setTimer(rs.getInt(6));
                exam.setPrice(rs.getInt(7));
                exam.setLikes(rs.getInt(8));
                exam.setViews(rs.getInt(9));
                exam.setIsAprroved(rs.getBoolean(10));
                return exam;
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return null;
    }

    public List<QuestionBank> searchQuestionByNameAndSubjectIDWithPagination(String searchQuery, int subjectId, int offset, int limit) {
        List<QuestionBank> questionList = new ArrayList<>();
        String sql = "SELECT * FROM QuestionBank WHERE subject_id = ? AND question_context LIKE N'%' + ? + '%' ORDER BY question_id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, subjectId);
            stmt.setString(2, searchQuery);
            stmt.setInt(3, offset);
            stmt.setInt(4, limit);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                QuestionBank qb = new QuestionBank();
                qb.setQuestionId(rs.getInt(1));
                qb.setSubjectId(rs.getInt(2));
                qb.setQuestionContext(rs.getString(3));
                qb.setChoice1(rs.getString(4));
                qb.setChoice2(rs.getString(5));
                qb.setChoice3(rs.getString(6));
                qb.setChoiceCorrect(rs.getString(7));
                qb.setExplain(rs.getString(8));
                qb.setQuestionImg(rs.getString(9));
                qb.setExplainImg(rs.getString(10));
                qb.setUserID(rs.getInt(11));
                questionList.add(qb);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return questionList;
    }

    public List<QuestionBank> searchQuestionByNameWithPagination(String searchQuery, int offset, int limit) {
        List<QuestionBank> questionList = new ArrayList<>();
        String sql = "SELECT * FROM QuestionBank WHERE question_context LIKE N'%' + ? + '%' ORDER BY question_id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, searchQuery);
            stmt.setInt(2, offset);
            stmt.setInt(3, limit);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                QuestionBank qb = new QuestionBank();
                qb.setQuestionId(rs.getInt(1));
                qb.setSubjectId(rs.getInt(2));
                qb.setQuestionContext(rs.getString(3));
                qb.setChoice1(rs.getString(4));
                qb.setChoice2(rs.getString(5));
                qb.setChoice3(rs.getString(6));
                qb.setChoiceCorrect(rs.getString(7));
                qb.setExplain(rs.getString(8));
                qb.setQuestionImg(rs.getString(9));
                qb.setExplainImg(rs.getString(10));
                qb.setUserID(rs.getInt(11));
                questionList.add(qb);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return questionList;
    }

    public List<QuestionBank> getAllSystemQuestionByIDWithPagination(int subjectId, int offset, int limit) {
        List<QuestionBank> questionList = new ArrayList<>();
        String sql = "SELECT * FROM QuestionBank WHERE subject_id = ? ORDER BY question_id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, subjectId);
            stmt.setInt(2, offset);
            stmt.setInt(3, limit);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                QuestionBank qb = new QuestionBank();
                qb.setQuestionId(rs.getInt(1));
                qb.setSubjectId(rs.getInt(2));
                qb.setQuestionContext(rs.getString(3));
                qb.setChoice1(rs.getString(4));
                qb.setChoice2(rs.getString(5));
                qb.setChoice3(rs.getString(6));
                qb.setChoiceCorrect(rs.getString(7));
                qb.setExplain(rs.getString(8));
                qb.setQuestionImg(rs.getString(9));
                qb.setExplainImg(rs.getString(10));
                qb.setUserID(rs.getInt(11));
                questionList.add(qb);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return questionList;
    }

    public List<QuestionBank> getAllSystemQuestionWithPagination(int offset, int limit) {
        List<QuestionBank> questionList = new ArrayList<>();
        String sql = "SELECT * FROM QuestionBank ORDER BY question_id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, offset);
            stmt.setInt(2, limit);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                QuestionBank qb = new QuestionBank();
                qb.setQuestionId(rs.getInt(1));
                qb.setSubjectId(rs.getInt(2));
                qb.setQuestionContext(rs.getString(3));
                qb.setChoice1(rs.getString(4));
                qb.setChoice2(rs.getString(5));
                qb.setChoice3(rs.getString(6));
                qb.setChoiceCorrect(rs.getString(7));
                qb.setExplain(rs.getString(8));
                qb.setQuestionImg(rs.getString(9));
                qb.setExplainImg(rs.getString(10));
                qb.setUserID(rs.getInt(11));
                questionList.add(qb);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return questionList;
    }

    public int countQuestions(String filter, String search) {
        String sql = "SELECT COUNT(*) FROM QuestionBank WHERE 1=1";

        if (filter != null && !filter.equals("all")) {
            sql += " AND subject_id = ?";
        }
        if (search != null && !search.isEmpty()) {
            sql += " AND question_context LIKE N'%' + ? + '%'";
        }

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            int paramIndex = 1;
            if (filter != null && !filter.equals("all")) {
                stmt.setInt(paramIndex++, Integer.parseInt(filter));
            }
            if (search != null && !search.isEmpty()) {
                stmt.setString(paramIndex, search);
            }

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<QuestionBank> searchQuestionByNameAndSubjectID(String searchQuery, int subjectId) {
        List<QuestionBank> questionList = new ArrayList<>();
        String sql = "SELECT * FROM QuestionBank WHERE subject_id = ? and question_context LIKE N'%' + ? + '%'";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, subjectId);
            stmt.setString(2, searchQuery);  // Thêm dấu "%" để tìm kiếm chứa từ khóa

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                QuestionBank qb = new QuestionBank();
                qb.setQuestionId(rs.getInt(1));
                qb.setSubjectId(rs.getInt(2));
                qb.setQuestionContext(rs.getString(3));
                qb.setChoice1(rs.getString(4));
                qb.setChoice2(rs.getString(5));
                qb.setChoice3(rs.getString(6));
                qb.setChoiceCorrect(rs.getString(7));
                qb.setExplain(rs.getString(8));
                qb.setQuestionImg(rs.getString(9));
                qb.setExplainImg(rs.getString(10));
                qb.setUserID(rs.getInt(11));
                questionList.add(qb);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return questionList;
    }

    public List<QuestionBank> searchQuestionByName(String searchQuery) {
        List<QuestionBank> questionList = new ArrayList<>();
        String sql = "SELECT * FROM QuestionBank WHERE question_context LIKE N'%' + ? + '%'";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, searchQuery);  // Thêm dấu "%" để tìm kiếm chứa từ khóa

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                QuestionBank qb = new QuestionBank();
                qb.setQuestionId(rs.getInt(1));
                qb.setSubjectId(rs.getInt(2));
                qb.setQuestionContext(rs.getString(3));
                qb.setChoice1(rs.getString(4));
                qb.setChoice2(rs.getString(5));
                qb.setChoice3(rs.getString(6));
                qb.setChoiceCorrect(rs.getString(7));
                qb.setExplain(rs.getString(8));
                qb.setQuestionImg(rs.getString(9));
                qb.setExplainImg(rs.getString(10));
                qb.setUserID(rs.getInt(11));
                questionList.add(qb);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return questionList;
    }

    // Get all questions without exam ID
    public List<QuestionBank> getAllQuestions() {
        String query = "SELECT * FROM QuestionBank"; // Lấy tất cả câu hỏi từ bảng QuestionBank
        List<QuestionBank> list = new ArrayList<>();
        try (Connection con = getConnection()) {
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                QuestionBank qb = new QuestionBank();
                qb.setQuestionId(rs.getInt(1));
                qb.setSubjectId(rs.getInt(2));
                qb.setQuestionContext(rs.getString(3));
                qb.setChoice1(rs.getString(4));
                qb.setChoice2(rs.getString(5));
                qb.setChoice3(rs.getString(6));
                qb.setChoiceCorrect(rs.getString(7));
                qb.setExplain(rs.getString(8));
                qb.setQuestionImg(rs.getString(9));
                qb.setExplainImg(rs.getString(10));
                qb.setUserID(rs.getInt(11));
                list.add(qb);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    //Get all question from exam by exam id
    public List<QuestionBank> getAllQuestionByExamID(int examID) {
        String query = "SELECT * from QuestionBank join ExamQuestion on QuestionBank.question_id = ExamQuestion.question_id where exam_id = ?";
        List<QuestionBank> list = new ArrayList<>();
        try (Connection con = getConnection()) {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, examID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                QuestionBank qb = new QuestionBank();
                qb.setQuestionId(rs.getInt(1));
                qb.setSubjectId(rs.getInt(2));
                qb.setQuestionContext(rs.getString(3));
                qb.setChoice1(rs.getString(4));
                qb.setChoice2(rs.getString(5));
                qb.setChoice3(rs.getString(6));
                qb.setChoiceCorrect(rs.getString(7));
                qb.setExplain(rs.getString(8));
                qb.setQuestionImg(rs.getString(9));
                qb.setExplainImg(rs.getString(10));
                qb.setUserID(rs.getInt(11));
                list.add(qb);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    //Update exam
    //Delete exam
    public void deleteExamByExamID(int examID) {
        List<Tests> list = new StudentExamDAO().getTestByExamID(examID);
        for (Tests test : list) {
            new StudentExamDAO().deleteStudentChoiceByTestID(test.getTestID());
        }
        String query = "delete from ExamPayment where exam_id = ?"
                + "delete from Result where exam_id = ? delete from Tests where exam_id = ?"
                + "DELETE FROM ExamQuestion WHERE exam_id = ?; DELETE FROM Exam WHERE exam_id = ?; DBCC CHECKIDENT (Exam, RESEED, 0); DBCC CHECKIDENT (Exam, RESEED);";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, examID);
            ps.setInt(2, examID);
            ps.setInt(3, examID);
            ps.setInt(4, examID);
            ps.setInt(5, examID);
            try {
                ps.executeUpdate();
            } catch (SQLException e) {
                System.out.println(e);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    //Delete question in exam
    public void deleteQuestionInExam(int questionID, int examID) {
        String query = "ALTER TABLE ExamQuestion DROP CONSTRAINT fk_question_id_examquestion; "
                + "DELETE FROM ExamQuestion WHERE exam_id = ? and question_id = ?;"
                + "delete from StudentChoice where question_id = ?"
                + " DBCC CHECKIDENT (ExamQuestion, RESEED, 0); DBCC CHECKIDENT (ExamQuestion, RESEED);"
                + "ALTER TABLE ExamQuestion ADD CONSTRAINT fk_question_id_examquestion FOREIGN KEY (question_id) REFERENCES QuestionBank(question_id);";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, examID);
            ps.setInt(2, questionID);
            ps.setInt(3, questionID);
            try {
                ps.executeUpdate();
            } catch (SQLException e) {
                System.out.println(e);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    //Add question to certain exam
    public void addQuestionToExam(int questionID, int examID) {
        String query = "DBCC CHECKIDENT (ExamQuestion, RESEED, 0); DBCC CHECKIDENT (ExamQuestion, RESEED); insert into ExamQuestion(question_id, exam_id) values(?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, questionID);
            ps.setInt(2, examID);
            try {
                ps.executeUpdate();
            } catch (SQLException e) {
                System.out.println(e);
            }
        } catch (Exception err) {
            System.out.println(err);
        }
    }

    //Add question to questionBank by userID and subjectID
    public void addQuestionToQuestionBank(QuestionBank qb) {
        String query = "DBCC CHECKIDENT (QuestionBank, RESEED, 0); DBCC CHECKIDENT (QuestionBank, RESEED); insert into QuestionBank(subject_id, question_context, question_choice_1, "
                + "question_choice_2, question_choice_3, question_choice_correct, question_explain, "
                + "question_img, question_explain_img, userID) "
                + "Values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, qb.getSubjectId());
            ps.setString(2, qb.getQuestionContext());
            ps.setString(3, qb.getChoice1());
            ps.setString(4, qb.getChoice2());
            ps.setString(5, qb.getChoice3());
            ps.setString(6, qb.getChoiceCorrect());
            ps.setString(7, qb.getExplain());
            ps.setString(8, qb.getQuestionImg());
            ps.setString(9, qb.getExplainImg());
            ps.setInt(10, qb.getUserID());
            try {
                ps.executeUpdate();
            } catch (SQLException e) {
                System.out.println(e);
            }
        } catch (Exception err) {
            System.out.println(err);
        }
    }

    public String getCreatorUsername(int examID) {
        // Assuming Exam has a creatorID field that links to the user who created the exam
        String query = "SELECT u.username FROM Users u JOIN Exam e ON u.userID = e.creatorID WHERE e.examID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, examID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("username");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    //Get latest exam
    public Exam getLastestExam() {
        Exam exam = new Exam();
        String query = "Select top 1 * from Exam order by exam_id desc";
        try (Connection con = getConnection()) {
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                exam.setExamID(rs.getInt(1));
                exam.setExamName(rs.getString(2));
                exam.setCreateDate(rs.getString(3));
                exam.setUserID(rs.getInt(4));
                exam.setSubjectID(rs.getInt(5));
                exam.setTimer(rs.getInt(6));
                exam.setPrice(rs.getInt(7));
                return exam;
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return null;
    }

    //change exam name UPDATE Exam SET exam_name = ? WHERE exam_id = ?
    public void changeExamName(int examID, String examName) {
        String query = "UPDATE Exam SET exam_name = ? WHERE exam_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, examName);
            ps.setInt(2, examID);
            try {
                ps.executeUpdate();
            } catch (SQLException e) {
                System.out.println(e);
            }
        } catch (Exception err) {
            System.out.println(err);
        }
    }

    public int countAttemptExam(int examID) {
        String query = "SELECT exam_id, COUNT(*) AS total_attempts  \n"
                + "FROM Result\n"
                + "where exam_id = ?\n"
                + "GROUP BY exam_id;";
        int result = 0;
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, examID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                result = rs.getInt("total_attempts");
            }
        } catch (Exception err) {
            System.out.println(err);
        }

        return result;
    }

    //change exam time
    public void changeExamTime(int examID, int timer) {
        String query = "UPDATE Exam SET timer = ? and is_approved = false WHERE exam_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, timer);
            ps.setInt(2, examID);
            ResultSet rs = ps.executeQuery();
            try {
                ps.executeUpdate();
            } catch (SQLException e) {
                System.out.println(e);
            }
        } catch (Exception err) {
            System.out.println(err);
        }
    }

    //Add result
    //DOC/Excel reader
    //Get random question (SELECT * FROM forum_comment ORDER BY NEWID())
    public List<QuestionBank> getRandomQuestByAmount(int amount, int subjectID) {
        String query = "SELECT top " + amount + " * FROM QuestionBank Where subject_id = ? ORDER BY NEWID()";
        List<QuestionBank> list = new ArrayList<>();
        try (Connection con = getConnection()) {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, subjectID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                QuestionBank qb = new QuestionBank();
                qb.setQuestionId(rs.getInt(1));
                qb.setSubjectId(rs.getInt(2));
                qb.setQuestionContext(rs.getString(3));
                qb.setChoice1(rs.getString(4));
                qb.setChoice2(rs.getString(5));
                qb.setChoice3(rs.getString(6));
                qb.setChoiceCorrect(rs.getString(7));
                qb.setExplain(rs.getString(8));
                qb.setQuestionImg(rs.getString(9));
                qb.setExplainImg(rs.getString(10));
                qb.setUserID(rs.getInt(11));
                list.add(qb);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    //get random quest by amount and not duplicate by subject id, amount and exam id
    public List<QuestionBank> getRandomQuestByAmountND(int amount, int subjectID, int exam_id, int userID) {
        String query;
        List<QuestionBank> list = new ArrayList<>();
        if (userID != 1) {
            query = "select top " + amount + " * from QuestionBank "
                    + "left join ExamQuestion on QuestionBank.question_id = ExamQuestion.question_id and exam_id = ? "
                    + "WHERE ExamQuestion.question_id IS NULL and subject_id = ? and (userID = 1 or userID = ?) ORDER BY NEWID()";
            try (Connection con = getConnection()) {
                PreparedStatement ps = con.prepareStatement(query);
                ps.setInt(1, exam_id);
                ps.setInt(2, subjectID);
                ps.setInt(3, userID);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    QuestionBank qb = new QuestionBank();
                    qb.setQuestionId(rs.getInt(1));
                    qb.setSubjectId(rs.getInt(2));
                    qb.setQuestionContext(rs.getString(3));
                    qb.setChoice1(rs.getString(4));
                    qb.setChoice2(rs.getString(5));
                    qb.setChoice3(rs.getString(6));
                    qb.setChoiceCorrect(rs.getString(7));
                    qb.setExplain(rs.getString(8));
                    qb.setQuestionImg(rs.getString(9));
                    qb.setExplainImg(rs.getString(10));
                    qb.setUserID(rs.getInt(11));
                    list.add(qb);
                }
            } catch (Exception e) {
                System.out.println(e);
            }
        } else {
            query = "select top " + amount + " * from QuestionBank "
                    + "left join ExamQuestion on QuestionBank.question_id = ExamQuestion.question_id and exam_id = ? "
                    + "WHERE ExamQuestion.question_id IS NULL and subject_id = ? and userID = 1 ORDER BY NEWID()";
            try (Connection con = getConnection()) {
                PreparedStatement ps = con.prepareStatement(query);
                ps.setInt(1, exam_id);
                ps.setInt(2, subjectID);
                ps.setInt(3, userID);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    QuestionBank qb = new QuestionBank();
                    qb.setQuestionId(rs.getInt(1));
                    qb.setSubjectId(rs.getInt(2));
                    qb.setQuestionContext(rs.getString(3));
                    qb.setChoice1(rs.getString(4));
                    qb.setChoice2(rs.getString(5));
                    qb.setChoice3(rs.getString(6));
                    qb.setChoiceCorrect(rs.getString(7));
                    qb.setExplain(rs.getString(8));
                    qb.setQuestionImg(rs.getString(9));
                    qb.setExplainImg(rs.getString(10));
                    qb.setUserID(rs.getInt(11));
                    list.add(qb);
                }
            } catch (Exception e) {
                System.out.println(e);
            }
        }
        return list;
    }

    //Get all subject
    public List<Subjects> getAllSubject() {
        String query = "select * from Subjects";
        List<Subjects> list = new ArrayList<>();
        try (Connection con = getConnection()) {
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Subjects subject = new Subjects();
                subject.setSubjectID(rs.getInt(1));
                subject.setSubjectName(rs.getString(2));
                subject.setSubjectImg(rs.getString(3));
                list.add(subject);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    //Get subject by subjectID
    public Subjects getSubjectByID(int subjectID) {
        String query = "select * from Subjects where subject_id = ?";
        Subjects subject = new Subjects();
        try (Connection con = getConnection()) {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, subjectID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                subject.setSubjectID(rs.getInt(1));
                subject.setSubjectName(rs.getString(2));
                subject.setSubjectImg(rs.getString(3));
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return subject;
    }

    //Get all question from exam
    public int getQuestionAmount(int examID) {
        int sum = 0;
        String query = "select Count(exam_id) from ExamQuestion where exam_id = ?";
        try (Connection con = getConnection()) {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, examID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                sum += rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return sum;
    }

    //Get max number of question from subject with userID
    public int getMaxQuestion(int userID, int subjectID) {
        String query;
        int sum = 0;
        if (userID != 1) {
            query = "select Count(subject_id) from QuestionBank where subject_id = ? and userID = 1";
            sum = 0;
            try (Connection con = getConnection()) {
                PreparedStatement ps = con.prepareStatement(query);
                ps.setInt(1, subjectID);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    sum += rs.getInt(1);
                }
            } catch (Exception e) {
                System.out.println(e);
            }
        }

        query = "select Count(subject_id) from QuestionBank where subject_id = ? and userID = ?";
        try (Connection con = getConnection()) {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, subjectID);
            ps.setInt(2, userID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                sum += rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return sum;
    }

    //Get all system question from subject using subject ID
    public List<QuestionBank> getAllSystemQuestionByID(int subjectID) {
        String query = "select * from QuestionBank where userID = 1 and subject_id = ?";
        List<QuestionBank> list = new ArrayList<>();
        try (Connection con = getConnection()) {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, subjectID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                QuestionBank qb = new QuestionBank();
                qb.setQuestionId(rs.getInt(1));
                qb.setSubjectId(rs.getInt(2));
                qb.setQuestionContext(rs.getString(3));
                qb.setChoice1(rs.getString(4));
                qb.setChoice2(rs.getString(5));
                qb.setChoice3(rs.getString(6));
                qb.setChoiceCorrect(rs.getString(7));
                qb.setExplain(rs.getString(8));
                qb.setQuestionImg(rs.getString(9));
                qb.setExplainImg(rs.getString(10));
                qb.setUserID(rs.getInt(11));
                list.add(qb);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    public List<QuestionBank> getAllSystemQuestion() {
        String query = "select * from QuestionBank where userID = 1";
        List<QuestionBank> list = new ArrayList<>();
        try (Connection con = getConnection()) {
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                QuestionBank qb = new QuestionBank();
                qb.setQuestionId(rs.getInt(1));
                qb.setSubjectId(rs.getInt(2));
                qb.setQuestionContext(rs.getString(3));
                qb.setChoice1(rs.getString(4));
                qb.setChoice2(rs.getString(5));
                qb.setChoice3(rs.getString(6));
                qb.setChoiceCorrect(rs.getString(7));
                qb.setExplain(rs.getString(8));
                qb.setQuestionImg(rs.getString(9));
                qb.setExplainImg(rs.getString(10));
                qb.setUserID(rs.getInt(11));
                list.add(qb);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    // Get all questions from user using userID without subjectID
    public List<QuestionBank> getAllUserQuestionsByID(int userID) {
        String query = "SELECT * FROM QuestionBank WHERE userID = ?"; // Chỉ lọc theo userID
        List<QuestionBank> list = new ArrayList<>();
        try (Connection con = getConnection()) {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, userID); // Chỉ sử dụng userID
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                QuestionBank qb = new QuestionBank();
                qb.setQuestionId(rs.getInt(1));
                qb.setSubjectId(rs.getInt(2));
                qb.setQuestionContext(rs.getString(3));
                qb.setChoice1(rs.getString(4));
                qb.setChoice2(rs.getString(5));
                qb.setChoice3(rs.getString(6));
                qb.setChoiceCorrect(rs.getString(7));
                qb.setExplain(rs.getString(8));
                qb.setQuestionImg(rs.getString(9));
                qb.setExplainImg(rs.getString(10));
                qb.setUserID(rs.getInt(11));
                list.add(qb);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    //Get all question from user using userID
    public List<QuestionBank> getAllUserQuestionByID(int subjectID, int userID) {
        String query = "select * from QuestionBank where userID = ? and subject_id = ?";
        List<QuestionBank> list = new ArrayList<>();
        try (Connection con = getConnection()) {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, userID);
            ps.setInt(2, subjectID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                QuestionBank qb = new QuestionBank();
                qb.setQuestionId(rs.getInt(1));
                qb.setSubjectId(rs.getInt(2));
                qb.setQuestionContext(rs.getString(3));
                qb.setChoice1(rs.getString(4));
                qb.setChoice2(rs.getString(5));
                qb.setChoice3(rs.getString(6));
                qb.setChoiceCorrect(rs.getString(7));
                qb.setExplain(rs.getString(8));
                qb.setQuestionImg(rs.getString(9));
                qb.setExplainImg(rs.getString(10));
                qb.setUserID(rs.getInt(11));
                list.add(qb);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    //Get all question from subject using subject ID
    public List<QuestionBank> getAllQuestionByID(int subjectID, int userID) {
        String query;
        List<QuestionBank> list = new ArrayList<>();
        if (userID != 1) {
            query = "select * from QuestionBank where userID = 1 and subject_id = ?";
            try (Connection con = getConnection()) {
                PreparedStatement ps = con.prepareStatement(query);
                ps.setInt(1, subjectID);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    QuestionBank qb = new QuestionBank();
                    qb.setQuestionId(rs.getInt(1));
                    qb.setSubjectId(rs.getInt(2));
                    qb.setQuestionContext(rs.getString(3));
                    qb.setChoice1(rs.getString(4));
                    qb.setChoice2(rs.getString(5));
                    qb.setChoice3(rs.getString(6));
                    qb.setChoiceCorrect(rs.getString(7));
                    qb.setExplain(rs.getString(8));
                    qb.setQuestionImg(rs.getString(9));
                    qb.setExplainImg(rs.getString(10));
                    qb.setUserID(rs.getInt(11));
                    list.add(qb);
                }
            } catch (Exception e) {
                System.out.println(e);
            }
        }

        query = "select * from QuestionBank where userID = ? and subject_id = ?";
        try (Connection con = getConnection()) {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, userID);
            ps.setInt(2, subjectID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                QuestionBank qb = new QuestionBank();
                qb.setQuestionId(rs.getInt(1));
                qb.setSubjectId(rs.getInt(2));
                qb.setQuestionContext(rs.getString(3));
                qb.setChoice1(rs.getString(4));
                qb.setChoice2(rs.getString(5));
                qb.setChoice3(rs.getString(6));
                qb.setChoiceCorrect(rs.getString(7));
                qb.setExplain(rs.getString(8));
                qb.setQuestionImg(rs.getString(9));
                qb.setExplainImg(rs.getString(10));
                qb.setUserID(rs.getInt(11));
                list.add(qb);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    //Get question that not selected to exam
    public List<QuestionBank> getAllQuestionNotInExam(int subjectID, int userID, int examID) {
        String query;
        List<QuestionBank> list = new ArrayList<>();
        if (userID != 1) {
            query = " select * from QuestionBank "
                    + "left join ExamQuestion on QuestionBank.question_id = ExamQuestion.question_id and exam_id = ? "
                    + "WHERE ExamQuestion.question_id IS NULL and subject_id = ? and userID = 1";
            try (Connection con = getConnection()) {
                PreparedStatement ps = con.prepareStatement(query);
                ps.setInt(1, examID);
                ps.setInt(2, subjectID);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    QuestionBank qb = new QuestionBank();
                    qb.setQuestionId(rs.getInt(1));
                    qb.setSubjectId(rs.getInt(2));
                    qb.setQuestionContext(rs.getString(3));
                    qb.setChoice1(rs.getString(4));
                    qb.setChoice2(rs.getString(5));
                    qb.setChoice3(rs.getString(6));
                    qb.setChoiceCorrect(rs.getString(7));
                    qb.setExplain(rs.getString(8));
                    qb.setQuestionImg(rs.getString(9));
                    qb.setExplainImg(rs.getString(10));
                    qb.setUserID(rs.getInt(11));
                    list.add(qb);
                }
            } catch (Exception e) {
                System.out.println(e);
            }
        }

        query = "select * from QuestionBank left join ExamQuestion on QuestionBank.question_id = ExamQuestion.question_id and exam_id = ? WHERE ExamQuestion.question_id IS NULL and subject_id = ? and userID = ?";
        try (Connection con = getConnection()) {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, examID);
            ps.setInt(2, subjectID);
            ps.setInt(3, userID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                QuestionBank qb = new QuestionBank();
                qb.setQuestionId(rs.getInt(1));
                qb.setSubjectId(rs.getInt(2));
                qb.setQuestionContext(rs.getString(3));
                qb.setChoice1(rs.getString(4));
                qb.setChoice2(rs.getString(5));
                qb.setChoice3(rs.getString(6));
                qb.setChoiceCorrect(rs.getString(7));
                qb.setExplain(rs.getString(8));
                qb.setQuestionImg(rs.getString(9));
                qb.setExplainImg(rs.getString(10));
                qb.setUserID(rs.getInt(11));
                list.add(qb);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    //Get question by questionID
    public QuestionBank getQuestionByID(int questionID) {
        String query = "select * from QuestionBank where question_id = ?";
        QuestionBank qb = new QuestionBank();
        try (Connection con = getConnection()) {
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, questionID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                qb.setQuestionId(rs.getInt(1));
                qb.setSubjectId(rs.getInt(2));
                qb.setQuestionContext(rs.getString(3));
                qb.setChoice1(rs.getString(4));
                qb.setChoice2(rs.getString(5));
                qb.setChoice3(rs.getString(6));
                qb.setChoiceCorrect(rs.getString(7));
                qb.setExplain(rs.getString(8));
                qb.setQuestionImg(rs.getString(9));
                qb.setExplainImg(rs.getString(10));
                qb.setUserID(rs.getInt(11));
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return qb;
    }

    public void incrementViewCount(int examID) {
        String query = "UPDATE Exam SET view_count = view_count + 1 WHERE exam_id = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, examID);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
//        List<QuestionBank> subjects = new ExamDAO().getRandomQuestByAmount(5, 8);

        int a = new ExamDAO().countAttemptExam(15);
        System.out.println(a);
//        for (QuestionBank subject : subjects) {
//            System.out.println(subject.toString());
//        }
    }
}
