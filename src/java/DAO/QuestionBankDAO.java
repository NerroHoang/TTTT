/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.*;

/**
 *
 * @author Admin
 */
public class QuestionBankDAO extends DBConnection {

    public List<QuestionBank> getQuestionsPageSize(int start, int pageSize) {
        List<QuestionBank> questionBanks = new ArrayList<>();
        String query = "SELECT * FROM QuestionBank ORDER BY question_id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, start);
            ps.setInt(2, pageSize);
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
                questionBanks.add(qb);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return questionBanks;
    }

    public int getTotalQuestions() {
        String query = "SELECT COUNT(*) FROM QuestionBank";
        try (Connection connection = getConnection(); PreparedStatement stmt = connection.prepareStatement(query)) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;

    }

    

}
