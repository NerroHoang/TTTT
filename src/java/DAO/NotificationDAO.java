package DAO;

import static DAO.DBConnection.getConnection;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

import java.util.List;

import model.Forum;

import model.Notification;

public class NotificationDAO extends DBConnection {

    public void createNewNotification(int userID, String notificationName, String notificationCreateDate) {

        String query = "insert into notifications(userID,noti_name,noti_create_date)"
                + "values(?, ?, ?)";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, userID);

            ps.setString(2, notificationName);

            String timeStamp = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss").format(new java.util.Date());

            ps.setString(3, timeStamp);

            try {

                ps.executeUpdate();

            } catch (Exception e) {

                System.out.println(e);

            }

        } catch (Exception err) {

            System.out.println(err);

        }

    }

    public List<Notification> getTop3Notifications() {
        String query = "SELECT TOP 3 noti_name, noti_create_date FROM notifications ORDER BY noti_create_date DESC;";
        List<Notification> notifications = new ArrayList<>();
        try (Connection con = getConnection()) {
            PreparedStatement ps = con.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Notification noti = new Notification();
                noti.setNotiName(rs.getString(1));
                noti.setNotiCreateDate(rs.getString(2));
                notifications.add(noti);
            }

        } catch (SQLException e) {

            e.printStackTrace();

        } catch (Exception e) {

            System.out.println(e);

        }

        return notifications;

    }

    public List<Notification> getAllNotification() {

        String query = "select * from notifications";

        List<Notification> notis = new ArrayList<>();

        try (Connection con = getConnection()) {

            PreparedStatement ps = con.prepareStatement(query);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Notification noti = new Notification();

                noti.setNotiID(rs.getInt(1));

                noti.setNotiName(rs.getString(2));

                noti.setNotiCreateDate(rs.getString(3));

                notis.add(noti);

            }

        } catch (Exception e) {

            System.out.println(e);

        }

        return notis;

    }

    public void updateNotificationByID(int notiID, String notificationName, String notificationCreateDate) {

        String query = "update notifications set noti_name = ?, noti_create_date = ? where notiID = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, notificationName);

            ps.setString(2, notificationCreateDate);

            ps.setInt(4, notiID);

            try {

                ps.executeUpdate();

            } catch (Exception e) {

                System.out.println(e);

            }

        } catch (Exception e) {

            System.out.println(e);

        }

    }

    public void deleteNotificationByID(int notiID) {

        String query = "delete from notifications where notiID =?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, notiID);

            try {

                ps.executeUpdate();

            } catch (Exception e) {

                System.out.println(e);

            }

        } catch (Exception e) {

            System.out.println(e);

        }

    }

    public List<Notification> getAllNotificationByUserID(int userID) {

        String query = "select * from notifications where userID = ?";

        List<Notification> notis = new ArrayList<>();

        try (Connection con = getConnection()) {

            PreparedStatement ps = con.prepareStatement(query);

            ps.setInt(1, userID);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Notification noti = new Notification();

                noti.setNotiName(rs.getString(1));

                noti.setNotiCreateDate(rs.getString(2));

                notis.add(noti);

            }

        } catch (Exception e) {

            System.out.println(e);

        }

        return notis;

    }

}
