package implementors;
import model.Report;
import operations.ReportOperations;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

public class ReportOperationsImpl implements ReportOperations {

    private Connection conn;

    public ReportOperationsImpl(Connection conn) {
        this.conn = conn;
    }

    @Override
    public Report generateSummaryReport() {
        Report report = new Report();
        try {
            Statement st = conn.createStatement();

            ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM tasks");
            rs.next();
            report.setTotalTasks(rs.getInt(1));

            rs = st.executeQuery("SELECT COUNT(*) FROM users");
            rs.next();
            report.setTotalUsers(rs.getInt(1));

            rs = st.executeQuery("SELECT COUNT(*) FROM allocations WHERE status='Pending'");
            rs.next();
            report.setPendingAllocations(rs.getInt(1));

            report.setTitle("System Summary report");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return report;
    }
}