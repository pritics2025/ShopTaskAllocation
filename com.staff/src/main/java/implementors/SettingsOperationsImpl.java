package implementors;

import operations.SettingsOperations;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import model.Setting;

public class SettingsOperationsImpl implements SettingsOperations {
    private Connection conn;

    public SettingsOperationsImpl(Connection conn) {
        this.conn = conn;
    }

    @Override
    public List<Setting> getAllSettings() {
        List<Setting> list = new ArrayList<>();
        try {
            String sql = "SELECT * FROM settings";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql);
            while(rs.next()) {
                list.add(new Setting(rs.getInt("id"), rs.getString("key"), rs.getString("value")));
            }
        } catch(SQLException e){
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean updateSetting(Setting setting) {
        try {
            String sql = "UPDATE settings SET value=? WHERE key=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, setting.getValue());
            ps.setString(2, setting.getKey());
            return ps.executeUpdate() > 0;
        } catch(SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public Setting getSettingByKey(String key) {
        Setting setting = null;
        try {
            String sql = "SELECT * FROM settings WHERE key=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, key);
            ResultSet rs = ps.executeQuery();
            if(rs.next()) {
                setting = new Setting(rs.getInt("id"), rs.getString("key"), rs.getString("value"));
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return setting;
    }
}