package model;

public class User {
    private int userId;
    private String username;
    private String password;
    private String role;  // 'admin' or 'staff'
    private String name;
    private String contact;
    
    // Constructors
    public User() {}
    
    public User(String username, String password, String role, String name) {
        this.username = username;
        this.password = password;
        this.role = role;
        this.name = name;
    }
    
    // Getters/Setters
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getContact() { return contact; }
    public void setContact(String contact) { this.contact = contact; }
}