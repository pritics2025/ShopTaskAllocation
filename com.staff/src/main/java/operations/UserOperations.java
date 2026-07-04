package operations;

import java.util.List;

import model.User;

public interface UserOperations {

    public boolean addUser (User user);
    List<User> getAllUsers();
    public User getUserbyUsername(String username);
    public User getUserbyId(int userId);
    public boolean updateUser (User user);
    public boolean deleteUser (int userId);
}