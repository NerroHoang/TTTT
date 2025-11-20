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
import model.*;


public class SubjectDAO extends DBConnection {

    public List<Subjects> getAllSubjects() {
        List<Subjects> subjectList = new ArrayList<>();
        String query = "SELECT subject_id, subject_name FROM Subjects";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int subjectID = rs.getInt("subject_id");
                String subjectName = rs.getString("subject_name");
                subjectList.add(new Subjects(subjectID, subjectName, null));
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return subjectList;
    }

    public String getSubjectNameById(int subjectId) {
        String subjectName = null;
        String query = "SELECT subject_name FROM Subjects WHERE subject_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, subjectId);  // Set the subjectId parameter
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                subjectName = rs.getString("subject_name");  // Get the subject name
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return subjectName;
    }
}
